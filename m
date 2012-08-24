Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554Ab2HXOKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 10:10:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55651 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab2HXOKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 10:10:02 -0400
Message-ID: <50378B35.80307@lwfinger.net>
Date: Fri, 24 Aug 2012 09:09:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        John W Linville <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression associated with commit c8628155ece3 - "tcp: reduce
 out_of_order memory use"
References: <50345B12.1050600@lwfinger.net>  <1345612503.5158.566.camel@edumazet-glaptop>  <50355021.7000408@lwfinger.net> <1345694593.5904.87.camel@edumazet-glaptop>  <50369925.3050705@lwfinger.net> <1345757200.5904.1890.camel@edumazet-glaptop>
In-Reply-To: <1345757200.5904.1890.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 04:26 PM, Eric Dumazet wrote:
>
> skb->truesize is adjusted when a frag is added to one skb, or when
> skb->head is re-allocated.
>
> Are you sure you dont have another problem, because as I said commit
> c8628155ece3  had a bug, so a bisect is not very useful.
>
> How many reloads are needed to trigger the bug, do you have a script to
> reproduce it ?

I was doing the tests with a browser; however, it seems that a wget of that same 
page is much more effective at triggering the problem. Now I have a script that 
tries 60 passes of

wget https://bugzilla.redhat.com/show_bug.cgi?id=847525

I usually get failures on the first or second try. A kernel built from "git 
checkout c862815" gets the following wget output:

============================================================================
--2012-08-23 21:50:32--  https://bugzilla.redhat.com/show_bug.cgi?id=847525
Resolving bugzilla.redhat.com (bugzilla.redhat.com)... 209.132.183.69
Connecting to bugzilla.redhat.com (bugzilla.redhat.com)|209.132.183.69|:443... 
connected.
OpenSSL: error:0D0680A8:asn1 encoding routines:ASN1_CHECK_TLEN:wrong tag
OpenSSL: error:0D07803A:asn1 encoding routines:ASN1_ITEM_EX_D2I:nested asn1 error
OpenSSL: error:0D08303A:asn1 encoding routines:ASN1_TEMPLATE_NOEXP_D2I:nested 
asn1 error
OpenSSL: error:0D08303A:asn1 encoding routines:ASN1_TEMPLATE_NOEXP_D2I:nested 
asn1 error
OpenSSL: error:1409000D:SSL routines:SSL3_GET_SERVER_CERTIFICATE:ASN1 lib
Unable to establish SSL connection.
============================================================================

With kernel 3.6-rc2, the error changes to the following:

============================================================================
--2012-08-24 08:26:42--  https://bugzilla.redhat.com/show_bug.cgi?id=847525
Resolving bugzilla.redhat.com (bugzilla.redhat.com)... 209.132.183.69
Connecting to bugzilla.redhat.com (bugzilla.redhat.com)|209.132.183.69|:443... 
connected.
HTTP request sent, awaiting response... 200 OK
Length: unspecified [text/html]
Saving to: `show_bug.cgi?id=847525.3'

     [ <=>                          ] 0           --.-K/s   in 0s

2012-08-24 08:26:45 (0.00 B/s) - Read error at byte 0 (error:1408F119:SSL 
routines:SSL3_GET_RECORD:decryption failed or bad record mac).Retrying.
============================================================================

> Could it be a PMTU problem ? (check
> http://git.kernel.org/?p=linux/kernel/git/davem/net.git;a=commit;h=9b04f350057863d1fad1ba071e09362a1da3503e )

I added the PMTU patch to kernel 3.6-rc2 - nothing changed.

Anything else to try?

Thanks,

Larry


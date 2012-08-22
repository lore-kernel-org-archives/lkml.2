Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab2HVVd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 17:33:28 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64242 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733Ab2HVVd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 17:33:26 -0400
Message-ID: <50355021.7000408@lwfinger.net>
Date: Wed, 22 Aug 2012 16:33:21 -0500
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
References: <50345B12.1050600@lwfinger.net> <1345612503.5158.566.camel@edumazet-glaptop>
In-Reply-To: <1345612503.5158.566.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 12:15 AM, Eric Dumazet wrote:
>
> This particular commit is the start of a patches batch that ended in the
> generic TCP coalescing mechanism.
>
> It is known to have problem on drivers doing skb_clone() in their rx
> path.
>
> Current kernels should be ok, because coalescing doesnt happen if the
> destination skb is cloned (skb_cloned(to) in skb_try_coalesce())

The skb_clone() call is not the source of the problem for r8712u, as it is only 
used when a memory allocation fails, which is not happening. The suggestion did 
lead to another patch that I had been preparing. The initial allocation of RX 
buffers used a size of 30720 bytes, while 9100 is sufficient to allow 
aggregation. Upon reducing the buffer size, the driver now works for me. I am 
now awaiting tests by the OP on the Red Hat bugzilla before sending the patch 
upstream.

So far, no ideas for the problem in connecting to WPA1 networks.

Larry



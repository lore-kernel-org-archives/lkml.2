Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab0FNMzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 08:55:54 -0400
Received: from lo.gmane.org ([80.91.229.12]:41360 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602Ab0FNMzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 08:55:52 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: walt <w41ter@gmail.com>
Subject: Re: Noticeable slow-down in 2.6.35-rc3
Date: Mon, 14 Jun 2010 05:55:39 -0700
Message-ID: <hv58sc$b1b$1@dough.gmane.org>
References: <AANLkTimDUf0N6b5PBy2wTGeAWEIY-lUvQPHQ7D7Gyrq4@mail.gmail.com> <201006132158.09216.chris2553@googlemail.com> <201006132211.03744.chris2553@googlemail.com> <201006131813.04096.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-187-40.dsl.irvnca.pacbell.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.3a6pre) Gecko/20100613 Thunderbird/3.2a1pre
In-Reply-To: <201006131813.04096.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2010 03:13 PM, Gene Heskett wrote:

> Unfortunately, this patch will not apply to my src tree for 2.6.35-rc3,
> even after I fixed the unwanted line wrap in the first active line.
>
> I get:
>
> [root@coyote linux-2.6.35-rc3]# patch -p1<../2.6.35-rc3-test.patch
> patching file net/core/skbuff.c
> Hunk #1 FAILED at 532.
> 1 out of 1 hunk FAILED -- saving rejects to file net/core/skbuff.c.rej
>
> Did my grabbing it with swiftfox damage it even further?
> ------------------------------------------------------------------
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 9f07e74..bcf2fa3 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -532,6 +532,7 @@ static void __copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
>    	new-&gt;ip_summed		= old-&gt;ip_summed;

I don't know what caused the corruption, but it's a systematic error.
Throughout the patch, the dereference symbol -> has been changed to
-& so it's not surprising that the patch won't apply.  I've never seen
that particular problem before.

I don't think the line numbers (e.g.532) are responsible.


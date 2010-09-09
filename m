Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab0IIHPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 03:15:19 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43290 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab0IIHPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 03:15:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xUMqJkyjZ2lewImFDTVaW63h79LtKaHnTegidWSil2MvNQEXUq0dYuUm0i7Oz93qtU
         ZZKNRIAjRPZXl/xdTvGIDJxe45W4aiga26NbueO+fGon0kzntErE4i19u0zS73cRhiPF
         42jROIm6bw54GlpHkSxNfmV5raWPO03OJ5LUA=
Date: Thu, 9 Sep 2010 11:15:07 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Albert Herranz <albert_herranz@yahoo.es>,
        Matt Fleming <matt@console-pimps.org>, Ben Dooks <ben-linux@fluff.org>,
        Pierre Ossman <pierre@ossman.eu>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/8] sdhci: Move real work out of an atomic context
Message-ID: <20100909071507.GA14308@oksana.dev.rtsoft.ru>
References: <20100714130728.GA27339@oksana.dev.rtsoft.ru>
 <20100907153813.936db0c6.akpm@linux-foundation.org>
 <20100908213740.GA7550@void.printf.net>
 <20100909022834.GA10542@void.printf.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100909022834.GA10542@void.printf.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 03:28:34AM +0100, Chris Ball wrote:
[...]
> [    7.372843]  [<b04193ce>] __might_sleep+0xd9/0xe0
> [    7.387864]  [<b07260cc>] mutex_lock+0x1c/0x2a
> [    7.402576]  [<b06396e8>] sdhci_led_control+0x1a/0x41
> [    7.417727]  [<b063bece>] led_trigger_event+0x42/0x5c

led_trigger_even grabs a readlock. :-(

> [    7.432807]  [<b06326f8>] mmc_request_done+0x56/0x6f
> [    7.447597]  [<b063a2d1>] sdhci_finish_work+0xc8/0xcd
> [    7.462643]  [<b063a209>] ? sdhci_finish_work+0x0/0xcd
> [    7.477941]  [<b0432776>] worker_thread+0x165/0x1ed
> [    7.492856]  [<b063a209>] ? sdhci_finish_work+0x0/0xcd
> [    7.508204]  [<b0435591>] ? autoremove_wake_function+0x0/0x34
> [    7.524178]  [<b0432611>] ? worker_thread+0x0/0x1ed
> [    7.538953]  [<b04352a0>] kthread+0x63/0x68
> [    7.552659]  [<b043523d>] ? kthread+0x0/0x68
> [    7.566349]  [<b0402cf6>] kernel_thread_helper+0x6/0x10
> [    7.709931] udev: starting version 141
> [    7.940374] mmc2: new high speed SDHC card at address e4da
> [    8.058165] mmcblk0: mmc2:e4da SU04G 3.69 GiB 
> [    8.135730]  mmcblk0: p1 p2
> 
> Full dmesg is at http://chris.printf.net/anton-mutex-dmesg.txt. 
> Anton, the kernel is 2.6.35.4-olpc plus your patchset from -mm.
> I can think about how to test on an upstream kernel instead, but
> perhaps your own tests simply didn't hit sdhci_led_control(). 

Yep, LEDS support was turned off.

> Andrew, if you want to drop this while the BUG() and potential
> performance regressions are worked out, I'd be happy to keep 
> testing patches from Anton until it's without regressions here.

Thanks Chris.

I also think that it's better to drop these series now,
and meanwhile I'll try to prepare another patchset.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2

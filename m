Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab1CTLm5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 07:42:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40675 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab1CTLmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 07:42:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=j3U4gvAzv2y0ITILJePfjwmEQlX/prFMBUEJ6w/gw8CBPJbLJbLzyJiRX4HmvSPDf8
         Pctx/bUkKtXWV1N3RjroJ8Vdgettb5P0RsETclNFwExODknM6j2fHfshiiu4b4yl7Vpj
         +hd42fGljbwIlPuxKROb0/T6xmUAfTNxZVQQE=
Subject: Re: [PATH 0/4] Memstick patches for 2.6.39
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org, oakad@yahoo.com
In-Reply-To: <20110319234701.0eab3744.akpm@linux-foundation.org>
References: <1299212213-4255-1-git-send-email-maximlevitsky@gmail.com>
	 <1299947013.17988.0.camel@maxim-laptop> <1300219210.13493.0.camel@MAIN>
	 <20110315140402.334cc55c.akpm@linux-foundation.org>
	 <1300590545.15453.3.camel@maxim-laptop>
	 <20110319234701.0eab3744.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Mar 2011 13:42:51 +0200
Message-ID: <1300621371.15768.11.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-03-19 at 23:47 -0700, Andrew Morton wrote:
> On Sun, 20 Mar 2011 05:09:05 +0200 Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > On Tue, 2011-03-15 at 14:04 -0700, Andrew Morton wrote:
> > > On Tue, 15 Mar 2011 22:00:10 +0200
> > > Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > > 
> > > > On Sat, 2011-03-12 at 18:23 +0200, Maxim Levitsky wrote:
> > > > > On Fri, 2011-03-04 at 06:16 +0200, Maxim Levitsky wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > This is a repost of my patches for 2.6.39 inclusion, which I hope not to
> > > > > > miss this time.
> > > > > > 
> > > > > > I addressed the comments on the scatterlist issues.
> > > > > > 
> > > > > > Andrew, please note that my richoh memstick driver is standalone, unchanged from previos versions
> > > > > > has many users which use the version I posted at ubuntu's Launchpad and happy with it.
> > > > > > Please include it regardless of other patches.
> > > > > > 
> > > > > > The other half of my work is support for legacy memorysticks which consists of 2 patches,
> > > > > > first that adds few functions to scatterlist.c, and the other patch that adds the driver.
> > > > > > Driver is also stable and tested.
> > > > > > 
> > > > > > Best regards,
> > > > > > 	Maxim Levitsky
> > > > > 
> > > > > 
> > > > > Any update?
> > > > 
> > > > Any update?
> > > > 
> > > 
> > > I'm hoping that Alex will soon have time to (re)review these patches.
> > 
> > Andrew Morton, what the current state now?
> > 
> 
> Technical discussion is ongoing.  James has described what appears to
> be the architecturally preferred way of implementing this and there is
> as yet no followup to his suggestion.
> 

But I will at least see my r592 driver in kernel?
It doesn't depend on ether ms legacy driver nor on changes in
scatterlist.c

Also, I don't have much time now to improve the ms_block driver till
this summer (studying).
The driver works. Yes it has a flaw in regard to scatterlist processing,
because I didn't find a better way to deal with this monster, but I will
fix that later. I am not the kind of guy that runs away after a merge.
It would be nice to just see my code in kernel, code I wrote more that a
year ago.

This flaw is purely theoretical. Driver does work.

One of the ways to fix this is just use plain good kernel pointers.
Yes that means bouncing of high mem, but like they say "to hell with
that". The driver deals with legacy, and quite slow devices, so there
won't be any performance difference.
Besides, my other driver for that card reader, for xD portion, does
precisely that (more correctly common code in FTL frontend, the
mtd_blkdev.c does that) and the end result is quite good.


So, I am waiting for a word from you,


-- 
Thanks in advance,
Best regards,
        Maxim Levitsky

Visit my blog: http://maximlevitsky.wordpress.com
Warning: Above blog contains rants.


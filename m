Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab1A1C6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 21:58:30 -0500
Received: from kroah.org ([198.145.64.141]:34025 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556Ab1A1C63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 21:58:29 -0500
Date: Thu, 27 Jan 2011 18:55:16 -0800
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, torvalds@linux-foundation.org,
        San Mehat <san@google.com>, Aaron Durbin <adurbin@google.com>,
        Duncan Laurie <dlaurie@google.com>, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>
Subject: Re: [PATCH v1 3/6] driver: Google EFI SMI
Message-ID: <20110128025516.GB32284@kroah.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
 <20110125002449.12637.35623.stgit@mike.mtv.corp.google.com>
 <20110125031752.GA9846@kroah.com>
 <AANLkTi=XhRX-=k8UmmQFshP6fgF_q2c-9gEHuH0mWu0a@mail.gmail.com>
 <20110126024608.GB28283@kroah.com>
 <AANLkTi=rO5QOVjNNWkekOb0WXzKX2CUpgvEryL0cemzB@mail.gmail.com>
 <20110127104343.5931161e@lxorguk.ukuu.org.uk>
 <AANLkTikGJJsnAwiyhrS6m8TJQfR8UHCzZG+t=2GHFRiW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikGJJsnAwiyhrS6m8TJQfR8UHCzZG+t=2GHFRiW@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 11:22:55AM -0800, Mike Waychison wrote:
> On Thu, Jan 27, 2011 at 2:43 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> I understand that type widths change in a compat setting.  So what?
> >> Code in each environment is written to it's own namespace anyhow.
> >
> > So you ned up with a pile of extra crap in the kernel to handle 32bit
> > userspace on 64bit and the like. If instead the structs are carefully
> > laid out this doesn't occur.
> >
> >> Here's what *I* think *you* think about __u32 vs u32 vs uint32_t.
> >> Correct me if I'm totally off-base here:
> >
> > And the __aligned_ ones for things like u64 in ioctls and structs...
> >
> > It's also a style and consistency thing, its trivialto use the same style
> > as the rest of the kernel, it's trivial to tweak and it helps keep
> > coherency of style, even if you are sitting at the keyboard mumbling
> > "bunch of morons if you ask me" while doing it ;)
> 
> I'm always mumbling and cursing at my desk :p
> 
> I've already changed the series to not use C99 types.  I understand
> the value in style consistency :)
> 
> I'm still trying to understand if there is any actual technical merit
> to avoid standard types though, of which there doesn't seem to be any.

Yes there is, it is subtle and prone to get wrong.  Linus wrote it all
up in detail a few years ago and I was going to document it in the
kernel tree somewhere but got busy.

You can dig through the lkml archives for the details but basically
always remember to use them in the following manner:
	u32 - in kernel usage
	__u32 - when the data crosses the kernel/user boundry
	uint32_t - never use

that will ensure you get your code right and no one will complain.

thanks,

greg k-h

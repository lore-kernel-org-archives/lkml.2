Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab1AZQoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 11:44:12 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:35574 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab1AZQoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 11:44:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E56kNM83uj8tRcslXbboVm/nYZ1/ES6dDs5Vso89skBUnKIhuCQIfA/xF0LWgiTgus
         W8hadO12zb8bpOl3M/M5H+vwDSipt36pqNBWJlwCBGfic2CTx1UpkMvEQVGrpaDMbIXS
         FpliW8i/osB0YxufBoHz6rs8XCM+hx8urXeug=
Date: Wed, 26 Jan 2011 08:44:00 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110126164359.GA29163@core.coreip.homeip.net>
References: <20110125053117.GD7850@core.coreip.homeip.net>
 <4D3EB734.5090100@redhat.com>
 <20110125164803.GA19701@core.coreip.homeip.net>
 <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com>
 <20110125205453.GA19896@core.coreip.homeip.net>
 <4D3F4804.6070508@redhat.com>
 <4D3F4D11.9040302@teksavvy.com>
 <20110125232914.GA20130@core.coreip.homeip.net>
 <20110126020003.GA23085@core.coreip.homeip.net>
 <4D403855.4050706@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D403855.4050706@teksavvy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 10:05:57AM -0500, Mark Lord wrote:
> On 11-01-25 09:00 PM, Dmitry Torokhov wrote:
> > On Tue, Jan 25, 2011 at 03:29:14PM -0800, Dmitry Torokhov wrote:
> >> On Tue, Jan 25, 2011 at 05:22:09PM -0500, Mark Lord wrote:
> >>> On 11-01-25 05:00 PM, Mauro Carvalho Chehab wrote:
> >>>> Em 25-01-2011 18:54, Dmitry Torokhov escreveu:
> ..
> >>>>> That has been done as well; we have 2 new ioctls and kept 2 old ioctls.
> >>>
> >>> That's the problem: you did NOT keep the two old ioctls().
> >>> Those got changed too.. so now we have four NEW ioctls(),
> >>> none of which backward compatible with userspace.
> >>>
> >>
> >> Please calm down. This, in fact, is not new vs old ioctl problem but
> >> rather particular driver (or rather set of drivers) implementation
> >> issue. Even if we drop the new ioctls and convert the RC code to use the
> >> old ones you'd be observing the same breakage as RC code responds with
> >> -EINVAL to not-yet-established mappings.
> >>
> >> I'll see what can be done for these drivers; I guess we could supply a
> >> fake KEY_RESERVED entry for not mapped scancodes if there are mapped
> >> scancodes "above" current one. That should result in the same behavior
> >> for RCs as before.
> >>
> >
> > I wonder if the patch below is all that is needed...
> 
> 
> Nope. Does not work here:
> 
> $ lsinput
> protocol version mismatch (expected 65536, got 65537)
> 

It would be much more helpful if you tried to test what has been fixed
(hint: version change wasn't it).

-- 
Dmitry

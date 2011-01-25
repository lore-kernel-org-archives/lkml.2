Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab1AYA4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 19:56:05 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59957 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1AYA4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 19:56:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wTVUSzjdI8HBxcDWd2zormLnLOhd1jECJ5sft/zO5MHCx/e2eMVGzEq9pOena9qerK
         JXngQKOx4vgfJ6N/hr5hClqWoq7W8fz8FH9VsREVEmxaiCf7qLWTMqDdINi0gIclwqWa
         yo8TfYd/yVqpd9aPFDfd9sbXWDr5mbbsAIVHI=
Date: Mon, 24 Jan 2011 16:55:55 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110125005555.GA18338@core.coreip.homeip.net>
References: <4D3C5F73.2050408@teksavvy.com>
 <20110124175456.GA17855@core.coreip.homeip.net>
 <4D3E1A08.5060303@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3E1A08.5060303@teksavvy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 07:32:08PM -0500, Mark Lord wrote:
> On 11-01-24 12:54 PM, Dmitry Torokhov wrote:
> > Hi Mark,
> > 
> > On Sun, Jan 23, 2011 at 12:03:47PM -0500, Mark Lord wrote:
> >> As of the 2.6.36 kernel, the userspace commands lsinput and input-kbd
> >> no longer work.  And if I grab newer/patched versions of those from the latest
> >> Ubuntu 10.10, then those newer/patched versions do not work with kernels
> >> *before* 2.6.36.
> >>
> >> At first glance, this looks like a visible regression.
> >> Is there a version of input-utils that works with both
> >> old and new kernels ?
> >>
> > 
> > The event protocol number was updated to reflect support of large
> > scancodes, unfortunately some of the utilities expected exact version
> > and refuse to work with updated one.
> 
> 
> So is there a danger of memory corruption if running a binary
> that doesn't check the version number?
> 

No, as far as I know we kept ABI intact.

> In other words, did the size and/or format of returned data
> change for an ioctl() or something here?

Yes, we introduced new ioctls (keeping old ones and their ABI intact).
The change is that EVIOCGVERSION ioctl now returns 0x10001 instead of
0x10000.

> 
> If so, then that is a user-visible regression, and shouldn't happen.
> One correct way to handle that, would be to create a new ioctl(),
> and mark the old one as deprecated, for removal a few years later perhaps.
> 
> ???

Right.

However a few input utilities insist that they will only work with event
protocol version 0x10000. It is purely their choice, however misguided
it might be.

-- 
Dmitry

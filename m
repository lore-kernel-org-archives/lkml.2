Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965371Ab2JAXvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:51:55 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48710 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752407Ab2JAXvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:51:54 -0400
X-Sasl-enc: 4PGysRBk8zAtysqvW8jnDyqcRTgBBLbs/LtNBAPimu7g 1349135513
Date: Mon, 1 Oct 2012 16:51:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alex Williamson <alex.williamson@hp.com>, Alex Chiang <achiang@hp.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] sysfs: sysfs_pathname/sysfs_add_one: Use strlcat()
 instead of strcat()
Message-ID: <20121001235152.GC15924@kroah.com>
References: <1348950199-30460-1-git-send-email-geert@linux-m68k.org>
 <20120930144930.GA27329@kroah.com>
 <CAMuHMdW19BQti_EWdgynWwOZCuhTQO-tJbN9Q8gBnUcA=auEKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdW19BQti_EWdgynWwOZCuhTQO-tJbN9Q8gBnUcA=auEKg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2012 at 08:59:05PM +0200, Geert Uytterhoeven wrote:
> Hi Greg,
> 
> On Sun, Sep 30, 2012 at 4:49 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Sat, Sep 29, 2012 at 10:23:19PM +0200, Geert Uytterhoeven wrote:
> >> The warning check for duplicate sysfs entries can cause a buffer overflow
> >> when printing the warning, as strcat() doesn't check buffer sizes.
> >> Use strlcat() instead.
> >
> > As the comment said, we knew about this, but I have never seen it, do
> > you know of a way to trigger it?
> 
> I expected there would be a check somewhere else in the code, so we can
> never overflow here. But I did manage to overflow the buffer by having a real
> long name (4060 characters) in a conflicting mfd_cell.
> There may be other ways.
> 
> I don't know how likely it is to trigger in a real world scenario. Is
> there a limit
> on the depth of sysfs? Or can it go unbounded, e.g. by cascading USB hubs?

You can only go so deep with USB hubs (5 I think.)

> >> Cc: stable@vger.kernel.org
> >
> > Given that I don't know of any way to actually hit this problem, is it
> > really needed for older kernel releases?
> 
> That's up to you to decide...

Ok, I'll queue this up after 3.7-rc1 is out, thanks.

greg k-h

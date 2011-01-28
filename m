Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab1A1C6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 21:58:32 -0500
Received: from kroah.org ([198.145.64.141]:34028 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556Ab1A1C6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 21:58:30 -0500
Date: Thu, 27 Jan 2011 18:56:29 -0800
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: torvalds@linux-foundation.org, San Mehat <san@google.com>,
        Aaron Durbin <adurbin@google.com>, Duncan Laurie <dlaurie@google.com>,
        linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>
Subject: Re: [PATCH v1 3/6] driver: Google EFI SMI
Message-ID: <20110128025629.GC32284@kroah.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
 <20110125002449.12637.35623.stgit@mike.mtv.corp.google.com>
 <20110125031752.GA9846@kroah.com>
 <AANLkTi=XhRX-=k8UmmQFshP6fgF_q2c-9gEHuH0mWu0a@mail.gmail.com>
 <20110126024608.GB28283@kroah.com>
 <AANLkTi=rO5QOVjNNWkekOb0WXzKX2CUpgvEryL0cemzB@mail.gmail.com>
 <AANLkTimT_t-3smsaQUrtisFdkODfoOoroQ93tQ9PByBq@mail.gmail.com>
 <AANLkTim27Y+TKa54jhC1VuqXzjEzX150ysGoUKNJrBmk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim27Y+TKa54jhC1VuqXzjEzX150ysGoUKNJrBmk@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 03:41:06PM -0800, Mike Waychison wrote:
> On Wed, Jan 26, 2011 at 5:22 PM, Mike Waychison <mikew@google.com> wrote:
> > On Wed, Jan 26, 2011 at 3:58 PM, Mike Waychison <mikew@google.com> wrote:
> >> On Tue, Jan 25, 2011 at 6:46 PM, Greg KH <greg@kroah.com> wrote:
> >>> So, let me ask, what specifically are you wanting to import/export
> >>> to/from the kernel here?  Have you thought about other kernel/user apis
> >>> instead of ioctls?  What is forcing you to use ioctls?
> >>
> >> I'm not sure if you are trying to suggest that there is a better way
> >> to solve these problems without actually saying so.  We could probably
> >> use a different interface, sure.
> >>
> >
> > Well, I managed to find efivars.c, and it seems like I can probably
> > massage it to do what I want as several of the calls I'd like to
> > export to userland mirror portions of the EFI runtime services page.
> > That won't take care of all of the firmware calls I'd like to export,
> > but it's a start.
> >
> 
> I've spent the last few hours looking at efivars.c and working out how
> I can refactor it to reuse all the kobject bits it uses.  Does anybody
> use this thing though?
> 
> I can't believe I was just lectured for crappy ABI when this thing
> takes a binary packed struct on write() and process it:
>    - without regard to write length, and
>    - in a way that isn't compatible across compat (both DataSize and
> Status are unsigned long!).

It should just be passing that data straight to the hardware and not
trying to process the data at all, right?  If not, then it needs to be
fixed and not use the firmware binary interface...

thanks,

greg k-h

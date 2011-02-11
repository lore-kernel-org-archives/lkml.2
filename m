Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab1BKTMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 14:12:24 -0500
Received: from kroah.org ([198.145.64.141]:51277 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756377Ab1BKTMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 14:12:23 -0500
Date: Fri, 11 Feb 2011 11:12:16 -0800
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: Tim Hockin <thockin@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Robert Lippert <rlippert@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: SMBIOS / DMI Event Logs in Linux?
Message-ID: <20110211191216.GA11290@kroah.com>
References: <4D547236.6080702@google.com>
 <20110211012552.GA28995@kroah.com>
 <AANLkTi=tbYj_bonu2i+NHpNY3KUMpsTVT8YDsLhDz_Nm@mail.gmail.com>
 <20110211032049.GB884@kroah.com>
 <AANLkTin3tu-NiotpzWaQ_ubV0jumb_WsjEK5QGi5w56o@mail.gmail.com>
 <AANLkTi=Umq5gPr4xT4iChm+B+C+TOF1SB8gC4_ygqztR@mail.gmail.com>
 <20110211183245.GA10891@kroah.com>
 <AANLkTimrm5zFxA++0ZgXL7csJSU17TgDx5Qb_3RdtzBU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimrm5zFxA++0ZgXL7csJSU17TgDx5Qb_3RdtzBU@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 10:56:16AM -0800, Mike Waychison wrote:
> On Fri, Feb 11, 2011 at 10:32 AM, Greg KH <greg@kroah.com> wrote:
> > On Fri, Feb 11, 2011 at 10:00:37AM -0800, Mike Waychison wrote:
> >> resend as plain text, sorry :(
> >>
> >>
> >> On Thu, Feb 10, 2011 at 7:20 PM, Greg KH <greg@kroah.com> wrote:
> >> > Wait, if this is just a simple "pass through to the hardware", then just
> >> > export the thing, with the proper permissions, in a single binary sysfs
> >> > file, and do the parsing in userspace.
> >> >
> >>
> >> If you mean s/hardware/firmware/, then yes.
> >
> > Yes, sorry, that is what I ment.
> >
> >> > That would be the simplest thing to do, and fit the rules for valid
> >> > sysfs files, and keep people from having to dig through /dev/mem, right?
> >>
> >> Yup, exposing the log via a bin_attribute and allowing for blobs to be
> >> appended (with the firmware either accepting or rejecting the format
> >> will do).
> >
> > Great, that should be a simple thing to do then, right?
> 
> Ya.  Here's what I'm working on now:
> 
> /sys/firmware/gsmi/eventlog
>   - read: reads out binary bytes of the log as exported by firmware.
>   - write: takes the user buffer and passes it on to the firmware via
> a SET_EVENT_LOG command and returns a mapped errno to the user.
> 
> /sys/firmware/gsmi/clear_eventlog
>   - write-only: takes a value between 0 and 100 and passes it to the
> firmware to clear out a percentage of the log.
> 
> /sys/firmware/gsmi/clear_config
>   - write-only: takes arbitrary data and tells the firmware to wipe it's config.
> 
> /sys/firmware/gsmi/vars (directory)
>   - same code as /sys/firmware/efi/vars except firmware calls vector
> through gsmi instead of the EFI runtime services page  (I've
> abstracted it out for re-use)
> 
> This covers the gsmi driver and removes the ioctls completely from it.

Wonderful, that should have hopefully also made the code cleaner.

> I've already changed the "memconsole" driver I sent out a while ago to
> export itself as an untouched binary file /sys/firmware/log .
> 
> The only bit that remains that needs cleaning is the 'bootlog' driver.
>   I'm going to work with Robert offline (or online if he wants to
> follow up here) with what "proper" kernel interfaces should look like
> for his purposes.

I thought that it was agreed that it too would be a binary sysfs file to
be read from?  Or was that me just wishing it would be so?  :)

thanks,

greg k-h

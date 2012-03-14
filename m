Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761414Ab2CNUoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 16:44:01 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48532 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759449Ab2CNUoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 16:44:00 -0400
Date: Wed, 14 Mar 2012 13:43:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
Message-ID: <20120314204355.GA10187@kroah.com>
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com>
 <20120313233217.GB31106@kroah.com>
 <4F60F2E4.7060707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F60F2E4.7060707@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 04:35:00PM -0300, Mauro Carvalho Chehab wrote:
> Em 13-03-2012 20:32, Greg KH escreveu:
> > On Wed, Mar 07, 2012 at 08:40:32AM -0300, Mauro Carvalho Chehab wrote:
> >> Prepare the internal structures to represent the memory properties per dimm, 
> >> instead of per csrow. 
> >>
> >> This is needed for modern controllers with more than 2 channels, as the memories 
> >> at the same slot number but on different channels (or channel pairs) may be 
> >> different.
> >>
> >> Mauro Carvalho Chehab (6):
> >>   edac: Create a dimm struct and move the labels into it
> >>   edac: Add per dimm's sysfs nodes
> > 
> > You need Documentation/ABI entries for these new sysfs files.
> 
> Sure. I'll provide it on the final patchset.
> 
> Boris suggested some alternatives for the error counter sysfs nodes, but the 
> discussion ended by diverging into an implementation detail of hiding the UE
> error nodes, without any consensus about the sysfs structure for it.
> 
> At the current patchset, the error counter nodes are all under
> 	sys/devices/system/edac/mc/mc?/
> 
> He thinks that a multi-layer struct should be created inside that directory
> (it could have 2 or 3 levels of directories, depending on how the memory is
> organized at the memory controller), instead of having a large number of files
> there.

Why create subdirs?  If those subdirectories are not real devices,
showing a real hierarchy, then do not create them as userspace will get
very confused very quickly.

Easy rule to remember, never mix "raw" kobjects and 'struct device',
which is what you would be doing here, right?  We can handle many
hundreds of thousands of files and devices in a single directory, no
problem.

> Anyway, before adding unnedded complexity, I'd like to hear more comments from 
> the others before writing a complex patch to create such structure.
> 
> So, maybe I could just add what it was there as ABI/testing, and give more
> time for kernel and userspace developers to work with it and provide us a better
> feedback.

That's a nice dream, it usually never happens until a few kernel
releases, after people have already written tools that rely on the
existing structure :)

Feel free to cc: me on any of these patches if you want some review of
the sysfs layout and usage.

thanks,

greg k-h

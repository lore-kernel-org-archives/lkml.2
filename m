Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab0GJAIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 20:08:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34459 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab0GJAIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 20:08:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
Subject: Re: HDD not suspending properly / dead on resume
Date: Sat, 10 Jul 2010 02:06:13 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4; KDE/4.4.4; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-pm@lists.osdl.org,
       Stephan Diestelhorst <stephan.diestelhorst@amd.com>
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201007092353.25731.rjw@sisk.pl> <201007100104.38693.stephan.diestelhorst@gmail.com>
In-Reply-To: <201007100104.38693.stephan.diestelhorst@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201007100206.13401.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 10, 2010, Stephan Diestelhorst wrote:
> Rafael J. Wysocki wrote:
> > On Friday, July 09, 2010, Stephan Diestelhorst wrote:
> > > I wrote:
> > > >   I have an issue with suspend to RAM and I/O load on a disk. Symptoms
> > > > are that the disk does not respond to requests when woken up, producing
> > > > only I/O errors on all tested kernels (newest 2.6.35-rc4 (Ubuntu
> > > > mainline PPA build)):
> > > > 
> > > <snip>
> > >  
> > > > This can be triggered most reliably with multiple "direct" writes to
> > > > disk, I create the load with the attached script. If the issue is
> > > > triggered, suspend (through pm-suspend) takes very long.
> > > 
> > > > IMHO the interesting log output during suspend is:
> > > > [ 1674.700125] ata1.00: qc timeout (cmd 0xec)
> > > 
> > > Almighty google suggested to try "pci=nomsi", which seems to have
> > > cured the issue for me for now. Is that plausible? I'll keep this
> > > under observation.
> > 
> > Hmm.  How does your /proc/interrupts look like?
> 
> This has been yet another red herring. After trying out the kernel
> option three times with two different kernels, it failed yet again
> with the same symptoms. 

I thought it would be like that.

> I have attached /proc/interrupts for 2.6.35-rc4, once with pci=nomsi
> and once without, but again, I do not think this makes a difference :-/
> 
> > Also, do you have a link to this "Google suggestion"?
> 
> It was some german forum, a guy with completely different HW, but the
> same symptom. I thought trying out the option wouldn't hurt.
> 
> Maybe it came for example from http://lkml.org/lkml/2008/12/20/3
> originally.

I have a box where this problem is kind of reproducible, but it happens _very_
rarely.  Also I can't reproduce it on demand running suspend-resume in a tight
loop.  Are you able to reproduce it more regurarly?

Also, what kind of disk do you use?

Rafael

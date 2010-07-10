Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab0GJGuo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 02:50:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56235 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab0GJGun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 02:50:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Bfmqk/YwOSyLVRcGGQcA+LYUlIbDH+NePS9grmGfdq1oStfwaCsTONALO6TeeyCiSk
         rziMPf0LjlH+jjI1HnJ1GPdWdugnogkaYawRNixXcm3XWWbqU2jFTbo2FM6dnjqngBwL
         9R5vbdTGIap4KNwuoQQKjK8SfVhhP8MwT1ey8=
From: Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: HDD not suspending properly / dead on resume
Date: Sat, 10 Jul 2010 08:50:34 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.32-22-generic; KDE/4.4.4; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-pm@lists.osdl.org,
       stephan.diestelhorst@gmail.com, stephan.diestelhorst@amd.com
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201007100104.38693.stephan.diestelhorst@gmail.com> <201007100206.13401.rjw@sisk.pl>
In-Reply-To: <201007100206.13401.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201007100850.36889.stephan.diestelhorst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Saturday, July 10, 2010, Stephan Diestelhorst wrote:
> > Rafael J. Wysocki wrote:
> > > On Friday, July 09, 2010, Stephan Diestelhorst wrote:
> > > > I wrote:
> > > > >   I have an issue with suspend to RAM and I/O load on a disk. Symptoms
> > > > > are that the disk does not respond to requests when woken up, producing
> > > > > only I/O errors on all tested kernels (newest 2.6.35-rc4 (Ubuntu
> > > > > mainline PPA build)):
> > > > > 
> > > > <snip>
> > > >  
> > > > > This can be triggered most reliably with multiple "direct" writes to
> > > > > disk, I create the load with the attached script. If the issue is
> > > > > triggered, suspend (through pm-suspend) takes very long.
> > > > 
> > > > > IMHO the interesting log output during suspend is:
> > > > > [ 1674.700125] ata1.00: qc timeout (cmd 0xec)
> 
> I have a box where this problem is kind of reproducible, but it happens _very_
> rarely.  Also I can't reproduce it on demand running suspend-resume in a tight
> loop.  Are you able to reproduce it more regurarly?

For me it is much more reproducible. If I run multiple direct writing
dd-s to the disk in question I trigger it rather reliably (~75% or
higher). See the attached script from an earlier email.
Maybe that helps triggering your case more reliabl, too?

> Also, what kind of disk do you use?

It is a Samsung HM321HI in a Samsung Eikee R525 notebook, please also 
see my smartctl -a log, attached earlier.

Interesting, I have a similar symptom on one of my home servers,
which has a *Samsung* SpinPoint F1 and it went away with different
disks. So maybe these disks are either faulty themselves or they
trigger the issue more often?

I also have a LVM on top of LUKS on the disk. So the I/O will also
add some computational overhead for encryption.

Stephan

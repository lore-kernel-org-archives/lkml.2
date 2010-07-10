Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab0GJNrT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 09:47:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35832 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226Ab0GJNrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 09:47:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: HDD not suspending properly / dead on resume
Date: Sat, 10 Jul 2010 15:45:17 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Stephan Diestelhorst <stephan.diestelhorst@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-pm@lists.osdl.org, stephan.diestelhorst@amd.com
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201007100850.36889.stephan.diestelhorst@gmail.com> <4C384580.2080507@kernel.org>
In-Reply-To: <4C384580.2080507@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201007101545.17401.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, July 10, 2010, Tejun Heo wrote:
> On 07/10/2010 08:50 AM, Stephan Diestelhorst wrote:
> >> I have a box where this problem is kind of reproducible, but it happens _very_
> >> rarely.  Also I can't reproduce it on demand running suspend-resume in a tight
> >> loop.  Are you able to reproduce it more regurarly?
> > 
> > For me it is much more reproducible. If I run multiple direct writing
> > dd-s to the disk in question I trigger it rather reliably (~75% or
> > higher). See the attached script from an earlier email.
> > Maybe that helps triggering your case more reliabl, too?
> 
> Can you please try the following git tree?
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git libata-irq-expect

Well, for now I got this:

[   36.833075] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[   36.833085] ata1.00: failed command: SMART
[   36.833099] ata1.00: cmd b0/d5:01:06:4f:c2/00:00:00:00:00/00 tag 0 pio 512 in
[   36.833101]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[   36.833107] ata1.00: status: { DRDY }
[   36.833118] ata1: hard resetting link
[   37.316053] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   37.316840] ata1.00: configured for UDMA/133
[   37.316888] ata1: EH complete

during initialization.  Apart from this it seems to work fine.

But in fact I'll only be able to say it helps if it survives a week-or-so
without suspend failure.

Rafael

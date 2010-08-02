Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab0HBVjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 17:39:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57657 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab0HBVjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 17:39:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend to RAM (was: Re: HDD not suspending properly / dead on resume)
Date: Mon, 2 Aug 2010 23:38:05 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-pm@lists.osdl.org
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201007282350.09676.rjw@sisk.pl> <201008022248.45135.stephan.diestelhorst@gmail.com>
In-Reply-To: <201008022248.45135.stephan.diestelhorst@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201008022338.05195.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 02, 2010, Stephan Diestelhorst wrote:
> On Wednesday 28 July 2010, 23:50:09 Rafael J. Wysocki wrote:
> > On Saturday, July 10, 2010, Tejun Heo wrote:
> > > On 07/10/2010 08:50 AM, Stephan Diestelhorst wrote:
> > > >> I have a box where this problem is kind of reproducible, but it happens _very_
> > > >> rarely.  Also I can't reproduce it on demand running suspend-resume in a tight
> > > >> loop.  Are you able to reproduce it more regurarly?
> > > > 
> > > > For me it is much more reproducible. If I run multiple direct writing
> > > > dd-s to the disk in question I trigger it rather reliably (~75% or
> > > > higher). See the attached script from an earlier email.
> > > > Maybe that helps triggering your case more reliabl, too?
> > > 
> > That didn't help, but the appended patch fixes the problem for me.
> 
> <snip>
> 
> Sorry for taking ages. Vacation and catching up after it are to blame,
> as is me forgetting to build a proper initrd...
> 
> Thanks for the patch! It certainly changes behaviour, however, in a
> very strange way for me. With your patch my machine does not suspend
> to ram anymore (a simple echo mem > /proc/sys/state blocks), and
> nothing happens in dmesg if there is a lot of write I/O while
> suspending. (A number of parallel dd's with oflag=direct)
> 
> If I stop the I/O, the system eventually goes into suspend to RAM.
> However, that takes a while, after the I/O has stopped, and also
> from "Preparing system for suspend" log entry until it is actually
> done.
> 
> Is this intentional?

It surely isn't.

> Let me know how I can debug this further!
> Ideally I'd like to be able to suspend the machine under I/O load,
> too. (E.g. during a compile job.)
> 
> Can you reproduce this at your end, too?

Well, I didn't try suspending with a number of parallel dd's with oflag=direct
in the background, but otherwise I'm not reproducing the issue with
the patch applied.

Rafael

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab0HCIkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:40:14 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:39056 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab0HCIkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:40:10 -0400
X-SpamScore: -61
X-BigFish: VPS-61(z6c9Rz1432N1a09M9370J98dN936eM1447R9371Pzz1202hzz15d4Rz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L6KILG-01-HP2-02
X-M-MSG: 
From: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Organization: AMD OSRC
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend to RAM (was: Re: HDD not suspending properly / dead on resume)
Date: Tue, 3 Aug 2010 10:36:50 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-pm-link-fix; KDE/4.4.5; x86_64; ; )
CC: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201008022248.45135.stephan.diestelhorst@gmail.com> <201008022338.05195.rjw@sisk.pl>
In-Reply-To: <201008022338.05195.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-ID: <201008031036.51012.stephan.diestelhorst@amd.com>
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 August 2010, 23:38:05 Rafael J. Wysocki wrote:
> On Monday, August 02, 2010, Stephan Diestelhorst wrote:
> > On Wednesday 28 July 2010, 23:50:09 Rafael J. Wysocki wrote:
> > > On Saturday, July 10, 2010, Tejun Heo wrote:
> > > > On 07/10/2010 08:50 AM, Stephan Diestelhorst wrote:
> > > > >> I have a box where this problem is kind of reproducible, but it happens _very_
> > > > >> rarely.  Also I can't reproduce it on demand running suspend-resume in a tight
> > > > >> loop.  Are you able to reproduce it more regurarly?
> > > > > 
> > > > > For me it is much more reproducible. If I run multiple direct writing
> > > > > dd-s to the disk in question I trigger it rather reliably (~75% or
> > > > > higher). See the attached script from an earlier email.
> > > > > Maybe that helps triggering your case more reliabl, too?
> > > > 
> > > That didn't help, but the appended patch fixes the problem for me.
> > 
> > <snip>
> > 
> > Sorry for taking ages. Vacation and catching up after it are to blame,
> > as is me forgetting to build a proper initrd...
> > 
> > Thanks for the patch! It certainly changes behaviour, however, in a
> > very strange way for me. With your patch my machine does not suspend
> > to ram anymore (a simple echo mem > /proc/sys/state blocks), and
> > nothing happens in dmesg if there is a lot of write I/O while
> > suspending. (A number of parallel dd's with oflag=direct)
> > 
> > If I stop the I/O, the system eventually goes into suspend to RAM.
> > However, that takes a while, after the I/O has stopped, and also
> > from "Preparing system for suspend" log entry until it is actually
> > done.
> > 
> > Is this intentional?
> 
> It surely isn't.
> 
> > Let me know how I can debug this further!
> > Ideally I'd like to be able to suspend the machine under I/O load,
> > too. (E.g. during a compile job.)
> > 
> > Can you reproduce this at your end, too?
> 
> Well, I didn't try suspending with a number of parallel dd's with oflag=direct
> in the background, but otherwise I'm not reproducing the issue with
> the patch applied.

Mhmhm, I have tried to reproduce my issue again, and also added some
dev_printk's around your code to understand where the delay is
happening.

However, I have not been able to reproduce the issue (with and without
the debug output) anymore, and I am happy to report that for now your
patch helps.

I'd like to keep this under observation for a little while longer,
though.

Many thanks,
  Stephan

-- 
Stephan Diestelhorst, AMD Operating System Research Center
stephan.diestelhorst@amd.com, Tel. +49 (0)351 448 356 719

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632


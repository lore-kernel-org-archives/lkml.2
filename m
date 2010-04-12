Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0DMBWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 21:22:40 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:50499 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754647Ab0DMBWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 21:22:37 -0400
Date: Mon, 12 Apr 2010 10:22:25 +1000
From: Dave Chinner <david@fromorbit.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Avi Kivity <avi@redhat.com>, Ben Gamari <bgamari.foss@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, tytso@mit.edu, npiggin@suse.de,
       Ingo Molnar <mingo@elte.hu>, Ruald Andreae <ruald.a@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, Olly Betts <olly@survex.com>,
       martin f krafft <madduck@madduck.net>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
Message-ID: <20100412002225.GB2493@dastard>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
 <4baeaee5.c5c2f10a.7187.2688@mx.google.com>
 <20100327204233.0d84542a@infradead.org>
 <4baf624c.48c3f10a.16d0.ffffccb8@mx.google.com>
 <87y6hcyu85.fsf@basil.nowhere.org>
 <4bbf401e.a3b9e70a.13f3.4460@mx.google.com>
 <4BC1E4A4.1070103@redhat.com>
 <alpine.LFD.2.00.1004112014520.18009@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004112014520.18009@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 11, 2010 at 08:16:09PM +0200, Thomas Gleixner wrote:
> On Sun, 11 Apr 2010, Avi Kivity wrote:
> > On 04/09/2010 05:56 PM, Ben Gamari wrote:
> > > On Mon, 29 Mar 2010 00:08:58 +0200, Andi Kleen<andi@firstfloor.org>  wrote:
> > > > Ben Gamari<bgamari.foss@gmail.com>  writes:
> > > > ext4/XFS/JFS/btrfs should be better in this regard
> > > > 
> > > I am using btrfs, so yes, I was expecting things to be better.
> > > Unfortunately,
> > > the improvement seems to be non-existent under high IO/fsync load.
> > 
> > btrfs is known to perform poorly under fsync.
> 
> XFS does not do much better. Just moved my VM images back to ext for
> that reason.

Numbers? Workload description? Mount options? I hate it when all I
hear is "XFS sucked, so I went back to extN" reports without any
more details - it's hard to improve anything without any details
of the problems.

Also worth remembering is that XFS defaults to slow-but-safe
options, but ext3 defaults to fast-and-I-don't-give-a-damn-about-
data-safety, so there's a world of difference between the
filesystem defaults....

And FWIW, I run all my VMs on XFS using default mkfs and mount options,
and I can't say that I've noticed any performance problems at all
despite hammering the IO subsystems all the time. The only thing
I've ever done is occasionally run xfs_fsr across permanent qcow2
VM images to defrag them as the grow slowly over time...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

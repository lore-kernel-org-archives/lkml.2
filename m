Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab1AEPt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 10:49:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab1AEPt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 10:49:26 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: [PATCH 21/32] fs/aio: aio_wq isn't used in memory reclaim path
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
	<1294062595-30097-22-git-send-email-tj@kernel.org>
	<x49d3ocacij.fsf@segfault.boston.devel.redhat.com>
	<20110105112802.GA7669@mtj.dyndns.org>
	<x49d3obqu9a.fsf@segfault.boston.devel.redhat.com>
	<20110105150048.GA32455@kvack.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 05 Jan 2011 10:49:19 -0500
In-Reply-To: <20110105150048.GA32455@kvack.org> (Benjamin LaHaise's message of
	"Wed, 5 Jan 2011 10:00:48 -0500")
Message-ID: <x494o9nqrk0.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin LaHaise <bcrl@kvack.org> writes:

> On Wed, Jan 05, 2011 at 09:50:57AM -0500, Jeff Moyer wrote:
>> > Yeap.  Do you agree that the concurrency limit is necessary?  If not,
>> > we can just put everything onto system_wq.
>> 
>> I'm not sure whether it's strictly necessary (there may very well be a
>> need for this in the usb gadgetfs code), but keeping it the same at
>> least seems safe.
>
> Limiting concurrency on aio requests is exactly the opposite of what the 
> usb gadgetfs requires.

I'll have to dig on what their requirements are.  After briefly looking
at mailing list archives, it appears they use the aio workqueue to queue
work after a completed I/O.  I think Zach actually had posted a patch to
change them over to using their own workqueue for that.  At any rate, it
may well be that they don't have a concurrency requirement (in fact, it
would be surprising if they did).  However, I wasn't going to propose
changing the way things were done w/o someone chiming in and saying they
needed it.

> It's similarly bad for filesystem aio when there's a mix of small and
> large requests in flight.

Well, the aio workqueue isn't actually used by the filesystem aio paths
at all (except for the fput_work, and that's being moved to the system
workqueue).

Cheers,
Jeff

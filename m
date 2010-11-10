Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab0KJI0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 03:26:14 -0500
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:38603 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753226Ab0KJI0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 03:26:12 -0500
Date: Wed, 10 Nov 2010 19:24:58 +1100
From: Dave Chinner <david@fromorbit.com>
To: Evgeniy Ivanov <lolkaantimat@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, dave b <db.pub.mail@gmail.com>,
        Sanjoy Mahajan <sanjoy@olin.edu>, Jesper Juhl <jj@chaosbits.net>,
        Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@kernel.org>,
        Aidar Kultayev <the.aidar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Ted Ts'o" <tytso@mit.edu>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Shaohua Li <shaohua.li@intel.com>, Steven Barrett <damentz@gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
Message-ID: <20101110082458.GU2715@dastard>
References: <20101105014334.GF13830@dastard>
 <E1PELiI-0001Pj-8g@approx.mit.edu>
 <AANLkTimON_GL6vRF9=_U6oRFQ30EYssx3wv5xdNsU9JM@mail.gmail.com>
 <4CD696B4.6070002@kernel.dk>
 <AANLkTikNPEcwWjEQuC-_=9yH5DCCiwUAY265ggeygcSQ@mail.gmail.com>
 <20101110013255.GR2715@dastard>
 <AANLkTikAF=Ka_qB5pPzo9wj_jAp=TG2xSbjaGcoLYfBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikAF=Ka_qB5pPzo9wj_jAp=TG2xSbjaGcoLYfBw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 11:08:17AM +0300, Evgeniy Ivanov wrote:
> On Wed, Nov 10, 2010 at 4:32 AM, Dave Chinner <david@fromorbit.com> wrote:
> > Don't forget to mention data=writeback is not the default because if
> > your system crashes or you lose power running in this mode it will
> > *CORRUPT YOUR FILESYSTEM* and you *WILL LOSE DATA*. Not to mention
> > the significant security issues (e.g stale data exposure) that also
> > occur even if the filesystem is not corrupted by the crash. IOWs,
> > data=writeback is the "fast but I'll eat your data" option for ext3.
> >
> > So I recommend that nobody follows this path because it only leads
> > to worse trouble down the road.  Your best bet it to migrate away
> > from ext3 to a filesystem that doesn't have such inherent ordering
> > problems like ext4 or XFS....
> 
> Is it save to use "data=writeback" with ext4?

I believe the same issues exist with data=writeback in ext4, but you
probably should have an ext4 developer answer that question for
certain.

> At least are there security issues?
> Why do you say, that fs can be corrupted? Metadata is still
> journalled, so only data might be corrupted, but FS should still be
> consistent.

Data corruption is still a filesystem corruption.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

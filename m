Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab1EZOzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 10:55:08 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:43511 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab1EZOzG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 10:55:06 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Tomas Henzl <thenzl@redhat.com>
CC: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LKML-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Date: Thu, 26 May 2011 14:53:46 +0000
Subject: RE: [PATCH 01/16] hpsa: do readl after writel in main i/o path to
 ensure commands don't get lost.
Thread-Topic: [PATCH 01/16] hpsa: do readl after writel in main i/o path to
 ensure commands don't get lost.
Thread-Index: AcwbnmHkLN/EvZEhT4KkcY3RDPOWPAAFkFhg
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77887D52077155@GVW0547EXC.americas.hpqcorp.net>
References: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
 <20110503195849.5478.13229.stgit@beardog.cce.hp.com>
 <4DC13566.5070203@redhat.com> <20110504125212.GC5997@beardog.cce.hp.com>
 <10639.1304530101@localhost> <20110504173735.GB22953@parisc-linux.org>
 <11821.1304531662@localhost> <20110505183515.GA14193@beardog.cce.hp.com>
 <4DDA46FD.904@redhat.com>
 <0F5B06BAB751E047AB5C87D1F77A77887D5207690A@GVW0547EXC.americas.hpqcorp.net>
 <4DDE43F4.9030607@redhat.com>
In-Reply-To: <4DDE43F4.9030607@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: Hq7d a8Mc ecff etz9 rsne scCT seRT tJhB 6P1H 8MC3
 ACFyTw== AClzVg== AEXZWA== AEbGNw== AE0l8Q==
 AFGZyw==;7;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGEAeABiAG8AZQBAAGsAZQByAG4AZQBsAC4AZABrADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAHMAYwBzAGkAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHMAYwBhAG0AZQByAG8AbgBAAGIAZQBhAHIAZABvAGcALgBjAGMAZQAuAGgAcAAuAGMAbwBtADsAdABoAGUAbgB6AGwAQAByAGUAZABoAGEAdAAuAGMAbwBtADsAdgBhAGwAZABpAHMALgBrAGwAZQB0AG4AaQBlAGsAcwBAAHYAdAAuAGUAZAB1AA==;Sosha1_v1;7;{5506AD55-2F19-4C66-99F8-4FD30C538C31};bQBpAGsAZQAuAG0AaQBsAGwAZQByAEAAaABwAC4AYwBvAG0A;Thu,
 26 May 2011 14:53:46
 GMT;UgBFADoAIABbAFAAQQBUAEMASAAgADAAMQAvADEANgBdACAAaABwAHMAYQA6ACAAZABvACAAcgBlAGEAZABsACAAYQBmAHQAZQByACAAdwByAGkAdABlAGwAIABpAG4AIABtAGEAaQBuACAAaQAvAG8AIABwAGEAdABoACAAdABvACAAZQBuAHMAdQByAGUAIABjAG8AbQBtAGEAbgBkAHMAIABkAG8AbgAnAHQAIABnAGUAdAAgAGwAbwBzAHQALgA=
x-cr-puzzleid: {5506AD55-2F19-4C66-99F8-4FD30C538C31}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Thursday, May 26, 2011 7:14 AM
> To: Miller, Mike (OS Dev)
> Cc: Valdis.Kletnieks@vt.edu; scameron@beardog.cce.hp.com; Andrew Morton;
> LKML; LKML-scsi; Jens Axboe
> Subject: Re: [PATCH 01/16] hpsa: do readl after writel in main i/o path
> to ensure commands don't get lost.
> 
> On 05/25/2011 05:20 PM, Miller, Mike (OS Dev) wrote:
> > Tomas wrote:
> >
> >
> >> -----Original Message-----
> >> From: Tomas Henzl [mailto:thenzl@redhat.com]
> >> Sent: Monday, May 23, 2011 6:38 AM
> >> To: Miller, Mike (OS Dev)
> >> Cc: Valdis.Kletnieks@vt.edu; scameron@beardog.cce.hp.com; Andrew
> Morton;
> >> LKML; LKML-scsi; Jens Axboe
> >> Subject: Re: [PATCH 01/16] hpsa: do readl after writel in main i/o
> path
> >> to ensure commands don't get lost.
> >>
> >> On 05/05/2011 08:35 PM, Mike Miller wrote:
> >>
> >>> On Wed, May 04, 2011 at 01:54:22PM -0400, Valdis.Kletnieks@vt.edu
> >>>
> >> wrote:
> >>
> >>>
> >>>> On Wed, 04 May 2011 11:37:35 MDT, Matthew Wilcox said:
> >>>>
> >>>>
> >>>>>> This probably needs a comment like
> >>>>>> 	/* don't care - dummy read just to force write posting to
> chipset
> >>>>>>
> >> */
> >>
> >>>>>> or similar.  I'm assuming it's just functioning as a barrier-type
> >>>>>>
> >> flush of some sort?
> >>
> >>>>>>
> >>>>> It's a PCI write flush.  It's not clear to me why it's needed
> here,
> >>>>> though.  The write will eventually get to the device; why we need
> to
> >>>>> make the CPU wait around for it to actually get there doesn't make
> >>>>>
> >> sense.
> >>
> >>>>>
> >>>> Exactly why I think it needs a one-liner comment. :)
> >>>>
> >>>>
> >>>>
> >>> So we're not exactly sure why it's needed either. We've had reports
> of
> >>> commands getting "lost" or "stuck" under some workloads. The extra
> >>>
> >> readl
> >>
> >>> works around the issue but certainly may have negative side effects.
> >>>
> >>> I'm not sure I understand how writel works.
> >>>
> >>> From linux-2.6/arch/x86/include/asm/io.h:
> >>>
> >>> #define build_mmio_write(name, size, type, reg, barrier) \
> >>> static inline void name(type val, volatile void __iomem *addr) \
> >>> { asm volatile("mov" size " %0,%1": :reg (val), \
> >>> "m" (*(volatile type __force *)addr) barrier); }
> >>>
> >>> This implies (at least to me) that a barrier is part of writel. I
> >>>
> >> don't know
> >>
> >>> why a write operation needs a barrier but thats essentially what
> we've
> >>>
> >> done
> >>
> >>> by adding the extra readl. Can someone confirm or deny that a
> barrier
> >>>
> >> is
> >>
> >>> actually built into writel? Or used by writel? If so, does this
> >>>
> >> indicate
> >>
> >>> that barrier is broken?
> >>>
> >>> At this point we (the software guys) are pretty much at a loss as to
> >>>
> >> how to
> >>
> >>> continue debugging. We don't know what to trigger on for the PCIe
> >>>
> >> analyzer.
> >>
> >>> If we track outstanding commands then trigger on one that doesn't
> >>>
> >> complete in
> >>
> >>> some amount of time the problem could conceivably be far in the past
> >>>
> >> and
> >>
> >>> difficult to correlate to the data in the trace.
> >>>
> >>>
> >> I'd look at the firmware part, you could check what happens for
> example
> >> when
> >> the firmware gets send a command it doesn't understand.
> >> You could also change the communication with the fw by adding a count
> >> field, which can
> >> be then checked for the !(next_value == previous_value + 1) and raise
> an
> >> event.
> >> tomas
> >>
> > Tomas,
> > We've tried something very similar to the counter idea in fw. It
> doesn't help because the controller thinks he's done with the request.
> We have a (pretty crude) counter in the driver but no timing mechanism.
> We could add a timer. But what's a suitable timeout value? Is 2 seconds
> too short, too long? Suggestions, please.
> >
> I know that a counter isn't a ground-breaking idea, just wanted to show
> some interest :)

:)

> The command can be either eaten by the firmware or during the
> communication in or out from the device.
> I'd would start by the communication, by adding some fields to the
> command to detect if a command in the row(s) isn't
> missing - I know even that isn't easy. The same could be done
> independently done for the other direction.
> 
> tomash

Thanks, Tomas.

> 
> > -- mikem
> >
> >
> >
> >>
> >>
> >>> If anyone has any thoughts, suggestions, or flames they would be
> >>>
> >> greatly
> >>
> >>> appreciated.
> >>>
> >>> -- mikem
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-
> scsi"
> >>>
> >> in
> >>
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>
> >>>
> >


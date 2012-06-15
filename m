Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab2FOH3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 03:29:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab2FOH3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 03:29:21 -0400
Date: Fri, 15 Jun 2012 09:29:04 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] perf, x86: Making hardware events tranlations sysfs
 available
Message-ID: <20120615072904.GA1767@m.brq.redhat.com>
References: <1339706321-8802-1-git-send-email-jolsa@redhat.com>
 <1339706321-8802-2-git-send-email-jolsa@redhat.com>
 <1339708192.2559.40.camel@twins>
 <CABPqkBTjr2YiHYPT=32G-pqh6ca7BrtxcA8Nv-xFeG-eZrGtVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABPqkBTjr2YiHYPT=32G-pqh6ca7BrtxcA8Nv-xFeG-eZrGtVA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 11:36:51PM +0200, Stephane Eranian wrote:
> On Thu, Jun 14, 2012 at 11:09 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Thu, 2012-06-14 at 22:38 +0200, Jiri Olsa wrote:
> >> Making hardware events tranlations available throught the sysfs.
> >> Adding 'events' group attribute under the sysfs x86 PMU record
> >> with attribute/file for each hardware event:
> >>
> >>   # ls  /sys/devices/cpu/events/
> >>   branch_instructions
> >>   branch_misses
> >>   bus_cycles
> >>   cache_misses
> >>   cache_references
> >>   cycles
> >>   instructions
> >>   ref_cycles
> >>   stalled_cycles_backend
> >>   stalled_cycles_frontend
> >>
> >> The file - ID mappings is:
> >>
> >>   file                      hw id
> >>   ----------------------------------------------------------------
> >>   cycles                    PERF_COUNT_HW_CPU_CYCLES
> >>   instructions              PERF_COUNT_HW_INSTRUCTIONS
> >>   cache_references          PERF_COUNT_HW_CACHE_REFERENCES
> >>   cache_misses              PERF_COUNT_HW_CACHE_MISSES
> >>   branch_instructions       PERF_COUNT_HW_BRANCH_INSTRUCTIONS
> >>   branch_misses             PERF_COUNT_HW_BRANCH_MISSES
> >>   bus_cycles                PERF_COUNT_HW_BUS_CYCLES
> >>   stalled_cycles_frontend   PERF_COUNT_HW_STALLED_CYCLES_FRONTEND
> >>   stalled_cycles_backend    PERF_COUNT_HW_STALLED_CYCLES_BACKEND
> >>   ref_cycles                PERF_COUNT_HW_REF_CPU_CYCLES
> >>
> >> Each attribute/file contains HW ID event translation for the currently
> >> running CPU model
> >>
> >>   # cat /sys/devices/cpu/events/instructions
> >>   0xc0
> >
> > Why not have it consistent with the stuff done for uncore where events
> > read: 'event=0xc0', ie the regular field=value stuff.
> >
> Yes, you want that. Because those events may need more than a code.
> You want full syntax capability. So return a string.

humm... right :)

how about the term name 'event=...', could I always assume it's 'event',
or do we want some arch specific connection for that?

jirka

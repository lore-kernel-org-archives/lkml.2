Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab2FNVKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 17:10:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59742 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab2FNVKL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 17:10:11 -0400
Message-ID: <1339708192.2559.40.camel@twins>
Subject: Re: [PATCH 1/6] perf, x86: Making hardware events tranlations sysfs
 available
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        linux-kernel@vger.kernel.org
Date: Thu, 14 Jun 2012 23:09:52 +0200
In-Reply-To: <1339706321-8802-2-git-send-email-jolsa@redhat.com>
References: <1339706321-8802-1-git-send-email-jolsa@redhat.com>
	 <1339706321-8802-2-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 22:38 +0200, Jiri Olsa wrote:
> Making hardware events tranlations available throught the sysfs.
> Adding 'events' group attribute under the sysfs x86 PMU record
> with attribute/file for each hardware event:
> 
>   # ls  /sys/devices/cpu/events/
>   branch_instructions
>   branch_misses
>   bus_cycles
>   cache_misses
>   cache_references
>   cycles
>   instructions
>   ref_cycles
>   stalled_cycles_backend
>   stalled_cycles_frontend
> 
> The file - ID mappings is:
> 
>   file                      hw id
>   ----------------------------------------------------------------
>   cycles                    PERF_COUNT_HW_CPU_CYCLES
>   instructions              PERF_COUNT_HW_INSTRUCTIONS
>   cache_references          PERF_COUNT_HW_CACHE_REFERENCES
>   cache_misses              PERF_COUNT_HW_CACHE_MISSES
>   branch_instructions       PERF_COUNT_HW_BRANCH_INSTRUCTIONS
>   branch_misses             PERF_COUNT_HW_BRANCH_MISSES
>   bus_cycles                PERF_COUNT_HW_BUS_CYCLES
>   stalled_cycles_frontend   PERF_COUNT_HW_STALLED_CYCLES_FRONTEND
>   stalled_cycles_backend    PERF_COUNT_HW_STALLED_CYCLES_BACKEND
>   ref_cycles                PERF_COUNT_HW_REF_CPU_CYCLES
> 
> Each attribute/file contains HW ID event translation for the currently
> running CPU model
> 
>   # cat /sys/devices/cpu/events/instructions
>   0xc0

Why not have it consistent with the stuff done for uncore where events
read: 'event=0xc0', ie the regular field=value stuff.



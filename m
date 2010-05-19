Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab0ESWCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 18:02:53 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:47129 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab0ESWCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 18:02:51 -0400
Message-ID: <4BF46000.20203@linux.vnet.ibm.com>
Date: Wed, 19 May 2010 15:02:40 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 1/7] perf: introduce raw_type attribute to specify the
 type of a raw sample
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com> <1274304024-6551-2-git-send-email-robert.richter@amd.com>
In-Reply-To: <1274304024-6551-2-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On 5/19/2010 2:20 PM, Robert Richter wrote:
> This patch introduces a method to specify the type of a raw sample.
> This can be used to setup hardware events other than generic
> performance counters by passing special config data to the pmu. The
> config data can be interpreted different from generic events and thus
> can be used for other purposes.
> 
> The raw_type attribute is an extension of the ABI. It reuses the
> unused bp_type space for this. Generic performance counters can be
> setup by setting the raw_type attribute to null. Thus special raw
> events must have a type other than null.
> 
> Raw types can be defined as needed for cpu models or architectures.
> To keep backward compatibility all architectures must return an error
> for an event with a raw_type other than null that is not supported.
> 
> E.g., raw_type can be used to setup IBS on an AMD cpu. IBS is not
> common to pmu features from other vendors or architectures. The pmu
> must be setup with a special config value. Sample data is returned in
> a certain format back to the userland. An IBS event is created by
> setting a raw event and encoding the IBS type in raw_type. The pmu
> handles this raw event then and passes raw sample data back.
> 
> Raw type could be architecure specific, e.g. for x86:
> 
> enum perf_raw_type {
>         PERF_RAW_PERFCTR                        = 0,
>         PERF_RAW_IBS_FETCH                      = 1,
>         PERF_RAW_IBS_OP                         = 2,
> 
>         PERF_RAW_MAX,
> };
> 
> Null is the architecture's default, meaning for x86 a perfctr.
> 
> Maybe the raw type definition could also be part of the ABI with one
> definition for all architectures.
> 
> To use raw events with perf, the raw event syntax could be suffixed by
> the type (as for breakpoints):
> 
>    -e rNNN[:TYPE]
> 
> Example:
> 
>  perf record -e r186A:1          # ... meaning IBS fetch, cycle count 100000
>  perf record -e r0:1 -c 100000   # ... the same
> 
> Or with named types:
> 
>  perf record -e r186A:IBS_FETCH ...
>  perf record -e r0:IBS_FETCH -c 100000 ...

Should this raw value have been 186A0 instead of 186A?

Where is the named type translation coming from?  Is this something that needs to be hard-coded into perf?

Have you looked at Lin Ming's patch series?  I think it offers another way to support IBS and other arch-specific and off-chip PMUs in a more general way, though it's not quite fully-baked yet.

- Corey


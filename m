Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab2FOSqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:46:21 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33351 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757014Ab2FOSqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:46:20 -0400
MIME-Version: 1.0
In-Reply-To: <1339780730.2559.92.camel@twins>
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
	<1339741902-8449-7-git-send-email-zheng.z.yan@intel.com>
	<1339780730.2559.92.camel@twins>
Date: Fri, 15 Jun 2012 20:46:18 +0200
Message-ID: <CABPqkBTuBnFWo0wpcmg_YR_C0Q_BAMBqs7nrFTHnag=_RMPddA@mail.gmail.com>
Subject: Re: [PATCH V6 06/13] perf: Add Nehalem and Sandy Bridge uncore support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, mingo@elte.hu, jolsa@redhat.com,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 7:18 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2012-06-15 at 14:31 +0800, Yan, Zheng wrote:
>> +static struct uncore_event_desc nhm_uncore_events[] = {
>> +       INTEL_UNCORE_EVENT_DESC(CLOCKTICKS, "config=0xffff"),
>> +       /* full cache line writes to DRAM */
>> +       INTEL_UNCORE_EVENT_DESC(QMC_WRITES_FULL_ANY, "event=0x2f,umask=0xf"),
>> +       /* Quickpath Memory Controller normal priority read requests */
>> +       INTEL_UNCORE_EVENT_DESC(QMC_NORMAL_READS_ANY, "event=0x2c,umask=0xf"),
>> +       /* Quickpath Home Logic read requests from the IOH */
>> +       INTEL_UNCORE_EVENT_DESC(QHL_REQUEST_IOH_READS,
>> +                               "event=0x20,umask=0x1"),
>> +       /* Quickpath Home Logic write requests from the IOH */
>> +       INTEL_UNCORE_EVENT_DESC(QHL_REQUEST_IOH_WRITES,
>> +                               "event=0x20,umask=0x2"),
>> +       /* Quickpath Home Logic read requests from a remote socket */
>> +       INTEL_UNCORE_EVENT_DESC(QHL_REQUEST_REMOTE_READS,
>> +                               "event=0x20,umask=0x4"),
>> +       /* Quickpath Home Logic write requests from a remote socket */
>> +       INTEL_UNCORE_EVENT_DESC(QHL_REQUEST_REMOTE_WRITES,
>> +                               "event=0x20,umask=0x8"),
>> +       /* Quickpath Home Logic read requests from the local socket */
>> +       INTEL_UNCORE_EVENT_DESC(QHL_REQUEST_LOCAL_READS,
>> +                               "event=0x20,umask=0x10"),
>> +       /* Quickpath Home Logic write requests from the local socket */
>> +       INTEL_UNCORE_EVENT_DESC(QHL_REQUEST_LOCAL_WRITES,
>> +                               "event=0x20,umask=0x20"),
>> +       { /* end: all zeroes */ },
>> +};
>
> Should we lowercase all event names as well?
>
Yes, and let the parser be case insensitive.

> /sys/bus/event_source/devices/uncore/events
> /sys/bus/event_source/devices/uncore/events/QHL_REQUEST_REMOTE_READS
> /sys/bus/event_source/devices/uncore/events/QHL_REQUEST_LOCAL_READS
> /sys/bus/event_source/devices/uncore/events/QHL_REQUEST_IOH_READS
> /sys/bus/event_source/devices/uncore/events/QHL_REQUEST_REMOTE_WRITES
> /sys/bus/event_source/devices/uncore/events/QMC_WRITES_FULL_ANY
> /sys/bus/event_source/devices/uncore/events/QMC_NORMAL_READS_ANY
> /sys/bus/event_source/devices/uncore/events/QHL_REQUEST_LOCAL_WRITES
> /sys/bus/event_source/devices/uncore/events/QHL_REQUEST_IOH_WRITES
> /sys/bus/event_source/devices/uncore/events/CLOCKTICKS
>
> BTW we could encode those things like:
>
> INTEL_UNCORE_EVENT_DESC(qhl_request_local_reads, 0x1020);
>
> And have the print function decode that into something pretty, it would
> save some 18 bytes per event or so. Not sure that's worth it, but who
> knows.
>
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab2FOSrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:47:06 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42830 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab2FOSrE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:47:04 -0400
MIME-Version: 1.0
In-Reply-To: <1339781398.2559.94.camel@twins>
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
	<1339741902-8449-7-git-send-email-zheng.z.yan@intel.com>
	<1339781398.2559.94.camel@twins>
Date: Fri, 15 Jun 2012 20:47:02 +0200
Message-ID: <CABPqkBR6FXo-uKFGVgVCgjycSqZ6Ye5r5f6HB35zD9auQRcr5w@mail.gmail.com>
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

On Fri, Jun 15, 2012 at 7:29 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2012-06-15 at 14:31 +0800, Yan, Zheng wrote:
>> +static struct uncore_event_desc nhm_uncore_events[] = {
>> +       INTEL_UNCORE_EVENT_DESC(CLOCKTICKS, "config=0xffff"),
>
> Why does that use config=0xffff, also I couldn't find event 0xff listed,
> is it special-cased somewhere?
That's becase some uncore have 1 fixed counter to count uncore cycles.
That means no specific encoding, so we need to make one up just like
for core PMU and the ref-cycle event.

>
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
> The rest of the events seem to be valid on both NHM and WSM, I didn't
> look very closely, but it looks like WSM has a few extra events, but
> includes all NHM events.
>
>

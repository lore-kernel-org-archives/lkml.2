Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab2FORaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 13:30:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53038 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab2FORaK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 13:30:10 -0400
Message-ID: <1339781398.2559.94.camel@twins>
Subject: Re: [PATCH V6 06/13] perf: Add Nehalem and Sandy Bridge uncore
 support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: mingo@elte.hu, jolsa@redhat.com, eranian@google.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Date: Fri, 15 Jun 2012 19:29:58 +0200
In-Reply-To: <1339741902-8449-7-git-send-email-zheng.z.yan@intel.com>
References: <1339741902-8449-1-git-send-email-zheng.z.yan@intel.com>
	 <1339741902-8449-7-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 14:31 +0800, Yan, Zheng wrote:
> +static struct uncore_event_desc nhm_uncore_events[] = {
> +       INTEL_UNCORE_EVENT_DESC(CLOCKTICKS, "config=0xffff"),

Why does that use config=0xffff, also I couldn't find event 0xff listed,
is it special-cased somewhere?

> +       /* full cache line writes to DRAM */
> +       INTEL_UNCORE_EVENT_DESC(QMC_WRITES_FULL_ANY, "event=0x2f,umask=0xf"),
> +       /* Quickpath Memory Controller normal priority read requests */
> +       INTEL_UNCORE_EVENT_DESC(QMC_NORMAL_READS_ANY, "event=0x2c,umask=0xf"),
> +       /* Quickpath Home Logic read requests from the IOH */
> +       INTEL_UNCORE_EVENT_DESC(QHL_REQUEST_IOH_READS,
> +                               "event=0x20,umask=0x1"),
> +       /* Quickpath Home Logic write requests from the IOH */
> +       INTEL_UNCORE_EVENT_DESC(QHL_REQUEST_IOH_WRITES,
> +                               "event=0x20,umask=0x2"),
> +       /* Quickpath Home Logic read requests from a remote socket */
> +       INTEL_UNCORE_EVENT_DESC(QHL_REQUEST_REMOTE_READS,
> +                               "event=0x20,umask=0x4"),
> +       /* Quickpath Home Logic write requests from a remote socket */
> +       INTEL_UNCORE_EVENT_DESC(QHL_REQUEST_REMOTE_WRITES,
> +                               "event=0x20,umask=0x8"),
> +       /* Quickpath Home Logic read requests from the local socket */
> +       INTEL_UNCORE_EVENT_DESC(QHL_REQUEST_LOCAL_READS,
> +                               "event=0x20,umask=0x10"),
> +       /* Quickpath Home Logic write requests from the local socket */
> +       INTEL_UNCORE_EVENT_DESC(QHL_REQUEST_LOCAL_WRITES,
> +                               "event=0x20,umask=0x20"),
> +       { /* end: all zeroes */ },
> +}; 

The rest of the events seem to be valid on both NHM and WSM, I didn't
look very closely, but it looks like WSM has a few extra events, but
includes all NHM events.



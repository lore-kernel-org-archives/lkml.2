Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab0KHMUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 07:20:22 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54841 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab0KHMUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 07:20:19 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Stephane Eranian <eranian@google.com>, robert.richter@amd.com,
        Cyrill Gorcunov <gorcunov@gmail.com>, paulus@samba.org,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [DRAFT PATCH 2/3] perf: Implement Nehalem uncore pmu
References: <1288682905.12061.109.camel@minggr.sh.intel.com>
Date: Mon, 08 Nov 2010 13:20:13 +0100
In-Reply-To: <1288682905.12061.109.camel@minggr.sh.intel.com> (Lin Ming's
	message of "Tue, 02 Nov 2010 15:28:25 +0800")
Message-ID: <87vd48qa6a.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lin Ming <ming.m.lin@intel.com> writes:

Looking at a an old patch.

> +
> +static void uncore_pmu_disable_events(void)
> +{
> +	struct uncore_cpu_hw_events *cpuc = &__get_cpu_var(uncore_cpu_hw_events);
> +	int node = numa_node_id();

Using numa_node_id() here implies this can't be used when NUMA is turned
off. Better use the package id.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

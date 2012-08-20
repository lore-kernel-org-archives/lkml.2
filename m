Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab2HTMAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 08:00:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37339 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab2HTMAq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 08:00:46 -0400
Message-ID: <1345464035.23018.38.camel@twins>
Subject: Re: [RFC PATCH 1/1] fair.c: Add/Export find_idlest_perfer_cpu API
From: Peter Zijlstra <peterz@infradead.org>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        sri@us.ibm.com, vivek@us.ibm.com
Date: Mon, 20 Aug 2012 14:00:35 +0200
In-Reply-To: <1345232770.16533.234.camel@oc3660625478.ibm.com>
References: <1345232770.16533.234.camel@oc3660625478.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-17 at 12:46 -0700, Shirley Ma wrote:
> Add/Export a new API for per-cpu thread model networking device driver
> to choose a preferred idlest cpu within allowed cpumask.
> 
> The receiving CPUs of a networking device are not under cgroup controls.
> Normally the receiving work will be scheduled on the cpu on which the
> interrupts are received. When such a networking device uses per-cpu
> thread model, the cpu which is chose to process the packets might not be
> part of cgroup cpusets without using such an API here. 
> 
> On NUMA system, by using the preferred cpumask from the same NUMA node
> would help to reduce expensive cross memory access to/from the other
> NUMA node.
> 
> KVM per-cpu vhost will be the first one to use this API. Any other
> device driver which uses per-cpu thread model and has cgroup cpuset
> control will use this API later.

How often will this be called and how do you obtain the cpumasks
provided to the function?

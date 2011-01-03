Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab1ACPUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 10:20:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57273 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab1ACPU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 10:20:28 -0500
Date: Mon, 3 Jan 2011 16:20:25 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>, robert.richter@amd.com,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] perf: Optimise topology iteration
Message-ID: <20110103152025.GB25713@one.firstfloor.org>
References: <1293464287.2695.106.camel@localhost> <1294052530.2016.52.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294052530.2016.52.camel@laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 12:02:10PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-12-27 at 23:38 +0800, Lin Ming wrote:
> > Currently we iterate the full machine looking for a matching core_id/nb
> > for the percore and the amd northbridge stuff , using a smaller topology
> > mask makes sense. 
> 
> Does topology_thread_cpumask() include offline cpus? I tried looking at
> it, but I cannot find any code clearing bits in that mask on offline.

The problem is not only at offline, but also at online between CPUs
going online.  I don't think the patch is a good idea and it doesn't
even have any advantages either since this is a initialization only
slow path.

-Andi

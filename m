Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab1BUDck (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 22:32:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47532 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab1BUDcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 22:32:39 -0500
Date: Mon, 21 Feb 2011 04:32:35 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] perf: Optimise topology iteration
Message-ID: <20110221033235.GW5818@one.firstfloor.org>
References: <1298221059.2318.70.camel@localhost> <20110220211512.GT5818@one.firstfloor.org> <1298258964.17806.48.camel@minggr.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298258964.17806.48.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 11:29:24AM +0800, Lin Ming wrote:
> On Mon, 2011-02-21 at 05:15 +0800, Andi Kleen wrote:
> > On Mon, Feb 21, 2011 at 12:57:39AM +0800, Lin Ming wrote:
> > > Currently we iterate the full machine looking for a matching core_id/nb
> > > for the percore and the amd northbridge stuff , using a smaller topology
> > > mask makes sense.
> > 
> > This is still wrong for CPU hotplug. The CPU "owning" the per core
> > does not necessarily need to be online anymore.
> 
> This is remain issue for hotplug case, no matter we use
> for_each_online_cpu or topology_thread_cpumask.

The original code I submitted used for_each_possible_cpu which
is correct.

> 
> > Please drop this patch.
> 
> Re-look at the code, I think for_each_online_cpu is wrong for percore,
> we should use topology_thread_cpumask instead.

No, that's also cleared on unplug. You really need the possible map
and nothing else.

-Andi

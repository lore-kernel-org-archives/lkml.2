Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab2FMVyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:54:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:40967 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab2FMVyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:54:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="179664043"
Date: Wed, 13 Jun 2012 14:54:24 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] perf, x86: Enable PDIR precise instruction profiling
 on IvyBridge
Message-ID: <20120613215424.GG32604@tassilo.jf.intel.com>
References: <1339615201-7456-1-git-send-email-andi@firstfloor.org>
 <1339615201-7456-2-git-send-email-andi@firstfloor.org>
 <1339622781.8980.63.camel@twins>
 <20120613213651.GD32604@tassilo.jf.intel.com>
 <1339623838.8980.71.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339623838.8980.71.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >nor does the patch actually lift it.
> > 
> > Why not? It works for me on a Ivy Bridge.
> 
> I'm very sure you didn't test it properly then. Clearly you need a hint:
> 
> struct event_constraint intel_snb_pebs_event_constraints[] = {
>         INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PRECDIST */
> 
> Is still in effect, isn't it..

Yes it's in effect, and it forces the event to counter 1. 
That is correct and that restriction is still there. 
Just what is gone is the restriction to quiescence the whole PMU.

Also without that we would refuse to enable PEBS anyways
I believe.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only

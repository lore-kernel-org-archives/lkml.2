Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab0LVJEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 04:04:21 -0500
Received: from canuck.infradead.org ([134.117.69.58]:56983 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab0LVJEQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 04:04:16 -0500
Subject: Re: [RFC PATCH] perf: Add load latency monitoring on Intel
 Nehalem/Westmere
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1293006808.2170.42.camel@laptop>
References: <1293005543.2565.156.camel@minggr.sh.intel.com>
	 <1293006808.2170.42.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Dec 2010 10:04:16 +0100
Message-ID: <1293008656.2170.67.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 09:33 +0100, Peter Zijlstra wrote:
> On Wed, 2010-12-22 at 16:12 +0800, Lin Ming wrote:
> > It's applied on top of tip/master(3ea1f4f89) and Andi's offcore
> > patchsets are needed. 
> 
> I still haven't gotten a version of that I'm willing to apply.

That is, maybe you could pick up his patches and finish them, Andi
doesn't seem interested in getting them sorted.

I think the last posting lost the needs_percore logic, which would avoid
the percore allocations on platforms that don't need it (if we can
detect if HT is enabled that would be nice too).

I think he also lost the topology iteration (which can be used for both
the percore and the amd northbridge stuff), currently we iterate the
full machine looking for a matching nb/core_id, using a smaller topology
mask makes sense.

Also, after reading your patch, I think we want the MSR names in the
lists, not the numbers.


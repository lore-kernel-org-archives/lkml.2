Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab1DZJtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 05:49:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48313 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab1DZJtd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 05:49:33 -0400
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <alpine.DEB.2.00.1104251736220.12389@cl320.eecs.utk.edu>
References: <1303407662-15564-1-git-send-email-acme@infradead.org>
	 <1303407662-15564-2-git-send-email-acme@infradead.org>
	 <20110422063429.GA16643@elte.hu> <20110422080604.GA22611@elte.hu>
	 <alpine.DEB.2.00.1104251307010.12389@cl320.eecs.utk.edu>
	 <20110425175444.GC28239@elte.hu>
	 <alpine.DEB.2.00.1104251736220.12389@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Apr 2011 11:49:05 +0200
Message-ID: <1303811345.20212.232.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-25 at 17:46 -0400, Vince Weaver wrote:
> > The policy is very simple and common-sense: if a given piece of PMU 
> > functionality is useful enough to be exposed via a raw interface, then
> > it must be useful enough to be generalized as well.
> 
> what does that even mean?  How do you "generalize" a functionality like 
> writing a value to an auxiliary MSR register? 

Come-on Vince, I know you're smarter than that!

The external register is simply an extension of the configuration space,
instead of the normal evsel msr you get evsel:offcore pairs. After that
its simply scheduling them right.

It simply adds more events to the PMU (in a rather sad way, it would
have been so much nicer if Intel had simply extended the evsel MSR for
every PMC, they could have also used that for the load-latency thing
etc.)

Now, these extra events offered are L3 and NUMA events, the 'common'
interesting set is mostly covered by Andi's LLC mods and my NODE
extension, after that there's mostly details left in offcore.

So the writing of an extra MSR is totally irrelevant, its the extra
events that are.

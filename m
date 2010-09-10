Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab0IJQPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 12:15:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51442 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab0IJQPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 12:15:42 -0400
Subject: Re: [PATCH] x86: fix duplicate calls of the nmi handler
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "eranian@google.com" <eranian@google.com>
In-Reply-To: <20100910155659.GD13563@erda.amd.com>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
	 <1284118900.402.35.camel@laptop> <20100910132741.GB4879@redhat.com>
	 <20100910144634.GA1060@elte.hu>  <20100910155659.GD13563@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Sep 2010 18:15:16 +0200
Message-ID: <1284135316.402.115.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 17:56 +0200, Robert Richter wrote:
> On 10.09.10 10:46:34, Ingo Molnar wrote:
> > > > I'll look at getting a trace of the thing, but if any of you has
> a
> > > > bright idea...
> 
> I found another patch in my queue, which fixes a duplicate call of the
> nmi handler. Since I could not yet reproduce the bug, I am not sure if
> this fixes the problem, but it is worth a try.
> 
> 

           <...>-6114  [001]   340.053060: perf_event_nmi_handler: NMI-handled(1): 34833 27411 1
           <...>-6114  [001]   340.053061: perf_event_nmi_handler: NMI-stop: 34833 27411 1
           <...>-6114  [001]   340.053062: perf_event_nmi_handler: NMI: 34834 27411 1
           <...>-6114  [001]   340.053063: x86_pmu_handle_irq: OVERFLOW: 1
           <...>-6114  [001]   340.053064: x86_pmu_handle_irq: HANDLED: 1
           <...>-6114  [001]   340.053067: perf_event_nmi_handler: NMI-handled(1): 34834 27411 1
           <...>-6114  [001]   340.053068: perf_event_nmi_handler: NMI-stop: 34834 27411 1
           <...>-6114  [001]   340.053069: perf_event_nmi_handler: NMI: 34835 27411 1
           <...>-6114  [001]   340.053070: perf_event_nmi_handler: NMI-handled(0): 34835 27411 1
           <...>-6114  [001]   340.053071: perf_event_nmi_handler: NMI: 34835 27411 1
           <...>-6114  [001]   340.053072: perf_event_nmi_handler: NMI: 34835 27411 1
           <...>-6114  [001]   340.053073: perf_event_nmi_handler: NMI-fail


Nope.. it doesn't get tagged because handled == 1, not > 1.

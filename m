Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab0KDT3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 15:29:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:44211 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab0KDT3I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 15:29:08 -0400
Subject: Re: [DRAFT PATCH 2/3] perf: Implement Nehalem uncore pmu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "paulus@samba.org" <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTi=GVVWxOpZ9Gorn4_r2tASAqOV5+BT7o92xrwJJ@mail.gmail.com>
References: <1288682905.12061.109.camel@minggr.sh.intel.com>
	 <AANLkTimyTYNczZqV5gPmKfL6iYjNf3wpYYFi+5US8bP3@mail.gmail.com>
	 <1288712023.2457.25.camel@localhost>
	 <AANLkTi=GVVWxOpZ9Gorn4_r2tASAqOV5+BT7o92xrwJJ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 04 Nov 2010 20:28:49 +0100
Message-ID: <1288898929.2039.78.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-02 at 17:59 +0100, Stephane Eranian wrote:
> I think using uncore PMU to measure per-thread is pretty much useless.
> Maybe it should not even be allowed. There is no way you can correlate
> the counts you're getting to a place in your program. Or put differently,
> sampling in per-thread mode using uncore is useless. 

Right, per-task uncore event should not be allowed. I think it as simple
as setting pmu::task_ctx_nr = perf_invalid_context.

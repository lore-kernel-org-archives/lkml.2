Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab0KKMqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:46:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:34306 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab0KKMqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:46:36 -0500
Subject: Re: [RFC PATCH 2/2] perf stat: Use event group to simulate PMI on
 PMI-less hardware counter
From: Peter Zijlstra <peterz@infradead.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: "Lin, Ming M" <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Matt Fleming <matt@console-pimps.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1289440836.8148.1365.camel@rui>
References: <1289369725.2430.39.camel@minggr.sh.intel.com>
	 <1289391709.2191.102.camel@laptop>  <1289400319.2479.39.camel@localhost>
	 <1289400784.2191.134.camel@laptop>  <1289440836.8148.1365.camel@rui>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 13:46:41 +0100
Message-ID: <1289479601.2084.76.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 10:00 +0800, Zhang Rui wrote:
> Well, the RAPL package energy perf event may need this piece of code.
> 
>  "MSR_PKG_ENERGY_STATUS is a read-only MSR. It reports the actual energy
> use for the package domain. This MSR is updated every ~1msec. It has a
> wraparound time of around 60 secs when power consumption is high, and
> may be longer otherwise."
> 
> As it's an energy counter, we should show it in "perf stat", right?
> As it doesn't have interrupt, I want to schedule a timer interrupt every
> 30s to update the event counter. 

So use a timer inside the RAPL pmu driver. No need to change the
interface or add generic code.

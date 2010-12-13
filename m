Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab0LMTXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 14:23:03 -0500
Received: from canuck.infradead.org ([134.117.69.58]:38859 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab0LMTXB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 14:23:01 -0500
Subject: Re: [PATCH 1/2] perf tools: Add reference timestamp to perf header
From: Peter Zijlstra <peterz@infradead.org>
To: "David S. Ahern" <daahern@cisco.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4D0670BF.6050403@cisco.com>
References: <20101213170923.GB1691@nowhere>
	 <1292260289.6803.297.camel@twins> <20101213171537.GC1691@nowhere>
	 <1292260699.6803.305.camel@twins>
	 <20101213172216.GB7417@ghostprotocols.net>
	 <1292261716.6803.332.camel@twins> <1292262433.6803.351.camel@twins>
	 <4D065CB2.7050104@cisco.com> <1292263024.6803.370.camel@twins>
	 <4D065F69.7080707@cisco.com> <20101213190831.GA7984@ghostprotocols.net>
	 <4D0670BF.6050403@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Dec 2010 20:22:26 +0100
Message-ID: <1292268146.6803.492.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 12:15 -0700, David S. Ahern wrote:
> >   monotonic-clock
> 
> Name seems off. The 'event' is to grab time-of-day and have the 'time'
> attribute set which gives the correlation between wall-clock and perf
> timestamps. 

Well, you really want CLOCK_MONOTONIC, not CLOCK_REALTIME (nothing what
so ever to do with Real-Time computing, just another brilliant POSIX
misnomer), or possibly even CLOCK_MONOTONIC_RAW.

gettimeofday() usually returns CLOCK_REALTIME  which is subject to both
NTP and timezone adjustments.

CLOCK_MONOTONIC is only subject to NTP

CLOCK_MONOTONIC_RAW is neither.

At some point we'll try and have CLOCK_TRACING and provide a similar
time to user-space that we currently use for perf (using the VDSO to
avoid any actual system-calls).



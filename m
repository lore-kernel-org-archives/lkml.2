Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab2FLSFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:05:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53690 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab2FLSFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:05:02 -0400
Date: Tue, 12 Jun 2012 20:04:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>, Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on SandyBridge
Message-ID: <20120612180455.GB11413@one.firstfloor.org>
References: <1339161972.2507.13.camel@laptop> <20120612170725.GE5046@erda.amd.com> <CABPqkBRJAA7yRcswM1iYESSwhiGD4SEbir=q=ouQSevi7OAxqQ@mail.gmail.com> <1339521203.31548.92.camel@twins> <20120612171734.GI8404@aftab.osrc.amd.com> <1339521493.31548.93.camel@twins> <20120612172352.GA4802@aftab.osrc.amd.com> <1339521996.31548.95.camel@twins> <20120612173506.GB4802@aftab.osrc.amd.com> <1339522843.31548.100.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339522843.31548.100.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, you can create a pebs event while updating micro-code. There's a
> race window there if you don't check all cpus.

The best proposal I've seen so far was to track the minimum ucode
revision and check that on every syscall.

This can be a single global, so it should not be very exepsnive.

I can look at implementing that if that solution is agreeable with 
everyone.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab2FLUKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 16:10:09 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:59165 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab2FLUKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 16:10:07 -0400
Date: Tue, 12 Jun 2012 22:10:28 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120612201028.GD11137@aftab.osrc.amd.com>
References: <1339161972.2507.13.camel@laptop>
 <20120612170725.GE5046@erda.amd.com>
 <CABPqkBRJAA7yRcswM1iYESSwhiGD4SEbir=q=ouQSevi7OAxqQ@mail.gmail.com>
 <1339521203.31548.92.camel@twins>
 <20120612171734.GI8404@aftab.osrc.amd.com>
 <1339521493.31548.93.camel@twins>
 <20120612172352.GA4802@aftab.osrc.amd.com>
 <1339521996.31548.95.camel@twins>
 <20120612173506.GB4802@aftab.osrc.amd.com>
 <1339522843.31548.100.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339522843.31548.100.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 07:40:43PM +0200, Peter Zijlstra wrote:
> How so? afaict there's nothing stopping it from working.

I spoke too soon. It works but only if you have a
newer-than-whats-on-the-system microcode image file. IOW, you need to
move the microcode image away so that the ucode driver doesn't find it,
boot, then move it back to /lib/firmware and do the reload thing through
sysfs.

Last time I tried this, the microcode got already updated during boot
and so the loading path didn't find a newer image, leading me to think
the interface didn't work and I didn't dig deeper as to why it didn't.

Which means that I definitely need to disable this on AMD. I'll try to
cook up something...

> Ideally this interface should be removed, but yeah. As long as its there
> you have to check all CPUs, because officially supported or not simply
> doesn't matter, the user can do it.
> 
> Also, you can create a pebs event while updating micro-code. There's a
> race window there if you don't check all cpus.

Oh man, this is just nasty.

Ok, we could probably make the notifier functionality dependent on
whether the ucode driver for a vendor supports the reload_store
interface and thus single cpu ucode updates. If it doesn't, no need to
run the notifier per cpu but then the story with the race window is
still unsolved.

I need to sleep on it.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

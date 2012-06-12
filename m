Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab2FLUhM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 16:37:12 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:59250 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab2FLUhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 16:37:09 -0400
Date: Tue, 12 Jun 2012 22:37:30 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120612203730.GE11137@aftab.osrc.amd.com>
References: <20120607071531.GA4849@quad>
 <4FD78BE6.4060207@zytor.com>
 <20120612190720.GA11137@aftab.osrc.amd.com>
 <1339529614.31548.104.camel@twins>
 <20120612194900.GC11137@aftab.osrc.amd.com>
 <4FD7A687.3040500@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD7A687.3040500@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 01:28:55PM -0700, H. Peter Anvin wrote:
> On 06/12/2012 12:49 PM, Borislav Petkov wrote:
> > 
> > Also, I'd assume we need some of the current functionality to be able to
> > load ucode without rebooting the box.
> > 
> 
> Yes, the basic idea is that we'll keep the ucode around anyway so we can
> feed it to hotplug CPUs or S3 resume.  If the ucode is updated from
> userspace we'd replace the in-memory copy and load it into the CPUs.

You say CPUs, i.e. plural. What is your take on loading ucode on a
single core, i.e. the /sys/devices/system/cpu/cpuX/microcode/reload
interface? Do you guys need to load ucode only system-wide or can you
stomach per-core loads?

I want to disable it (or even remove it, modulo the whole userspace
compat blah blah) on AMD.

Also, if we do system-wide, can we have a single sysfs node where we
give the new ucode from userspace instead of per-cpu files?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

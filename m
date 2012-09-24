Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab2IXSTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 14:19:37 -0400
Received: from mail.x86-64.org ([217.9.48.20]:35386 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757298Ab2IXSTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 14:19:35 -0400
Date: Mon, 24 Sep 2012 20:19:27 +0200
From: Borislav Petkov <bp@amd64.org>
To: Conny Seidel <conny.seidel@amd.com>
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>
Subject: Re: divide error: bdi_dirty_limit+0x5a/0x9e
Message-ID: <20120924181927.GA25762@aftab.osrc.amd.com>
References: <20120924102324.GA22303@aftab.osrc.amd.com>
 <20120924142305.GD12264@quack.suse.cz>
 <20120924143609.GH22303@aftab.osrc.amd.com>
 <20120924201650.6574af64.conny.seidel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120924201650.6574af64.conny.seidel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 08:16:50PM +0200, Conny Seidel wrote:
> Hi,
> 
> On Mon, 24 Sep 2012 16:36:09 +0200
> Borislav Petkov <bp@amd64.org> wrote:
> >[ … ]
> >
> >Conny, would you test pls?
> 
> Sure thing.
> Out of ~25 runs I only triggered it once, without the patch the
> trigger-rate is higher.
> 
> [   55.098249] Broke affinity for irq 81
> [   55.105108] smpboot: CPU 1 is now offline
> [   55.311216] smpboot: Booting Node 0 Processor 1 APIC 0x11
> [   55.333022] LVT offset 0 assigned for vector 0x400
> [   55.545877] smpboot: CPU 2 is now offline
> [   55.753050] smpboot: Booting Node 0 Processor 2 APIC 0x12
> [   55.775582] LVT offset 0 assigned for vector 0x400
> [   55.986747] smpboot: CPU 3 is now offline
> [   56.193839] smpboot: Booting Node 0 Processor 3 APIC 0x13
> [   56.212643] LVT offset 0 assigned for vector 0x400
> [   56.423201] Got negative events: -25

I see it:

__percpu_counter_sum does for_each_online_cpu without doing
get/put_online_cpus().

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

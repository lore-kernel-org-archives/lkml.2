Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab2FMQLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 12:11:35 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:35231 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab2FMQLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 12:11:20 -0400
Date: Wed, 13 Jun 2012 18:11:39 +0200
From: Borislav Petkov <bp@amd64.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120613161139.GA18450@aftab.osrc.amd.com>
References: <CABPqkBRJAA7yRcswM1iYESSwhiGD4SEbir=q=ouQSevi7OAxqQ@mail.gmail.com>
 <1339521203.31548.92.camel@twins>
 <20120612171734.GI8404@aftab.osrc.amd.com>
 <1339521493.31548.93.camel@twins>
 <20120612172352.GA4802@aftab.osrc.amd.com>
 <1339521996.31548.95.camel@twins>
 <20120612173506.GB4802@aftab.osrc.amd.com>
 <20120613010413.GA28174@khazad-dum.debian.net>
 <20120613065119.GB15661@aftab.osrc.amd.com>
 <20120613123649.GA26012@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613123649.GA26012@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 09:36:49AM -0300, Henrique de Moraes Holschuh wrote:
> Yes, please. I suggest we use core 0 for that. Using my Debian
> maintainer hat, I'd rather you got rid of the sysfs entries for every
> other core while at it, as it will make our life a lot simpler,
> distro-side.

Wouldn't we have some sort of ABI breakage if I remove the sysfs files?
Instead, I was thinking of having the rest of the files not on the BSP
return -EINVAL and only the BSP reload ucode on the whole system.

> This is still not the proper fix, which would be to add a new sysfs node
> to access the proper update-every-core functionality, but it is a damn
> good start in the right direction and required to make it safe without
> ripping out the old ABI entirely without a deprecation period.

Yes, I'd like to have the system-wide sysfs node somewhere under
/sys/devices/system/cpu/microcode/ but we'll see how that goes.

> Since Intel processors don't want the per-core behaviour either, you
> could fix it in the microcode core itself...

Yes.

> Ok. Please CC me in the patches, if the new ABI arrives in time, I'll
> even be able to get it supported on the next Debian stable (and push
> to get this stuff backported to the kernel 3.2 which we will ship,
> I consider this an important bug-fix to a pontentially very serious
> issue. We have *zero* chance of finding out what's wrong if an users'
> system start getting subtly crazy because it is running with skewed
> microcode among cores.

Ok, will do.

Btw, I have to think about whether we really want to backport this to
stable since it is not a regression fix but functionality change which
kinda fixes a some sort of bug. Hmm, the stable rules are kinda blurry
here. I could write a minimal fix with stable in mind though... we'll
see.

hpa, what is our take here, should we backport a minimal change
disabling reloading of ucode per-cpu for stable? It is the wrong thing
to do anyway.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

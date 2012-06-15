Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab2FOMwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:52:22 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:44171 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811Ab2FOMwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:52:21 -0400
Date: Fri, 15 Jun 2012 14:52:40 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>, LKML <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120615125240.GD6083@aftab.osrc.amd.com>
References: <1339521493.31548.93.camel@twins>
 <20120612172352.GA4802@aftab.osrc.amd.com>
 <1339521996.31548.95.camel@twins>
 <20120612173506.GB4802@aftab.osrc.amd.com>
 <20120613010413.GA28174@khazad-dum.debian.net>
 <20120613065119.GB15661@aftab.osrc.amd.com>
 <20120613123649.GA26012@khazad-dum.debian.net>
 <20120613161139.GA18450@aftab.osrc.amd.com>
 <20120615123749.GC6083@aftab.osrc.amd.com>
 <1339764161.2559.63.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339764161.2559.63.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 02:42:41PM +0200, Peter Zijlstra wrote:
> On Fri, 2012-06-15 at 14:37 +0200, Borislav Petkov wrote:
> > This is a minimal fix which we'd like to see in stable too thus the
> > more-or-less arbitrary decision to allow system-wide reloading only on
> > the BSP:
> > 
> > $ echo 1 > /sys/devices/system/cpu/cpu0/microcode/reload
> > ...
> > 
> > and disable the interface on the other cores:
> > 
> > $ echo 1 > /sys/devices/system/cpu/cpu23/microcode/reload
> > -bash: echo: write error: Invalid argument 
> 
> One could allow the reload from all cpus and simply do all cpus, but I
> guess the rationale for not doing that and restricting it to cpu0 is to
> avoid the O(n^2) thing in case userspace issues a reload on all cpus?

That's a good point.

Actually, the BSP thing was more-or-less an arbitrary deal. What we want as an
endresult is to do:

$ echo 1 > /sys/devices/system/cpu/microcode/reload

(notice this is in the toplevel "cpu" directory in sysfs)

and do the system-wide reload there.

Obviously, this needs a couple of more patches and we wanted to have a
simplest stable fix first.

> If so it would be good to mention in the Changelog so people see its not
> a 'random' choice.

Yes, will do, thanks!

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab2FSFDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 01:03:10 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:40091 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab2FSFDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 01:03:09 -0400
Date: Tue, 19 Jun 2012 07:03:25 +0200
From: Borislav Petkov <bp@amd64.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Borislav Petkov <bp@amd64.org>, LKML <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH] x86, microcode: Make reload interface per system
Message-ID: <20120619050325.GA31591@aftab.osrc.amd.com>
References: <20120612173506.GB4802@aftab.osrc.amd.com>
 <20120613010413.GA28174@khazad-dum.debian.net>
 <20120613065119.GB15661@aftab.osrc.amd.com>
 <20120613123649.GA26012@khazad-dum.debian.net>
 <20120613161139.GA18450@aftab.osrc.amd.com>
 <20120615123749.GC6083@aftab.osrc.amd.com>
 <1339764161.2559.63.camel@twins>
 <20120615125240.GD6083@aftab.osrc.amd.com>
 <20120615165231.GA9169@aftab.osrc.amd.com>
 <20120619024639.GB6186@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120619024639.GB6186@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 11:46:39PM -0300, Henrique de Moraes Holschuh wrote:
> On Fri, 15 Jun 2012, Borislav Petkov wrote:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > Date: Fri, 15 Jun 2012 18:46:05 +0200
> > Subject: [PATCH] x86, microcode: Make reload interface per system
> > 
> > The reload interface should be per-system so that a full system ucode
> > reload happens (on each core) when doing
> > 
> > echo 1 > /sys/devices/system/cpu/microcode/reload
> > 
> > Move it to the cpu subsys directory instead of it being per-cpu.
> > 
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> 
> It is a pity this one is much harder to backport to 3.2 and 3.0.

Yeah, not harder. It changes the sysfs interface and we can't do that
for already released kernels.

But I think you meant that.

> I'd really like to have the new interface there. But it looks good,
> and we will support the new /sys/devices/system/cpu/microcode/reload
> sysfs node in Debian for the benefit of anyone using a newer kernel
> than the distro's (which will be based on 3.2).

Right, hopefully the next Debian release will have that nice shiny new
interface :-)

> So, fwiw, you have my:
> Acked-by-unimportant-person: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

No, don't underestimate yourself. I think it helps a lot to have someone
look at the patch and even better: give comments whether what we're
doing is sane for userspace. So, I appreciate your comments a lot, keep
'em coming :-)

Thanks for review and testing, I'll send out the patches soon.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

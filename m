Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab2FSFLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 01:11:00 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:40135 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab2FSFK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 01:10:59 -0400
Date: Tue, 19 Jun 2012 07:11:16 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Borislav Petkov <bp@amd64.org>, LKML <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH] x86, microcode: Make reload interface per system
Message-ID: <20120619051116.GB31591@aftab.osrc.amd.com>
References: <20120613010413.GA28174@khazad-dum.debian.net>
 <20120613065119.GB15661@aftab.osrc.amd.com>
 <20120613123649.GA26012@khazad-dum.debian.net>
 <20120613161139.GA18450@aftab.osrc.amd.com>
 <20120615123749.GC6083@aftab.osrc.amd.com>
 <1339764161.2559.63.camel@twins>
 <20120615125240.GD6083@aftab.osrc.amd.com>
 <20120615165231.GA9169@aftab.osrc.amd.com>
 <20120619024639.GB6186@khazad-dum.debian.net>
 <4FDFF27C.5000205@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FDFF27C.5000205@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 08:31:08PM -0700, H. Peter Anvin wrote:
> On 06/18/2012 07:46 PM, Henrique de Moraes Holschuh wrote:
> > 
> > It is a pity this one is much harder to backport to 3.2 and 3.0.  I'd
> > really like to have the new interface there.  But it looks good, and we
> > will support the new /sys/devices/system/cpu/microcode/reload sysfs node
> > in Debian for the benefit of anyone using a newer kernel than the
> > distro's (which will be based on 3.2).
> > 
> > So, fwiw, you have my:
> > Acked-by-unimportant-person: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > 
> 
> I have to admit to being slightly questioning to the whole "sysfs
> trigger, request_firmware" interface... it seems royally backwards to me
> (it makes sense for the initial firmware load, I guess, but that is
> better done early.)

Two reasons:

1. There are those guys who like to run their systems for years without
upgrading the kernel (you know who you are :)) and in such cases, you
want to be able to upgrade the microcode you loaded early with a newer
version which the hw vendor released in the meantime.

 [ Which makes the whole ucode-load-early deal not the solution to all
 problems since we need to be able to load ucode without rebooting too,
 if possible. ]

2. Right, we can do that by

$ rmmod microcode; modprobe microcode

but then the same guys come :-) and say they don't want to reload
modules for security reasons.

Thus the sysfs interface and sysfs is the proper thing we have for such
things so ...

... and I'm always open for better ideas, btw.

> Either way I don't have a hugely strong preference.

I'll run the patches here and send them out maybe later today if all
looks good.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

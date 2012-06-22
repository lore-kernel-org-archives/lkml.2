Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761398Ab2FVGlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 02:41:06 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:39262 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab2FVGlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 02:41:04 -0400
Date: Fri, 22 Jun 2012 08:41:00 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Peter Zijlstra <peterz@infradead.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
Message-ID: <20120622064100.GA286@x4>
References: <1340121811-4477-3-git-send-email-bp@amd64.org>
 <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
 <20120619232857.GH5996@aftab.osrc.amd.com>
 <4FE26155.8030207@zytor.com>
 <20120621100721.GB6437@aftab.osrc.amd.com>
 <4FE3ADDF.2060908@zytor.com>
 <20120622025631.GD29505@aftab.osrc.amd.com>
 <4FE3E428.8080207@zytor.com>
 <20120622033634.GG29505@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120622033634.GG29505@aftab.osrc.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.06.22 at 05:36 +0200, Borislav Petkov wrote:
> On Thu, Jun 21, 2012 at 08:19:04PM -0700, H. Peter Anvin wrote:
> > On 06/21/2012 07:56 PM, Borislav Petkov wrote:
> > >>
> > >> That is orthogonal.  Anyway, my only concern about the request_firmware
> > >> interface is that the timing will be inherently wrong.
> > > 
> > > Timing? Please elaborate.
> > > 
> > 
> > The request_firmware will happen as soon as the driver is loaded; with
> > the early microcode blob scheme the driver will need to be built in and
> > so the request_firmware will happen, redundantly, immediately...
> 
> What if BIOS has patch version 1 (numbers are only for showing what I
> mean), then early scheme applies patch v2 but there is a newer patch
> version 3 in /lib/firmware?
> 
> If the ucode driver is built in, we don't get to update to v3
> automatically. User has to do it.
> 
> The current fix for this situation is have the microcode.ko as module
> (and only allow it as M) which then automatically does request_firmware
> at module init time and loads v3.
> 
> Which doesn't help people who don't build modules...

People who don't use modules have:
 echo -n 1 > /sys/devices/system/cpu/cpu0/microcode/reload
 ...
in their init script already.

That will have to change to a single:
 echo -n 1 >| /sys/devices/system/cpu/microcode/reload
in your new scheme.

Of course the best solution would be to get rid of that manual reload
altogether and to automatically load the firmware during boot (even
without modules)...

-- 
Markus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2FSPGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 11:06:22 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:42051 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab2FSPGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 11:06:21 -0400
Date: Tue, 19 Jun 2012 17:06:19 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH] x86, microcode: Make reload interface per system
Message-ID: <20120619150619.GD1427@aftab.osrc.amd.com>
References: <20120615123749.GC6083@aftab.osrc.amd.com>
 <1339764161.2559.63.camel@twins>
 <20120615125240.GD6083@aftab.osrc.amd.com>
 <20120615165231.GA9169@aftab.osrc.amd.com>
 <20120619024639.GB6186@khazad-dum.debian.net>
 <4FDFF27C.5000205@zytor.com>
 <20120619051116.GB31591@aftab.osrc.amd.com>
 <1340093864.21745.6.camel@twins>
 <20120619102250.GA787@aftab.osrc.amd.com>
 <1340101568.21745.37.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340101568.21745.37.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 12:26:08PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-06-19 at 12:22 +0200, Borislav Petkov wrote:
> > 
> > But I haven't tested what happens when it is built in and I use the
> > reload interface, hehe something to play with today. 
> 
> I couldn't easily find where to place the damn ucode image anyway, so I
> built in the old-style /dev interface and used the microcode.ctl package
> to load it.
> 
> Fwiw, that works just fine when its built-in.

Ok, so something changed in the request_firmware thing in the meantime.
Last time I checked we waited for 60 seconds to get the ucode blob from
userspace but that wasn't happening that early in the boot process so we
continued without newer ucode patch.

Now we load the ucode driver very early if it is built-in (look at
printk timestamps):

[    3.651275] microcode: CPU0: patch_level=0x010000c4
[    3.664943] microcode: CPU1: patch_level=0x010000c4
[    3.670177] microcode: CPU2: patch_level=0x010000c4
[    3.675407] microcode: CPU3: patch_level=0x010000c4
...

and then later, when we have userspace, we can use the reload thing to
re-request microcode. Which is also fine, I guess.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

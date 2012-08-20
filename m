Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab2HTUUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 16:20:01 -0400
Received: from mail.x86-64.org ([217.9.48.20]:54632 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527Ab2HTUT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 16:19:56 -0400
Date: Mon, 20 Aug 2012 22:19:47 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 04/11] x86/microcode_core_early.c: Define interfaces for
 early load ucode
Message-ID: <20120820201947.GC15006@aftab.osrc.amd.com>
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
 <1345277729-8399-5-git-send-email-fenghua.yu@intel.com>
 <20120818224442.GB32120@khazad-dum.debian.net>
 <3E5A0FA7E9CA944F9D5414FEC6C71220077879BF@ORSMSX105.amr.corp.intel.com>
 <503078A2.9030204@zytor.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007787B22@ORSMSX105.amr.corp.intel.com>
 <20120820140630.GD24149@aftab.osrc.amd.com>
 <50329951.9030805@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50329951.9030805@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 01:08:49PM -0700, H. Peter Anvin wrote:
> On 08/20/2012 07:06 AM, Borislav Petkov wrote:
> > 
> > Or,
> > 
> > in case we want to supply more vendor-specific stuff early at boot, we
> > could do:
> > 
> > kernel/x86/<vendor>/microcode...
> > 		|-> bios_overrides
> > 		|-> ...
> > 
> > and have this layout extensible from the beginning...
> > 
> Does that make sense, though?

Only time will tell. I was simply saying that we should leave ourselves
the door opened, should we need functionality like that in the future.

> I'm a bit concerned about having multiple files named microcode.bin by
> default; the pathname isn't as sticky as the filename when people move
> things around...

Ok, I see.

How about the following scheme then:

kernel/x86/<vendor>-microcode.bin
kernel/x86/<vendor>-bios-overrides.blob
...

?

All I'm saying is maybe we should impose some sanity rules now before
people go crazy with this and things get out of hands...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

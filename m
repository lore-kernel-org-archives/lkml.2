Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab2HTOGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:06:43 -0400
Received: from mail.x86-64.org ([217.9.48.20]:52233 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab2HTOGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:06:39 -0400
Date: Mon, 20 Aug 2012 16:06:30 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 04/11] x86/microcode_core_early.c: Define interfaces for
 early load ucode
Message-ID: <20120820140630.GD24149@aftab.osrc.amd.com>
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
 <1345277729-8399-5-git-send-email-fenghua.yu@intel.com>
 <20120818224442.GB32120@khazad-dum.debian.net>
 <3E5A0FA7E9CA944F9D5414FEC6C71220077879BF@ORSMSX105.amr.corp.intel.com>
 <503078A2.9030204@zytor.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007787B22@ORSMSX105.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C7122007787B22@ORSMSX105.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 04:39:42PM +0000, Yu, Fenghua wrote:
> > Actually I think we can also skip one level of indirection here... no
> > need to mention "microcode" twice.
> > 
> > kernel/x86/microcode/GenuineIntel or GenuineIntel.bin seems good
> > enough... the idea here of course is that the string can come from
> > CPUID.
> That's right. Will do this.

Or,

in case we want to supply more vendor-specific stuff early at boot, we
could do:

kernel/x86/<vendor>/microcode...
		|-> bios_overrides
		|-> ...

and have this layout extensible from the beginning...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

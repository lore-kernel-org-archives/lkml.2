Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762518Ab2FVRZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 13:25:16 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:35904 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab2FVRZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 13:25:15 -0400
X-Greylist: delayed 3415 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jun 2012 13:25:14 EDT
From: Nix <nix@esperi.org.uk>
To: Borislav Petkov <bp@amd64.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "Yu\, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
References: <1340121811-4477-1-git-send-email-bp@amd64.org>
	<1340121811-4477-3-git-send-email-bp@amd64.org>
	<CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
	<3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
	<20120619232857.GH5996@aftab.osrc.amd.com>
	<1340182778.21745.75.camel@twins>
	<20120620095616.GB10012@aftab.osrc.amd.com>
	<1340186931.21745.90.camel@twins>
	<20120620101943.GE10012@aftab.osrc.amd.com>
Emacs: freely redistributable; void where prohibited by law.
Date: Fri, 22 Jun 2012 17:26:24 +0100
In-Reply-To: <20120620101943.GE10012@aftab.osrc.amd.com> (Borislav Petkov's
	message of "Wed, 20 Jun 2012 12:19:43 +0200")
Message-ID: <87d34r5n4f.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-STAT_FI_X86_64_VIRTUAL-Metrics: spindle 1245; Body=10 Fuz1=10 Fuz2=10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 Jun 2012, Borislav Petkov uttered the following:
> I know, right. Whose idea was it to do it like that I don't know.
> AFAICT, Intel delivers ucode as a single blob too, so why split it? The
> driver picks out the right blob anyway.

Only if supplied over the old interface. Over the new interface,
we just see

    microcode: error! Bad data in microcode data file

in the log. So clearly the driver doesn't know how to split up the
microcode.bin that Intel provides, and (until Henrique's iucode-tool or
something like it becomes ubiquitous) the old interface, and
microcode_ctl, cannot be removed.

-- 
NULL && (void)

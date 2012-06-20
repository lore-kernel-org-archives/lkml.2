Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab2FTKTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:19:46 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:45877 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab2FTKTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:19:45 -0400
Date: Wed, 20 Jun 2012 12:19:43 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Borislav Petkov <bp@amd64.org>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        X86-ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
Message-ID: <20120620101943.GE10012@aftab.osrc.amd.com>
References: <1340121811-4477-1-git-send-email-bp@amd64.org>
 <1340121811-4477-3-git-send-email-bp@amd64.org>
 <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
 <20120619232857.GH5996@aftab.osrc.amd.com>
 <1340182778.21745.75.camel@twins>
 <20120620095616.GB10012@aftab.osrc.amd.com>
 <1340186931.21745.90.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340186931.21745.90.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 12:08:51PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-06-20 at 11:56 +0200, Borislav Petkov wrote:
> >         sprintf(name, "intel-ucode/%02x-%02x-%02x",
> >                 c->x86, c->x86_model, c->x86_mask);
> > 
> > 
> 
> but but but, the ucode image actually contains stuff for multiple
> things.. so I have to like rename it to match the actual cpu in the
> machine?
> 
> That seems rather daft..
> 
> awk 'BEGIN { FS=":" } /family/ {fam=$2} /model[^ ]/ {mod=$2} /stepping/
> {step=$2} END { printf "intel-ucode/%02x-%02x-%02x\n", fam, mod,
> step }' /proc/cpuinfo
> 
> Will get me the right filename, but surely that's not user-friendly at
> all...

I know, right. Whose idea was it to do it like that I don't know.
AFAICT, Intel delivers ucode as a single blob too, so why split it? The
driver picks out the right blob anyway.

But there was a script somewhere which did that automatically. Henrique
will know more about how this is handled.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

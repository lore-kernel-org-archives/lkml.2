Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab2FTXcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:32:35 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:49370 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861Ab2FTXcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:32:33 -0400
Date: Thu, 21 Jun 2012 01:32:31 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Peter Zijlstra <peterz@infradead.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
Message-ID: <20120620233231.GF2016@aftab.osrc.amd.com>
References: <1340121811-4477-1-git-send-email-bp@amd64.org>
 <1340121811-4477-3-git-send-email-bp@amd64.org>
 <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
 <20120619232857.GH5996@aftab.osrc.amd.com>
 <1340182778.21745.75.camel@twins>
 <20120620230856.GA4223@khazad-dum.debian.net>
 <4FE2585A.3000505@zytor.com>
 <20120620232359.GD2016@aftab.osrc.amd.com>
 <4FE25C7E.9030109@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE25C7E.9030109@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 04:27:58PM -0700, H. Peter Anvin wrote:
> On 06/20/2012 04:23 PM, Borislav Petkov wrote:
> > On Wed, Jun 20, 2012 at 04:10:18PM -0700, H. Peter Anvin wrote:
> >> I'm wondering about the new format... it seems to potentially make it
> >> harder to do the proper retaining of compatible CPU microcodes.
> > 
> > .. and if you don't split the blob, you have all the ucode patches in
> > one package. So are there any advantages in splitting the single blob?
> > 
> 
> Not that I know of.  IMO the driver can, and should, be the one doing
> the pruning.

Which means that

static enum ucode_state request_microcode_fw(int cpu, struct device *device)
{
        char name[30];

	...

        sprintf(name, "intel-ucode/%02x-%02x-%02x",
                c->x86, c->x86_model, c->x86_mask);

needs to be changed to the name of the microcode blob you guys use for
distributing and we can drop the OLD INTERFACE and there'll be no need
for userspace tools doing anything with the ucode patches.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab2FTK1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:27:50 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:45917 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab2FTK1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:27:49 -0400
Date: Wed, 20 Jun 2012 12:27:47 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
Message-ID: <20120620102747.GF10012@aftab.osrc.amd.com>
References: <1340121811-4477-1-git-send-email-bp@amd64.org>
 <1340121811-4477-3-git-send-email-bp@amd64.org>
 <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
 <20120619232857.GH5996@aftab.osrc.amd.com>
 <1340182778.21745.75.camel@twins>
 <20120620095616.GB10012@aftab.osrc.amd.com>
 <1340186931.21745.90.camel@twins>
 <20120620101943.GE10012@aftab.osrc.amd.com>
 <1340187720.21745.97.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340187720.21745.97.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 12:22:00PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-06-20 at 12:19 +0200, Borislav Petkov wrote:
> > On Wed, Jun 20, 2012 at 12:08:51PM +0200, Peter Zijlstra wrote:
> > > On Wed, 2012-06-20 at 11:56 +0200, Borislav Petkov wrote:
> > > >         sprintf(name, "intel-ucode/%02x-%02x-%02x",
> > > >                 c->x86, c->x86_model, c->x86_mask);
> > > > 
> > > > 
> > > 
> > > but but but, the ucode image actually contains stuff for multiple
> > > things.. so I have to like rename it to match the actual cpu in the
> > > machine?
> > > 
> > > That seems rather daft..
> > > 
> > > awk 'BEGIN { FS=":" } /family/ {fam=$2} /model[^ ]/ {mod=$2} /stepping/
> > > {step=$2} END { printf "intel-ucode/%02x-%02x-%02x\n", fam, mod,
> > > step }' /proc/cpuinfo
> > > 
> > > Will get me the right filename, but surely that's not user-friendly at
> > > all...
> > 
> > I know, right. Whose idea was it to do it like that I don't know.
> > AFAICT, Intel delivers ucode as a single blob too, so why split it? The
> > driver picks out the right blob anyway.
> 
> Right, so since we're mucking about with the whole interface anyway,
> can't we fix this too?

Right,

so you can download Intel ucode from here, for example:

http://downloadcenter.intel.com/Detail_Desc.aspx?ProductID=483&DwnldID=14303

and the binary blob is 1.2 MB unpacked. Which could explain why it is
being split - I can see how loading 1.2 MB from userspace could be a
PITA.

But if we had a script which would split it and we had it in tools/,
then all would be fine, right?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492Ab2FTXVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:21:22 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57453 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758315Ab2FTXVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:21:21 -0400
X-Sasl-enc: UqgAdTzcNgRrrpj1b3e3EXXrhGUaSphbBxJtsy5Rjdk6 1340234479
Date: Wed, 20 Jun 2012 20:21:17 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        X86-ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
Message-ID: <20120620232117.GC4223@khazad-dum.debian.net>
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
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012, Peter Zijlstra wrote:
> On Wed, 2012-06-20 at 12:19 +0200, Borislav Petkov wrote:
> > On Wed, Jun 20, 2012 at 12:08:51PM +0200, Peter Zijlstra wrote:
> > > On Wed, 2012-06-20 at 11:56 +0200, Borislav Petkov wrote:
> > > >         sprintf(name, "intel-ucode/%02x-%02x-%02x",
> > > >                 c->x86, c->x86_model, c->x86_mask);
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

Please!

Just make it attempt to load a statically named firmware file first, and
fall back to the older variable naming.

If the reason for the weird naming is a size concern, "iucode_tool
--scan-system -w /lib/firmware/intel-ucode/x86.bin" (or whatever you name
it) would create a file with just the microcode required by the (online)
processors in the running system.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

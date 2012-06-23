Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab2FWBcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 21:32:09 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40677 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756894Ab2FWBcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 21:32:07 -0400
X-Sasl-enc: nYcWhebuFBs76biinjmO3k+ml0qE1dgGfJM2znDntK8l 1340415125
Date: Fri, 22 Jun 2012 22:32:02 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Nix <nix@esperi.org.uk>, Borislav Petkov <bp@amd64.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
Message-ID: <20120623013202.GA22572@khazad-dum.debian.net>
References: <1340121811-4477-3-git-send-email-bp@amd64.org>
 <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
 <20120619232857.GH5996@aftab.osrc.amd.com>
 <1340182778.21745.75.camel@twins>
 <20120620095616.GB10012@aftab.osrc.amd.com>
 <1340186931.21745.90.camel@twins>
 <20120620101943.GE10012@aftab.osrc.amd.com>
 <87d34r5n4f.fsf@spindle.srvr.nix>
 <4FE4B796.3050009@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE4B796.3050009@zytor.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2012, H. Peter Anvin wrote:
> On 06/22/2012 09:26 AM, Nix wrote:
> > On 20 Jun 2012, Borislav Petkov uttered the following:
> >> I know, right. Whose idea was it to do it like that I don't know.
> >> AFAICT, Intel delivers ucode as a single blob too, so why split it? The
> >> driver picks out the right blob anyway.
> > 
> > Only if supplied over the old interface. Over the new interface,
> > we just see
> > 
> >     microcode: error! Bad data in microcode data file
> > 
> > in the log. So clearly the driver doesn't know how to split up the
> > microcode.bin that Intel provides, and (until Henrique's iucode-tool or
> > something like it becomes ubiquitous) the old interface, and
> > microcode_ctl, cannot be removed.
> 
> Even more importantly, to do early microcode updates we need to stash
> away not just the current CPU's microcode but any compatible CPU's
> microcode, so just loading a single one is not going to work...

Well, THAT is rather difficult with Intel.  You really have no choice
other than packing all microcodes, or just the ones for the current
system.  For all microcodes, it will compresses to around 350KiB with
gzip.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

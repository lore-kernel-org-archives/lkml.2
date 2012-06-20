Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab2FTXqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:46:16 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:49438 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758417Ab2FTXqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:46:15 -0400
Date: Thu, 21 Jun 2012 01:46:11 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Peter Zijlstra <peterz@infradead.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
Message-ID: <20120620234611.GA3440@aftab.osrc.amd.com>
References: <1340121811-4477-3-git-send-email-bp@amd64.org>
 <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
 <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
 <20120619232857.GH5996@aftab.osrc.amd.com>
 <1340182778.21745.75.camel@twins>
 <20120620230856.GA4223@khazad-dum.debian.net>
 <4FE2585A.3000505@zytor.com>
 <20120620232359.GD2016@aftab.osrc.amd.com>
 <4FE25C7E.9030109@zytor.com>
 <4FE25DF9.2020305@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE25DF9.2020305@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 04:34:17PM -0700, H. Peter Anvin wrote:
> On 06/20/2012 04:32 PM, Borislav Petkov wrote:
> > 
> > Which means that
> > 
> > static enum ucode_state request_microcode_fw(int cpu, struct device *device)
> > {
> >         char name[30];
> > 
> > 	...
> > 
> >         sprintf(name, "intel-ucode/%02x-%02x-%02x",
> >                 c->x86, c->x86_model, c->x86_mask);
> > 
> > needs to be changed to the name of the microcode blob you guys use for
> > distributing and we can drop the OLD INTERFACE and there'll be no need
> > for userspace tools doing anything with the ucode patches.
> > 
> 
> Except you still need to re-poke it when you have a new microcode
> blob... so what was gained by all this churn?

We need to do that anyway if new (F,M,S) ucode piece comes along.

The gain is twofold:

* we don't need the userspace tool to split the blob - we have one
single file we load and the driver picks out what it needs.

* as a result, we drop the CONFIG_MICROCODE_OLD_INTERFACE, i.e.
/dev/cpu/microcode which takes the single blob anyway which the driver
picks apart later.

In the end, we have one unified ucode loading procedure:

1. put the blob in /lib/firmware/...
2. echo 1 > /sys/devices/system/cpu/microcode/reload

That's it - it can't be simpler than that.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

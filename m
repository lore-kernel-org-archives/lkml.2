Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab2FVSXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 14:23:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34242 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab2FVSXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 14:23:43 -0400
Message-ID: <4FE4B796.3050009@zytor.com>
Date: Fri, 22 Jun 2012 11:21:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Nix <nix@esperi.org.uk>
CC: Borislav Petkov <bp@amd64.org>, Peter Zijlstra <peterz@infradead.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "Yu\, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
References: <1340121811-4477-1-git-send-email-bp@amd64.org> <1340121811-4477-3-git-send-email-bp@amd64.org> <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com> <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com> <20120619232857.GH5996@aftab.osrc.amd.com> <1340182778.21745.75.camel@twins> <20120620095616.GB10012@aftab.osrc.amd.com> <1340186931.21745.90.camel@twins> <20120620101943.GE10012@aftab.osrc.amd.com> <87d34r5n4f.fsf@spindle.srvr.nix>
In-Reply-To: <87d34r5n4f.fsf@spindle.srvr.nix>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2012 09:26 AM, Nix wrote:
> On 20 Jun 2012, Borislav Petkov uttered the following:
>> I know, right. Whose idea was it to do it like that I don't know.
>> AFAICT, Intel delivers ucode as a single blob too, so why split it? The
>> driver picks out the right blob anyway.
> 
> Only if supplied over the old interface. Over the new interface,
> we just see
> 
>     microcode: error! Bad data in microcode data file
> 
> in the log. So clearly the driver doesn't know how to split up the
> microcode.bin that Intel provides, and (until Henrique's iucode-tool or
> something like it becomes ubiquitous) the old interface, and
> microcode_ctl, cannot be removed.
> 

Even more importantly, to do early microcode updates we need to stash
away not just the current CPU's microcode but any compatible CPU's
microcode, so just loading a single one is not going to work...

Oif.

	-hpa


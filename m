Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2FTKJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:09:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:55896 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab2FTKJD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:09:03 -0400
Message-ID: <1340186931.21745.90.camel@twins>
Subject: Re: [PATCH 2/2] x86, microcode: Make reload interface per system
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, X86-ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date: Wed, 20 Jun 2012 12:08:51 +0200
In-Reply-To: <20120620095616.GB10012@aftab.osrc.amd.com>
References: <1340121811-4477-1-git-send-email-bp@amd64.org>
	 <1340121811-4477-3-git-send-email-bp@amd64.org>
	 <CANDHA0jf2fLOtg1E6CbyNM=omn=kj=YoRJ3VTkNA0AhkS-MLtg@mail.gmail.com>
	 <3E5A0FA7E9CA944F9D5414FEC6C7122007737623@ORSMSX105.amr.corp.intel.com>
	 <20120619232857.GH5996@aftab.osrc.amd.com>
	 <1340182778.21745.75.camel@twins>
	 <20120620095616.GB10012@aftab.osrc.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 11:56 +0200, Borislav Petkov wrote:
>         sprintf(name, "intel-ucode/%02x-%02x-%02x",
>                 c->x86, c->x86_model, c->x86_mask);
> 
> 

but but but, the ucode image actually contains stuff for multiple
things.. so I have to like rename it to match the actual cpu in the
machine?

That seems rather daft..

awk 'BEGIN { FS=":" } /family/ {fam=$2} /model[^ ]/ {mod=$2} /stepping/
{step=$2} END { printf "intel-ucode/%02x-%02x-%02x\n", fam, mod,
step }' /proc/cpuinfo

Will get me the right filename, but surely that's not user-friendly at
all...

So no, that's not an improvement over /dev/microcode

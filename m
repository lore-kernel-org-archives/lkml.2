Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760599Ab2FGNfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 09:35:36 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:41236
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760441Ab2FGNff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 09:35:35 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dKzz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M591R2-01-680-02
X-M-MSG: 
Date: Thu, 7 Jun 2012 15:35:49 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Chen Gong <gong.chen@linux.intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>, <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 0/5] x86: mce: Bugfixes, cleanups and a new CMCI poll
 version
Message-ID: <20120607133549.GH11153@aftab.osrc.amd.com>
References: <20120606214941.104735929@linutronix.de>
 <4FD07D8F.5020303@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FD07D8F.5020303@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 06:08:15PM +0800, Chen Gong wrote:
> But during the CPU online/offline test I found an issue. After *STORM*
> mode is entered, it can't come back from *STORM* mode to normal
> interrupt mode. At least there exists such an issue: when *STORM* is
> entered, in the meanwhile, one CPU is offline during this period,
> which means *cmci_storm_on_cpus* can't decrease to 0 because there is
> one bit stuck on this offlined CPU.

Stupid question: do you even want to allow offlining of CPUs while the
storm is raging? IOW, wouldn't it be better to disallow hotplug when the
storm happens so that all online CPUs, which is all CPUs on the system,
can work out the storm conditions faster so that the system gets back to
normal faster...

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551


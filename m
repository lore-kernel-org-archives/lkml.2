Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684Ab2FDOsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 10:48:39 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:5724 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755184Ab2FDOsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 10:48:37 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -12
X-BigFish: VPS-12(zz936eK1432N98dKzz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M53L4S-01-7TW-02
X-M-MSG: 
Date: Mon, 4 Jun 2012 16:48:50 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>
CC: Borislav Petkov <bp@amd64.org>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH] x86, smp: Fix topology checks on AMD MCM
Message-ID: <20120604144850.GF15433@aftab.osrc.amd.com>
References: <20120529174804.GC8263@alberich.amd.com>
 <1338813717-28112-1-git-send-email-bp@amd64.org>
 <1338813830.28282.44.camel@twins>
 <20120604133722.GB15433@aftab.osrc.amd.com>
 <1338817117.28282.48.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1338817117.28282.48.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 03:38:37PM +0200, Peter Zijlstra wrote:
> On Mon, 2012-06-04 at 15:37 +0200, Borislav Petkov wrote:
> > This is still crap.
> 
> *poof* and the patch is gone.. I'll wait for an update ;-)

Thanks.

So I'm looking more into this and there's another issue IMHO:

processor       : 2
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 9
stepping        : 1
microcode       : 0x10000d9
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 12
core id         : 2
cpu cores       : 2
^^^^^^^^^^^^^^^^^^^

This is cpuinfo_x86.booted_cores and here's how it progresses on this
MCM box (below).

On core 2 it becomes 2 and it doesn't change again. Until the next
physical socket comes (cpu 12) where it starts again from 1.

And, it is normally the number of booted cores on the socket, i.e. 12 in
this case.

Now, before we go babbling about what the right fix is, maybe we should
remove this thing completely - I mean, it looks like no one uses it, it
is only in the /proc/cpuinfo thing. Ingo, hpa?

$ grep -E "(cpu cores|processor)" /proc/cpuinfo
processor       : 0
cpu cores       : 1
processor       : 1
cpu cores       : 2
processor       : 2
cpu cores       : 2
processor       : 3
cpu cores       : 2
processor       : 4
cpu cores       : 2
processor       : 5
cpu cores       : 2
processor       : 6
cpu cores       : 2
processor       : 7
cpu cores       : 2
processor       : 8
cpu cores       : 2
processor       : 9
cpu cores       : 2
processor       : 10
cpu cores       : 2
processor       : 11
cpu cores       : 2
processor       : 12
cpu cores       : 1
processor       : 13
cpu cores       : 2
processor       : 14
cpu cores       : 2
processor       : 15
cpu cores       : 2
processor       : 16
cpu cores       : 2
processor       : 17
cpu cores       : 2
processor       : 18
cpu cores       : 2
processor       : 19
cpu cores       : 2
processor       : 20
cpu cores       : 2
processor       : 21
cpu cores       : 2
processor       : 22
cpu cores       : 2
processor       : 23
cpu cores       : 2


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551


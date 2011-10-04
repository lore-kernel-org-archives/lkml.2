Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632Ab1JDPHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 11:07:54 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:57775
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932302Ab1JDPHw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 11:07:52 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzc89bh98dKzz1202hzz8275bhz32i668h839h93fh)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LSJR96-01-9AV-02
X-M-MSG: 
Date: Tue, 4 Oct 2011 17:05:31 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Don Zickus <dzickus@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "avi@redhat.com" <avi@redhat.com>, "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [V7][PATCH 0/6] x86, nmi: new NMI handling routines
Message-ID: <20111004150531.GH21506@erda.amd.com>
References: <1317409584-23662-1-git-send-email-dzickus@redhat.com>
 <1317657158.20367.30.camel@twins>
 <20111003155655.GG5795@redhat.com>
 <1317657548.20367.33.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1317657548.20367.33.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.10.11 11:59:08, Peter Zijlstra wrote:
> I didn't need that, I build an allnoconfig (which got me a fail with the
> IBS patches), then an allyesconfig (which got me the earlier fail) and
> this came from my regular config which included the ipmi crap because
> Ingo hit this same fail earlier (-v5 or so) and everybody forgot to tell
> you :/

A change like the one below should fix the IBS build breakage (for
perf, x86: Implement IBS initialization).

-Robert


commit b670049b76a233599ebf64aff16cb8735fe6dc70
Author: Robert Richter <robert.richter@amd.com>
Date:   Tue Oct 4 16:51:54 2011 +0200

    perf, x86: Fix allnoconfig build error for ibs
    
     arch/x86/kernel/cpu/perf_event_amd_ibs.c: In function ‘get_eilvt’:
     arch/x86/kernel/cpu/perf_event_amd_ibs.c:90: error: implicit declaration of function ‘setup_APIC_eilvt’
    
    Signed-off-by: Robert Richter <robert.richter@amd.com>

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 1ae5154..cca9e0c 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -9,6 +9,7 @@
 #include <linux/perf_event.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <asm/apic.h>
 
 static u32 ibs_caps;
 


-- 
Advanced Micro Devices, Inc.
Operating System Research Center


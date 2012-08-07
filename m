Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab2HGPb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 11:31:59 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:14370
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014Ab2HGPb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 11:31:57 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1202hzz8275bh8275dhz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M8E5T3-01-0TK-02
X-M-MSG: 
Date: Tue, 7 Aug 2012 17:31:49 +0200
From: Robert Richter <robert.richter@amd.com>
To: <mingo@kernel.org>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <torvalds@linux-foundation.org>,
        <a.p.zijlstra@chello.nl>, <suresh.b.siddha@intel.com>,
        <tglx@linutronix.de>
CC: <linux-tip-commits@vger.kernel.org>,
        "Petkov, Borislav" <borislav.petkov@amd.com>
Subject: Re: [tip:x86/apic] x86/irq: Update irq_cfg domain unless the new
 affinity is a subset of the current domain
Message-ID: <20120807153149.GI3732@erda.amd.com>
References: <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
 <tip-332afa656e76458ee9cf0f0d123016a0658539e4@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <tip-332afa656e76458ee9cf0f0d123016a0658539e4@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.06.12 08:03:58, tip-bot for Suresh Siddha wrote:
> Commit-ID:  332afa656e76458ee9cf0f0d123016a0658539e4
> Gitweb:     http://git.kernel.org/tip/332afa656e76458ee9cf0f0d123016a0658539e4
> Author:     Suresh Siddha <suresh.b.siddha@intel.com>
> AuthorDate: Mon, 21 May 2012 16:58:01 -0700
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 6 Jun 2012 09:51:22 +0200
> 
> x86/irq: Update irq_cfg domain unless the new affinity is a subset of the current domain

This commit causes a sata error and thus a boot failure:

 ACPI: Invalid Power Resource to register!ata1: lost interrupt (Status 0x50)
 ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x40000000 action 0x6 frozen
 ata1: SError: { }
 ata1.00: failed command: READ DMA

Reverting it as following helped:

 $ git revert d872818dbbeed1bccf58c7f8c7db432154c802f9
 $ git revert 1ac322d0b169c95ce34d55b3ed6d40ce1a5f3a02
 $ git revert 332afa656e76458ee9cf0f0d123016a0658539e4

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center


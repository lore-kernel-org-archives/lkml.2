Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab1JJKew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 06:34:52 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:40518
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113Ab1JJKev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 06:34:51 -0400
X-SpamScore: -30
X-BigFish: VPS-30(zz148cM154dM1432N1a09J98dKzz1202hzz15d4R8275dhz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LSUIPX-01-04A-02
X-M-MSG: 
Date: Mon, 10 Oct 2011 12:34:41 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Gleb Natapov <gleb@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "avi@redhat.com" <avi@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH v2 0/9] perf support for x86 guest/host-only bits
Message-ID: <20111010103441.GZ2138@amd.com>
References: <1317816084-18026-1-git-send-email-gleb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1317816084-18026-1-git-send-email-gleb@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gleb,

On Wed, Oct 05, 2011 at 08:01:15AM -0400, Gleb Natapov wrote:
> This patch series consists of Joerg series named "perf support for amd
> guest/host-only bits v2" [1] rebased to 3.1.0-rc7 and in addition,
> support for intel cpus for the same functionality.
> 
> [1] https://lkml.org/lkml/2011/6/17/171
> 
> Changelog:
>  v1->v2
>   - move perf_guest_switch_msr array to perf code.
>   - small cosmetic changes.
> 
> Gleb Natapov (4):
>   perf, intel: Use GO/HO bits in perf-ctr
>   KVM, VMX: add support for switching of PERF_GLOBAL_CTRL
>   KVM, VMX: Add support for guest/host-only profiling
>   KVM, VMX: Check for automatic switch msr table overflow.
> 
> Joerg Roedel (5):
>   perf, core: Introduce attrs to count in either host or guest mode
>   perf, amd: Use GO/HO bits in perf-ctr
>   perf, tools: Add support for guest/host-only profiling
>   perf, tools: Fix copy&paste error in perf-kvm option description
>   perf, tools: Do guest-only counting in perf-kvm by default
> 
>  arch/x86/include/asm/perf_event.h      |   15 ++++
>  arch/x86/kernel/cpu/perf_event.c       |   14 ++++
>  arch/x86/kernel/cpu/perf_event_amd.c   |   13 +++
>  arch/x86/kernel/cpu/perf_event_intel.c |   90 +++++++++++++++++++++-
>  arch/x86/kvm/vmx.c                     |  131 +++++++++++++++++++++++++++++---
>  include/linux/perf_event.h             |    5 +-
>  tools/perf/builtin-kvm.c               |    5 +-
>  tools/perf/util/event.c                |    8 ++
>  tools/perf/util/event.h                |    2 +
>  tools/perf/util/evlist.c               |    5 +-
>  tools/perf/util/parse-events.c         |   15 +++-
>  11 files changed, 282 insertions(+), 21 deletions(-)

Many thanks for picking this up :)

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632


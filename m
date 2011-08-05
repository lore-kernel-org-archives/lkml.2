Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab1HENoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 09:44:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40500 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab1HENn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 09:43:59 -0400
MIME-Version: 1.0
In-Reply-To: <20110804185139.GA11724@jayachandranc.netlogicmicro.com>
References: <CAJd=RBDv1wsdVYmwdtr2BGOCuya1eKg4PeWeggPbz5u_5545ig@mail.gmail.com>
	<CA+7sy7B7-zTr4MojT+7C+AD4+ap4aiiJKX4u+fOPzR52yEJGJA@mail.gmail.com>
	<20110804185139.GA11724@jayachandranc.netlogicmicro.com>
Date: Fri, 5 Aug 2011 21:43:57 +0800
Message-ID: <CAJd=RBC3-9nEwFd+d7RbbKp1aYbQyC9iPnqMvHDDH+kPYbSxcQ@mail.gmail.com>
Subject: Re: [RFC patch] MIPS/netlogic: dont setup boot CPU twice
From: Hillf Danton <dhillf@gmail.com>
To: "Jayachandran C." <jayachandranc@netlogicmicro.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-mips@linux-mips.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 2:51 AM, Jayachandran C.
<jayachandranc@netlogicmicro.com> wrote:
> The nlm_cpu_ready[] entry is not set for the boot_cpu, it is set for only
> the secondary cpus in smpboot.S.  The code works as it is, but your patch
> makes it more explicit.
>
> My only commnet is that it might look better if you combine both the if checks.
>
Got and thanks. It is recooked as the following.

Hillf
------------------------------------------------------------------------------
Subject: [RFC patch] MIPS/netlogic: add comment for smp setup

It seems that BSP could be setup twice, but the nlm_cpu_ready array is only
set for ASPs in smpboot.S, not including BSP.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 arch/mips/netlogic/xlr/smp.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/mips/netlogic/xlr/smp.c b/arch/mips/netlogic/xlr/smp.c
index b495a7f..b82667c 100644
--- a/arch/mips/netlogic/xlr/smp.c
+++ b/arch/mips/netlogic/xlr/smp.c
@@ -167,6 +167,10 @@ void __init nlm_smp_setup(void)

 	num_cpus = 1;
 	for (i = 0; i < NR_CPUS; i++) {
+		/*
+		 * BSP is not set in nlm_cpu_ready array, it is only for
+		 * ASPs (goto see smpboot.S)
+		 */
 		if (nlm_cpu_ready[i]) {
 			cpu_set(i, phys_cpu_present_map);
 			__cpu_number_map[i] = num_cpus;

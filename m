Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437Ab1JYLtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 07:49:43 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:58601 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192Ab1JYLtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 07:49:41 -0400
Message-ID: <4EA6A24D.1000400@scalemp.com>
Date: Tue, 25 Oct 2011 13:49:33 +0200
From: Eial Czerwacki <eial@scalemp.com>
Organization: ScaleMP
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.11) Gecko/20101020 Remi/fc8 Thunderbird/3.1.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Subject: [PATCH] AMD: modify cpu probe from APICID to initial APICID
References: <4EA6695C.1000904@scalemp.com> <9B14D1490DDECA4E974F6B9FC9EBAB3140CD274366@VMBX108.ihostexchange.net> <4EA699B5.4030008@scalemp.com> <9B14D1490DDECA4E974F6B9FC9EBAB3140CD27436C@VMBX108.ihostexchange.net>
In-Reply-To: <9B14D1490DDECA4E974F6B9FC9EBAB3140CD27436C@VMBX108.ihostexchange.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make AMD probe processors using APICID rather than the initial APICID.


Signed-off-by: Eial Czerwacki<eial@scalemp.com>
Signed-off-by: Shai Fultheim<shai@scalemp.com>
---

--- a/arch/x86/kernel/cpu/amd.c	2011-09-14 05:58:19.542910736 -0700
+++ b/arch/x86/kernel/cpu/amd.c	2011-09-14 06:01:41.493209624 -0700
@@ -299,9 +299,9 @@ static void __cpuinit amd_detect_cmp(str

    	bits = c->x86_coreid_bits;
    	/* Low order bits define the core id (index of core in socket) */
-	c->cpu_core_id = c->initial_apicid&    ((1<<    bits)-1);
+	c->cpu_core_id = c->apicid&    ((1<<    bits)-1);
    	/* Convert the initial APIC ID into the socket ID */
-	c->phys_proc_id = c->initial_apicid>>    bits;
+	c->phys_proc_id = c->apicid>>    bits;
    	/* use socket ID also for last level cache */
    	per_cpu(cpu_llc_id, cpu) = c->phys_proc_id;
    	/* fixup topology information on multi-node processors */





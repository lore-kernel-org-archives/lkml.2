Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab0IKHJe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 03:09:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51158 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab0IKHJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 03:09:33 -0400
Message-ID: <4C8B2AFA.2000705@kernel.org>
Date: Sat, 11 Sep 2010 00:08:42 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] powerpc, memblock: fix will memblock reference
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>	 <1281071724-28740-9-git-send-email-benh@kernel.crashing.org>	 <4C5BCD41.3040501@monstr.eu> <1281135046.2168.40.camel@pasglop>	 <4C88BD8F.5080208@monstr.eu>  <20100909115445.GB16157@elte.hu> <1284106711.6515.46.camel@pasglop> <4C8B2A9A.1040303@kernel.org>
In-Reply-To: <4C8B2A9A.1040303@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


for wii?

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Index: linux-2.6/arch/powerpc/platforms/embedded6xx/wii.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/embedded6xx/wii.c
+++ linux-2.6/arch/powerpc/platforms/embedded6xx/wii.c
@@ -65,7 +65,7 @@ static int __init page_aligned(unsigned
 
 void __init wii_memory_fixups(void)
 {
-	struct memblock_region *p = memblock.memory.region;
+	struct memblock_region *p = memblock.memory.regions;
 
 	/*
 	 * This is part of a workaround to allow the use of two

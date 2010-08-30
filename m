Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab0H3BOj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 21:14:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17387 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab0H3BOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 21:14:38 -0400
Message-ID: <4C7B0578.8090807@kernel.org>
Date: Sun, 29 Aug 2010 18:12:24 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
CC: Torsten Kaiser <just.for.lkml@googlemail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86, setup: fix earlyprintk=serial,ttyS0,115200
References: <AANLkTinRRiW1VUzS+3T82=q8PsoRn78Cgn_X8gSduM0U@mail.gmail.com> <AANLkTi=652CHVZz8TAqCOiOLO2XyUHd6_i3vWNgbVzKA@mail.gmail.com>
In-Reply-To: <AANLkTi=652CHVZz8TAqCOiOLO2XyUHd6_i3vWNgbVzKA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Torsten reported that there is garbage output,
after commit 8fee13a48e4879fba57725f6d9513df4bfa8e9f3 (x86,
setup: enable early console output from the decompressor)

it turns out we missed the offset for that case.

Reported-by: Torsten Kaiser <just.for.lkml@googlemail.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Index: linux-2.6/arch/x86/boot/early_serial_console.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/early_serial_console.c
+++ linux-2.6/arch/x86/boot/early_serial_console.c
@@ -58,7 +58,7 @@ static void parse_earlyprintk(void)
 		if (arg[pos] == ',')
 			pos++;
 
-		if (!strncmp(arg, "ttyS", 4)) {
+		if (!strncmp(arg + pos, "ttyS", 4)) {
 			static const int bases[] = { 0x3f8, 0x2f8 };
 			int idx = 0;
 


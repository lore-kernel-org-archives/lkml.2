Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab0KWWsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 17:48:38 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34270 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab0KWWsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 17:48:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=Vn5MbHBmioLYAZjt8r3XEXrKQRr+xsugBmKZeAy/RVX/YeZLZBY3vmne7jYjxhD3dI
         COteaFAogePGAGRn/BmqM32SZfhdaEEkbKQydRyTIWnjklVHlnZVu0oTpFbwgygBtbio
         5xBioXP0MVWksgte7ItU0nLiIxMCH2UH0bNP0=
Message-Id: <20101123224800.658686382@openvz.org>
User-Agent: quilt/0.47-1
Date: Wed, 24 Nov 2010 01:46:04 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: ming.m.lin@intel.com, eranian@google.com, peterz@infradead.org,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [rfc 3/3] perf, x86: P4 PMU -- export ABI part of event config to userspace
References: <20101123224601.766827604@openvz.org>
Content-Disposition: inline; filename=x86-perf-export-abi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to tight 64 bit size of event config field (where we have to track
pretty lot of info during event lifetime) some bits are to be exported
via header into userspace.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>
---

Note that I don't like much the idea to export anything into userspace
but it seems there is no other choise. So there is a minimum which should
be exported.

 arch/x86/include/asm/Kbuild          |    1 +
 arch/x86/include/asm/perf_event_p4.h |    8 ++++++++
 2 files changed, 9 insertions(+)

Index: linux-2.6.git/arch/x86/include/asm/Kbuild
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/Kbuild
+++ linux-2.6.git/arch/x86/include/asm/Kbuild
@@ -23,3 +23,4 @@ header-y += unistd_32.h
 header-y += unistd_64.h
 header-y += vm86.h
 header-y += vsyscall.h
+header-y += perf_event_p4.h
Index: linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/perf_event_p4.h
+++ linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
@@ -5,6 +5,8 @@
 #ifndef PERF_EVENT_P4_H
 #define PERF_EVENT_P4_H
 
+#ifdef __KERNEL__
+
 #include <linux/cpu.h>
 #include <linux/bitops.h>
 
@@ -201,6 +203,8 @@ static inline u32 p4_default_escr_conf(i
 	return escr;
 }
 
+#endif /* __KERNEL__ */
+
 /*
  * This are the events which should be used in "Event Select"
  * field of ESCR register, they are like unique keys which allow
@@ -256,6 +260,8 @@ enum P4_EVENTS {
 	P4_EVENT_INSTR_COMPLETED,
 };
 
+#ifdef __KERNEL__
+
 #define P4_OPCODE(event)		event##_OPCODE
 #define P4_OPCODE_ESEL(opcode)		((opcode & 0x00ff) >> 0)
 #define P4_OPCODE_EVNT(opcode)		((opcode & 0xff00) >> 8)
@@ -767,6 +773,8 @@ enum P4_ESCR_EMASKS {
 
 #define p4_config_pebs_has(v, mask)	(p4_config_unpack_pebs(v) & (mask))
 
+#endif /* __KERNEL__ */
+
 enum P4_PEBS_METRIC {
 	P4_PEBS_METRIC__none,
 


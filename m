Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828Ab0FJLKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:10:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39147 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab0FJLKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:10:41 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
In-Reply-To: <20100610110.764742110@firstfloor.org>
To: tj@kernel.org, x86@kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [1/23] x86: percpu: Avoid warnings of unused variables in per cpu
Message-Id: <20100610111036.DAE8EB1A2C@basil.firstfloor.org>
Date: Thu, 10 Jun 2010 13:10:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Avoid hundreds of warnings with a gcc 4.6 -Wall build

Cc: tj@kernel.org
Cc: x86@kernel.org

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/percpu.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.35-rc2-gcc/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.35-rc2-gcc.orig/arch/x86/include/asm/percpu.h
+++ linux-2.6.35-rc2-gcc/arch/x86/include/asm/percpu.h
@@ -77,6 +77,7 @@ do {							\
 	if (0) {					\
 		pto_T__ pto_tmp__;			\
 		pto_tmp__ = (val);			\
+		(void)pto_tmp__;			\
 	}						\
 	switch (sizeof(var)) {				\
 	case 1:						\
@@ -115,6 +116,7 @@ do {									\
 	if (0) {							\
 		pao_T__ pao_tmp__;					\
 		pao_tmp__ = (val);					\
+		(void)pao_tmp__;					\
 	}								\
 	switch (sizeof(var)) {						\
 	case 1:								\

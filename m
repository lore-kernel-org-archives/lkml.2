Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab1BYRnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 12:43:09 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:43444 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753076Ab1BYRl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 12:41:56 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: D1jXf48VM1meyMHp_9a.VPDc6Lopob_IVoTRKVvbJ3rqsCS
 VdSzvasUpTz0YjF.FLvlezfN5Gz5sjso37CEXx.7sAUnHSyovCYJv_u3COC8
 Z9C9JA3fO_ZcdM9fHfh6QhLCjujZhuN.Js8GKp2QQhJnhIadtM4JQ6Ss4Uop
 7d4smPp9N_qeFbvhZLBOc6jIw5rOPXNooFqfDQDuRy6GY0uCx_9EotkGD7or
 x8ZnQX0lEQySa7WvIEd82UW3T34At7LraRwZQrodM2A5auokEgSXw
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110225174154.641323942@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 25 Feb 2011 11:38:51 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops cmpxchg double V3 1/5] slub: min_partial needs to be in first cacheline
References: <20110225173850.486326452@linux.com>
Content-Disposition: inline; filename=slub_min_partial_first_cacheline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is used in unfreeze_slab() which is a performance critical
function.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 include/linux/slub_def.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2011-01-28 11:57:29.000000000 -0600
+++ linux-2.6/include/linux/slub_def.h	2011-01-28 11:57:52.000000000 -0600
@@ -70,6 +70,7 @@ struct kmem_cache {
 	struct kmem_cache_cpu __percpu *cpu_slab;
 	/* Used for retriving partial slabs etc */
 	unsigned long flags;
+	unsigned long min_partial;
 	int size;		/* The size of an object including meta data */
 	int objsize;		/* The size of an object without meta data */
 	int offset;		/* Free pointer offset. */
@@ -83,7 +84,6 @@ struct kmem_cache {
 	void (*ctor)(void *);
 	int inuse;		/* Offset to metadata */
 	int align;		/* Alignment */
-	unsigned long min_partial;
 	const char *name;	/* Name (only for display!) */
 	struct list_head list;	/* List of slab caches */
 #ifdef CONFIG_SYSFS


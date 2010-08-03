Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab0HCSQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:16:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757140Ab0HCSQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:16:48 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH] kernel: rounddown helper function
To: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Cc: akpm@linux-foundation.org, sds@tycho.nsa.gov, jmorris@namei.org
Date: Tue, 03 Aug 2010 14:16:07 -0400
Message-ID: <20100803181607.30614.36916.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The roundup() helper function will round a given value up to a multiple of
another given value.  aka  roundup(11, 7) would give 14 = 7 * 2.  This new
function does the opposite.  It will round a given number down to the
nearest multiple of the second number: rounddown(11, 7) would give 7.

I need this in some future SELinux code and can carry the macro myself, but
figured I would put it in the core kernel so others might find and use it
if need be.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/kernel.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 7d5b10f..d6092fd 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -59,6 +59,7 @@ extern const char linux_proc_banner[];
 #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
 #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
+#define rounddown(x, y) ((x) - ((x) % (y)))
 #define DIV_ROUND_CLOSEST(x, divisor)(			\
 {							\
 	typeof(divisor) __divisor = divisor;		\


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab2EBOlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 10:41:31 -0400
Received: from 207-126-122-235.ip.openhosting.com ([207.126.122.235]:42032
	"EHLO drepperk.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328Ab2EBOla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 10:41:30 -0400
Date: Wed, 2 May 2012 10:41:01 -0400
From: Ulrich Drepper <drepper@akkadia.org>
Message-Id: <201205021441.q42Ef1ap026902@drepperk.user.openhosting.com>
To: akpm@linux-foundation.org, dyoung@redhat.com, fengguang.wu@intel.com,
        kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        n-horiguchi@ah.jp.nec.com
Subject: [PATCH] Cleanup page-type.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling page-type.c with a recent compiler produces many warnings,
mostly related to signed/unsigned comparisons.  This patch cleans up
most of them.

One remaining warning is about an unused parameter.  The <compiler.h>
file doesn't define a __unused macro (or the like) yet.  This can be
addressed later.

The line numbers for this patch correspond to the file changed to remove
the duplicate definitions of the KPF_* macros which is contained in
another patch.  It should apply cleanly albeit with warnings even without
that patch applied first.


Signed-off-by: Ulrich Drepper <drepper@gmail.com>

 page-types.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -u b/tools/vm/page-types.c b/tools/vm/page-types.c
--- b/tools/vm/page-types.c
+++ b/tools/vm/page-types.c
@@ -300,7 +300,7 @@
 {
 	static char buf[65];
 	int present;
-	int i, j;
+	size_t i, j;
 
 	for (i = 0, j = 0; i < ARRAY_SIZE(page_flag_names); i++) {
 		present = (flags >> i) & 1;
@@ -318,7 +318,7 @@
 static char *page_flag_longname(uint64_t flags)
 {
 	static char buf[1024];
-	int i, n;
+	size_t i, n;
 
 	for (i = 0, n = 0; i < ARRAY_SIZE(page_flag_names); i++) {
 		if (!page_flag_names[i])
@@ -376,7 +376,7 @@
 
 static void show_summary(void)
 {
-	int i;
+	size_t i;
 
 	printf("             flags\tpage-count       MB"
 		"  symbolic-flags\t\t\tlong-symbolic-flags\n");
@@ -474,7 +474,7 @@
 /* find the path to the mounted debugfs */
 static const char *debugfs_find_mountpoint(void)
 {
-	const char **ptr;
+	const char *const *ptr;
 	char type[100];
 	FILE *fp;
 
@@ -511,7 +511,7 @@
 
 static void debugfs_mount(void)
 {
-	const char **ptr;
+	const char *const *ptr;
 
 	/* see if it's already mounted */
 	if (debugfs_find_mountpoint())
@@ -588,10 +588,10 @@
  * page frame walker
  */
 
-static int hash_slot(uint64_t flags)
+static size_t hash_slot(uint64_t flags)
 {
-	int k = HASH_KEY(flags);
-	int i;
+	size_t k = HASH_KEY(flags);
+	size_t i;
 
 	/* Explicitly reserve slot 0 for flags 0: the following logic
 	 * cannot distinguish an unoccupied slot from slot (flags==0).
@@ -644,7 +644,7 @@
 {
 	uint64_t buf[KPAGEFLAGS_BATCH];
 	unsigned long batch;
-	long pages;
+	unsigned long pages;
 	unsigned long i;
 
 	while (count) {
@@ -753,7 +753,7 @@
 
 static void usage(void)
 {
-	int i, j;
+	size_t i, j;
 
 	printf(
 "page-types [options]\n"
@@ -912,7 +912,7 @@
 
 static uint64_t parse_flag_name(const char *str, int len)
 {
-	int i;
+	size_t i;
 
 	if (!*str || !len)
 		return 0;

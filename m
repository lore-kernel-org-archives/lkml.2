Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab1IWWmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:42:35 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:43637 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab1IWWme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:42:34 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-209.messagelabs.com!1316817753!12266347!2
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] fscache/main.c: local variables should be static
Date: Fri, 23 Sep 2011 15:42:21 -0700
User-Agent: KMail/1.9.9
CC: <linux-cachefs@redhat.com>, <dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109231542.22079.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quiets the sparse noise:

warning: symbol 'fscache_sysctls' was not declared. Should it be static?
warning: symbol 'fscache_sysctls_root' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Howells <dhowells@redhat.com>

---

diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index f9d8567..59599c5 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -67,7 +67,7 @@ static int fscache_max_active_sysctl(struct ctl_table *table, int write,
 	return ret;
 }
 
-ctl_table fscache_sysctls[] = {
+static ctl_table fscache_sysctls[] = {
 	{
 		.procname	= "object_max_active",
 		.data		= &fscache_object_max_active,
@@ -87,7 +87,7 @@ ctl_table fscache_sysctls[] = {
 	{}
 };
 
-ctl_table fscache_sysctls_root[] = {
+static ctl_table fscache_sysctls_root[] = {
 	{
 		.procname	= "fscache",
 		.mode		= 0555,

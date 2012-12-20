Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab2LTTNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:13:42 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48517 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab2LTTNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:13:18 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Paton J. Lewis" <palewis@adobe.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Daniel Hazelton <dshadowwolf@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] epoll: stop comparing pointers with 0 in self-test app
Date: Thu, 20 Dec 2012 14:11:14 -0500
Message-Id: <1356030701-16284-6-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/testing/selftests/epoll/test_epoll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/epoll/test_epoll.c b/tools/testing/selftests/epoll/test_epoll.c
index 4a14a7f..1034ed4 100644
--- a/tools/testing/selftests/epoll/test_epoll.c
+++ b/tools/testing/selftests/epoll/test_epoll.c
@@ -199,8 +199,8 @@ int main(int argc, char **argv)
 
 	epoll_items = malloc(n_epoll_items * sizeof(struct epoll_item_private));
 
-	if (epoll_set < 0 || epoll_items == 0 || write_thread_data.fds == 0 ||
-		read_thread_data == 0 || read_threads == 0)
+	if (epoll_set < 0 || !epoll_items || write_thread_data.fds == NULL ||
+		!read_thread_data || !read_threads)
 		goto error;
 
 	if (sysconf(_SC_NPROCESSORS_ONLN) < 2) {
-- 
1.8.0


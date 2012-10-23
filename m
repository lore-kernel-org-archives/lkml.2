Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab2JWP0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 11:26:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53484 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063Ab2JWP0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 11:26:06 -0400
MIME-Version: 1.0
Date: Tue, 23 Oct 2012 11:26:05 -0400
Message-ID: <CAPisED220rs7Sd035xeQ_ox5=Xvnfc7iokarNDry5VH1RU-gvw@mail.gmail.com>
Subject: [PATCH] Fix tools/testing/selftests/epoll/test_epoll.c
From: Daniel Hazelton <dshadowwolf@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        "Paton J. Lewis" <palewis@adobe.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 13b8bbd560614ec76ac958b9ae97b3401830d9f9 Mon Sep 17 00:00:00 2001
From: Daniel Hazelton <dshadowwolf@gmail.com>
Date: Tue, 23 Oct 2012 11:07:47 -0400
Subject: [PATCH] tools/testing/selftests/epoll/test_epoll.c: reference to
 undefined variable fix

Latest Linus head run of "make selftests" in the tools directory
failed with references to undefined variables. Reference was to
'write_thread_data' which is the name of a struct that is being used,
not the variable itself. Change reference so it points to the
variable.

Signed-off-by: Daniel Hazelton <dshadowwolf@gmail.com>
---
 tools/testing/selftests/epoll/test_epoll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/epoll/test_epoll.c
b/tools/testing/selftests/epoll/test_epoll.c
index e0fcff1..f752539 100644
--- a/tools/testing/selftests/epoll/test_epoll.c
+++ b/tools/testing/selftests/epoll/test_epoll.c
@@ -162,14 +162,14 @@ void *write_thread_function(void *function_data)
        int index;
        struct write_thread_data *thread_data =
                (struct write_thread_data *)function_data;
-       while (!write_thread_data->stop)
+       while (!thread_data->stop)
                for (index = 0;
                     !thread_data->stop && (index < thread_data->n_fds);
                     ++index)
                        if ((write(thread_data->fds[index], &data, 1) < 1) &&
                                (errno != EAGAIN) &&
                                (errno != EWOULDBLOCK)) {
-                               write_thread_data->status = errno;
+                               thread_data->status = errno;
                                return;
                        }
 }
-- 
1.7.12.1

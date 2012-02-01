Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab2BADip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 22:38:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60762 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab2BADil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 22:38:41 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paul Menage <paul@paulmenage.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Tim Hockin <thockin@hockin.org>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@gmail.com>, Cgroups <cgroups@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Max Kellermann <mk@cm4all.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: [PATCH 09/10] selftests: Enter each directories before executing selftests
Date: Wed,  1 Feb 2012 04:37:49 +0100
Message-Id: <1328067470-5980-10-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1328067470-5980-1-git-send-email-fweisbec@gmail.com>
References: <1328067470-5980-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way the selftests can launch local programs from their
directory without trying to guess their absolute path.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Containers <containers@lists.linux-foundation.org>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Cgroups <cgroups@vger.kernel.org>
Cc: Daniel J Walsh <dwalsh@redhat.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Max Kellermann <mk@cm4all.com>
Cc: Mandeep Singh Baines <msb@chromium.org>
---
 tools/testing/selftests/run_tests |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/testing/selftests/run_tests b/tools/testing/selftests/run_tests
index 320718a..19043d3 100644
--- a/tools/testing/selftests/run_tests
+++ b/tools/testing/selftests/run_tests
@@ -4,5 +4,7 @@ TARGETS=breakpoints
 
 for TARGET in $TARGETS
 do
-	$TARGET/run_test
+	cd $TARGET
+	./run_test
+	cd ..
 done
-- 
1.7.5.4


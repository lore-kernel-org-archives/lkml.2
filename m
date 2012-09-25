Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab2IYXc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:32:29 -0400
Received: from nm30-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.238]:27781 "HELO
	nm30-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755049Ab2IYXc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:32:27 -0400
X-Yahoo-Newman-Id: 439387.51269.bm@omp1015.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: WcJESvYVM1n2FfRlZDKCecP44craV7Yp4zA5RpsJLirp5PV
 OmiMpZCyW_vyW3x.X7UND7cGZ3Awb1T8lE0BzGjJdmFi2XvYKrwVRuZTuwPO
 0hXCQXFlO2W1HaYDe2V0XX8Kuby_ZyjRHmge2PYIN5ENsDxP7w9Qc6XQfauF
 4k_rEeNvdK2TFZjXQw1CdLR4vL29sdjjxD1nr1v8MnBGf9w7YHWVGNpBQksa
 7aWxgez4dA4xmzd5sICPIi2LEt1DS9dfB5dtAoxQbOE9HVTNyj1cysU8dHI6
 q1qU9mqFZ5JgGxiwDTNw7dpAuk76rvIq8pjgw5.Tu4Hs14j7hM09WIxX.FJ6
 9zvAYp83XpnfWd3AdzlJQ1HpBvBEYXot5q2QOYEQ4u7ddeF.QGP2T2Z4xORM
 .mEEzJMmyh68SxNaaf19uRAG8cYw1g02PqViNz6s0VlejT0wqcZY8uUQ72VI
 x6vlzBFk3WPRv_iMen6tSsYOliPRlmhzm13bc3_TcsiTIWXyndmWHhFUvfc9
 ELCScuj9G6PJUI_1GWRgnNbyGsw--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Daniel Santos <daniel.santos@pobox.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        LKML <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH v5 23/25] selftest: Add basic compiler iterator test script
Date: Tue, 25 Sep 2012 18:32:19 -0500
Message-Id: <1348615939-10722-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A Gentoo-specific script (to be run by root) to iterate through all
installed compilers, execte runtest.sh script and collect the output
data.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 tools/testing/selftests/grbtree/user/runtests.sh |   30 ++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)
 create mode 100755 tools/testing/selftests/grbtree/user/runtests.sh

diff --git a/tools/testing/selftests/grbtree/user/runtests.sh b/tools/testing/selftests/grbtree/user/runtests.sh
new file mode 100755
index 0000000..0192c10
--- /dev/null
+++ b/tools/testing/selftests/grbtree/user/runtests.sh
@@ -0,0 +1,30 @@
+#!/bin/bash
+
+# This script is designed for use on Gentoo systems, using gcc-config to
+# change the compiler and must be run as root. I'm lazy, so alter to fit your
+# system.
+
+user=daniel
+outfile=runtests.$$.out
+
+rm -f runtest.log runtest.out
+
+if [[ -e ${outfile} ]]; then
+	echo "File ${outfile} exists, please move it out of the way."
+	exit
+fi
+
+
+for ((gcc_inst_num = 1; gcc_inst_num < 10; ++gcc_inst_num)); do
+	gcc-config $gcc_inst_num || exit
+	. /etc/profile
+	nice -n -3 sudo -Hu ${user}	\
+		key_type=u32		\
+		use_leftmost=1		\
+		use_rightmost=1		\
+		use_count=1		\
+		unique_keys=1		\
+		insert_replaces=0	\
+		./runtest.sh >> ${outfile}
+
+done
-- 
1.7.3.4


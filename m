Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab2HaKzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 06:55:39 -0400
Received: from mail-gw3.nixu.fi ([193.209.237.7]:53546 "EHLO mail-gw3.nixu.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab2HaKzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 06:55:38 -0400
X-Greylist: delayed 1701 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Aug 2012 06:55:37 EDT
From: Pasi Savanainen <pasi.savanainen@nixu.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tracing: fix warning about usage of unitialized variable 'ret'
Date: Fri, 31 Aug 2012 13:27:04 +0300
Message-Id: <1346408824-19713-1-git-send-email-pasi.savanainen@nixu.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="us-ascii:utf-8"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-08-31_03:2012-08-31,2012-08-31,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1203120001 definitions=main-1208310056
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/trace/trace_events_filter.c: In function ‘ftrace_function_set_filter_cb’:
kernel/trace/trace_events_filter.c:2074:8: warning: ‘ret’ may be used
uninitialized in this function [-Wuninitialized]

Signed-off-by: Pasi Savanainen <pasi.savanainen@nixu.com>
---
 kernel/trace/trace_events_filter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 431dba8..c154797 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -2002,7 +2002,7 @@ static int ftrace_function_set_regexp(struct ftrace_ops *ops, int filter,
 static int __ftrace_function_set_filter(int filter, char *buf, int len,
 					struct function_filter_data *data)
 {
-	int i, re_cnt, ret;
+	int i, re_cnt, ret = -EINVAL;
 	int *reset;
 	char **re;
 
-- 
1.7.9.5


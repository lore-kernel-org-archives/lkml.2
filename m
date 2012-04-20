Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab2DTGch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 02:32:37 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:23065 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab2DTGcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 02:32:36 -0400
Date: Fri, 20 Apr 2012 09:31:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] tracing: Remove an unneeded check
Message-ID: <20120420063145.GA22649@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F9102DB.0028,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memcpy() returns a pointer to "bug".  Hopefully, it's not NULL here or
we would already have Oopsed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ed7b5d1..c2d5b71 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -629,7 +629,6 @@ ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
 static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 {
 	int len;
-	void *ret;
 
 	if (s->len <= s->readpos)
 		return -EBUSY;
@@ -637,9 +636,7 @@ static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 	len = s->len - s->readpos;
 	if (cnt > len)
 		cnt = len;
-	ret = memcpy(buf, s->buffer + s->readpos, cnt);
-	if (!ret)
-		return -EFAULT;
+	memcpy(buf, s->buffer + s->readpos, cnt);
 
 	s->readpos += cnt;
 	return cnt;

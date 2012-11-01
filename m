Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab2KAGok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 02:44:40 -0400
Received: from intranet.asianux.com ([58.214.24.6]:9806 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2KAGoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 02:44:39 -0400
X-Spam-Score: -100.8
Message-ID: <50921A92.8000809@asianux.com>
Date: Thu, 01 Nov 2012 14:45:38 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion] net-ipv6: format %8s change to %16s in rt6_info_route
 function of route.c
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello:

1) For Public Kernel:

   A) in rt6_info_route function of net/ipv6/route.c

   B) the length of rt->rt6i_dev->name is 16 (IFNAMSIZ)

   C) using %16s is better than %8s (it will be more "beautiful")
      (also suggest to delete RT6_INFO_LEN, it is useless for ever)



2) For Red Hat RHEL5:

   A) in rt6_info_route function of net/ipv6/route.c

   B) the length of rt->rt6i_dev->name is 16 (IFNAMSIZ)

   C) for RT6_INFO_LEN is still useful, so it is an correctness issue.

   the relative patch for RHEL5 is below:

-------------------------------------------------------------------------
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 08ab51f..3c90b4c 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2285,7 +2285,7 @@ void inet6_rt_notify(int event, struct rt6_info
*rt, struct nlmsghdr *nlh,

 #ifdef CONFIG_PROC_FS

-#define RT6_INFO_LEN (32 + 4 + 32 + 4 + 32 + 40 + 5 + 1)
+#define RT6_INFO_LEN (32 + 4 + 32 + 4 + 32 + 48 + 5 + 1)

 struct rt6_proc_arg
 {
@@ -2343,7 +2343,7 @@ static int rt6_info_route(struct rt6_info *rt,
void *p_arg)
                arg->len += 32;
        }
        arg->len += sprintf(arg->buffer + arg->len,
-                           " %08x %08x %08x %08x %8s\n",
+                           " %08x %08x %08x %08x %16s\n",
                            rt->rt6i_metric,
atomic_read(&rt->u.dst.__refcnt),
                            rt->u.dst.__use, rt->rt6i_flags,
                            rt->rt6i_dev ? rt->rt6i_dev->name : "");

----------------------------------------------------------------------------

-- 
Chen Gang

Asianux Corporation

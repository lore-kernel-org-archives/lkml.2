Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab1LUMiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:38:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34360 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab1LUMiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:38:12 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=dp0XQp1NFBAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=9dj_qauvMa2efV0j_VQA:9 a=wcStrSEQRm7LDRRDVq0A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=typld3BQlpKfBRfWlFYA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111221123810.856379915@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 07:36:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 14/16] ftrace: Allow access to the boot time function enabling
References: <20111221123624.193898256@goodmis.org>
Content-Disposition: inline; filename=0014-ftrace-Allow-access-to-the-boot-time-function-enabli.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Change set_ftrace_early_filter() to ftrace_set_early_filter()
and make it a global function. This will allow other subsystems
in the kernel to be able to enable function tracing at start
up and reuse the ftrace function parsing code.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    3 +++
 kernel/trace/ftrace.c  |    8 ++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index d1ff0de..41df6f5 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -235,6 +235,9 @@ ssize_t ftrace_notrace_write(struct file *file, const c=
har __user *ubuf,
 loff_t ftrace_regex_lseek(struct file *file, loff_t offset, int origin);
 int ftrace_regex_release(struct inode *inode, struct file *file);
=20
+void __init
+ftrace_set_early_filter(struct ftrace_ops *ops, char *buf, int enable);
+
 /* defined in arch */
 extern int ftrace_ip_converted(unsigned long ip);
 extern int ftrace_dyn_arch_init(void *data);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5728d9a..683d559 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3279,8 +3279,8 @@ static void __init set_ftrace_early_graph(char *buf)
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
=20
-static void __init
-set_ftrace_early_filter(struct ftrace_ops *ops, char *buf, int enable)
+void __init
+ftrace_set_early_filter(struct ftrace_ops *ops, char *buf, int enable)
 {
 	char *func;
=20
@@ -3293,9 +3293,9 @@ set_ftrace_early_filter(struct ftrace_ops *ops, char =
*buf, int enable)
 static void __init set_ftrace_early_filters(void)
 {
 	if (ftrace_filter_buf[0])
-		set_ftrace_early_filter(&global_ops, ftrace_filter_buf, 1);
+		ftrace_set_early_filter(&global_ops, ftrace_filter_buf, 1);
 	if (ftrace_notrace_buf[0])
-		set_ftrace_early_filter(&global_ops, ftrace_notrace_buf, 0);
+		ftrace_set_early_filter(&global_ops, ftrace_notrace_buf, 0);
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	if (ftrace_graph_buf[0])
 		set_ftrace_early_graph(ftrace_graph_buf);
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO8dMzAAoJEIy3vGnGbaoAmF0P/0wgbSdbqKClzOpl9qVCJblV
dWOj4On68gxQ05+9HChThRl4ZzLs/1auCaEEEmXCQ9jDCcJnHYQSkySD8tl5+udC
gX1zIIPwy0Ef4y+avreweHUJ87iBzHu59cXCg32Jv4a7s4mI1isAMaQNEODmIroU
RiZXCKVgSP1suwbG2ZVGyqWhPaZl1Zmw4/xSTtRGwk36OG7hnXNiLyNrhIskbvbo
lrOS0+Vp75FsoXJ7WjjjSDVBA1aKyXwS6iWmuqy5USlXEdabb0P8wY89vSqYNlT+
oPH8hsU6bElZp3vRJla+ZL6sFSXJsusxa/iqoP2C7NRhuS0XcJrYnOTb6fGQkx9f
xZvexrbtf/rLsfkHcDBjo8iUGnQqPeoTyjE3lau5jbDNWI7FcIfHraT/1E+l3b6M
7BTN05YQ6h/U/q6nHzBFHws9I+AqEcGNihpwLQ1Bijm93W8IcWdzPcHpy6mWirCs
0ubk9f6AIBXs6PU/ksHp8l7b3P8onbNWa3Xiz/WS8wCcaETvdD0WK27Q8d3/WBN0
WcOOxbmgU0YWkuc98By6n7fJtNAitJIywMq1HZSLQwfGx8BBG1N2dQQW6K1Obb6T
Auxrs5D38zyjoYVn8+80XRyl8PGpwNdsDyAvhhEdDaxbaH+sAjnjJ312ikHZJhC5
eGqPeAHNxZedL2N7Pzmb
=wOtu
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--

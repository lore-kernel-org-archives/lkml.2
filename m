Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab0HPSie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 14:38:34 -0400
Received: from p01c12o141.mxlogic.net ([208.65.145.64]:45358 "EHLO
	p01c12o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab0HPSid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 14:38:33 -0400
X-MXL-Hash: 4c6985a874655216-4846f9ed5d423fd0cba326abd6184a2887305c0c
X-MXL-Hash: 4c6985a23abae604-747a35181329c215b83f0d2f7094588189cb8f8c
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs.h: introduce functions to get/set file->private_data
Date: Mon, 16 Aug 2010 11:37:52 -0700
User-Agent: KMail/1.9.9
CC: <linux-fsdevel@vger.kernel.org>, <matthew@wil.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201008161137.53187.hartleys@visionengravers.com>
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010073001)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.180]
X-AnalysisOut: [v=1.0 c=1 a=vVn_PSYZg3oA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=38uLcFpo6nJaFUi5eYvXHw==:17 a=i00gxMtYAAAA:8 a=BBy]
X-AnalysisOut: [A_YjSXBVu0sF_7bQA:9 a=VRHvRSNVulQCE1JrK5MA:7 a=czUEwY0IYS-]
X-AnalysisOut: [2UD0wi2ffIaGYEy4A:4 a=QEXdDO2ut3YA:10 a=x1WnkoZAwusA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol 'private_data' is commonly used and makes grep'ing for
specific uses difficult. Introduce the wrapper functions file_get_privdata
and file_set_privdata to help with the struct file uses.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Matthew Wilcox <matthew@wil.cx>

---

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9a96b4d..b357a17 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -961,6 +961,16 @@ extern spinlock_t files_lock;
 #define fput_atomic(x)	atomic_long_add_unless(&(x)->f_count, -1, 1)
 #define file_count(x)	atomic_long_read(&(x)->f_count)
 
+static inline void *file_get_privdata(struct file *file)
+{
+	return file->private_data;
+}
+
+static inline void file_set_privdata(struct file *file, void *data)
+{
+	file->private_data = data;
+}
+
 #ifdef CONFIG_DEBUG_WRITECOUNT
 static inline void file_take_write(struct file *f)
 {

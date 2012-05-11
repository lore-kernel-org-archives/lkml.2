Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab2EKXf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 19:35:56 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:33356 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754984Ab2EKXfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 19:35:54 -0400
Message-ID: <4FADA267.1020608@xenotime.net>
Date: Fri, 11 May 2012 16:36:07 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH -next] printk: add stub for prepend_timestamp()
References: <20120511162738.1d65b6efe099a54841be6313@canb.auug.org.au> <4FAD9E94.7020109@xenotime.net>
In-Reply-To: <4FAD9E94.7020109@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Add a stub for prepend_timestamp() when CONFIG_PRINTK is not
enabled.  Fixes this build error:

kernel/printk.c:1770:3: error: implicit declaration of function 'prepend_timestamp'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 kernel/printk.c |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-next-20120511.orig/kernel/printk.c
+++ linux-next-20120511/kernel/printk.c
@@ -1439,6 +1439,10 @@ static struct log *log_from_idx(u32 idx)
 static u32 log_next(u32 idx) { return 0; }
 static char *log_text(const struct log *msg) { return NULL; }
 static void call_console_drivers(int level, const char *text, size_t len) {}
+static size_t prepend_timestamp(unsigned long long t, char *buf)
+{
+	return 0;
+}
 
 #endif /* CONFIG_PRINTK */
 

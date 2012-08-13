Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab2HMWIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:08:39 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57384 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab2HMWFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:05:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shuah Khan <shuahkhan@gmail.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [ 35/44] x86, microcode: microcode_core.c simple_strtoul cleanup
Date: Mon, 13 Aug 2012 15:02:42 -0700
Message-Id: <20120813220145.242168568@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813220142.113186818@linuxfoundation.org>
References: <20120813220142.113186818@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuah Khan <shuahkhan@gmail.com>

commit e826abd523913f63eb03b59746ffb16153c53dc4 upstream.

Change reload_for_cpu() in kernel/microcode_core.c to call kstrtoul()
instead of calling obsoleted simple_strtoul().

Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
Reviewed-by: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1336324264.2897.9.camel@lorien2
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/microcode_core.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -298,12 +298,11 @@ static ssize_t reload_store(struct sys_d
 {
 	unsigned long val;
 	int cpu = dev->id;
-	int ret = 0;
-	char *end;
+	ssize_t ret = 0;
 
-	val = simple_strtoul(buf, &end, 0);
-	if (end == buf)
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &val);
+	if (ret)
+		return ret;
 
 	if (val == 1) {
 		get_online_cpus();



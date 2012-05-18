Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946882Ab2ERXLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:11:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65112 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946732Ab2ERXHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:07:23 -0400
Message-Id: <20120518212652.819979095@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:27:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Danny Kukawka <danny.kukawka@bisect.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [ 40/47] OMAPDSS: VENC: fix NULL pointer dereference in DSS2 VENC sysfs debug attr on OMAP4
In-Reply-To: <20120518212701.GA5023@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danny Kukawka <danny.kukawka@bisect.de>

commit cc1d3e032df53d83d0ca4d537d8eb67eb5b3e808 upstream.

Commit ba02fa37de80bea10d706f39f076dd848348320a disabled the
venc driver registration on OMAP4. Since the driver never gets
probed/initialised your get a dereferenceed NULL pointer if you
try to get info from /sys/kernel/debug/omapdss/venc

Return info message about disabled venc if venc_dump_regs() gets called.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/omap2/dss/venc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/video/omap2/dss/venc.c
+++ b/drivers/video/omap2/dss/venc.c
@@ -699,6 +699,11 @@ void venc_dump_regs(struct seq_file *s)
 {
 #define DUMPREG(r) seq_printf(s, "%-35s %08x\n", #r, venc_read_reg(r))
 
+	if (cpu_is_omap44xx()) {
+		seq_printf(s, "VENC currently disabled on OMAP44xx\n");
+		return;
+	}
+
 	if (venc_runtime_get())
 		return;
 



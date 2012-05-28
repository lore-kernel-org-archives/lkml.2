Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab2E1D34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:29:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52114 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753946Ab2E1D3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:42 -0400
Message-Id: <20120528031214.751344602@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:28 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Danny Kukawka <danny.kukawka@bisect.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [ 086/117] OMAPDSS: VENC: fix NULL pointer dereference in DSS2 VENC sysfs debug
 attr on OMAP4
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/video/omap2/dss/venc.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/video/omap2/dss/venc.c b/drivers/video/omap2/dss/venc.c
index b3e9f90..82865be 100644
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
 



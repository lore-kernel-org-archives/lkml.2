Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab2FTSVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:21:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52480 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501Ab2FTSVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:21:21 -0400
Message-Id: <20120620173021.851052224@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 10/61] xen/hvc: Fix error cases around HVM_PARAM_CONSOLE_PFN
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit a32c88b9386ce3df87f28dd46bdc3776cd6edf75 upstream.

We weren't resetting the parameter to be passed in to a
known default. Nor were we checking the return value of
hvm_get_parameter.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/hvc/hvc_xen.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -219,7 +219,8 @@ static int xen_hvm_console_init(void)
 	if (r < 0)
 		goto err;
 	info->evtchn = v;
-	hvm_get_parameter(HVM_PARAM_CONSOLE_PFN, &v);
+	v = 0;
+	r = hvm_get_parameter(HVM_PARAM_CONSOLE_PFN, &v);
 	if (r < 0)
 		goto err;
 	mfn = v;



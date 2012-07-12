Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162084Ab2GLXBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:01:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161988Ab2GLWmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:42:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tony Lindgren <tony@atomide.com>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [ 126/187] remoteproc/omap: fix randconfig unmet direct dependencies
Date: Thu, 12 Jul 2012 15:34:42 -0700
Message-Id: <20120712191534.062672377@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ohad Ben-Cohen <ohad@wizery.com>

commit d50394266b340d930a7458fa669d36e99670f200 upstream.

OMAP_REMOTEPROC selects REMOTEPROC and RPMSG, both of which depend
on EXPERIMENTAL, so let's have OMAP_REMOTEPROC depend on EXPERIMENTAL
too, in order to avoid the below randconfig warnings.

warning: (OMAP_REMOTEPROC) selects REMOTEPROC which has unmet direct dependencies (EXPERIMENTAL)
warning: (OMAP_REMOTEPROC) selects RPMSG which has unmet direct dependencies (EXPERIMENTAL)

Reported-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/remoteproc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -7,6 +7,7 @@ config REMOTEPROC
 
 config OMAP_REMOTEPROC
 	tristate "OMAP remoteproc support"
+	depends on EXPERIMENTAL
 	depends on ARCH_OMAP4
 	depends on OMAP_IOMMU
 	select REMOTEPROC



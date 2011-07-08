Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab1GHFBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:01:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41722 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862Ab1GHFBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:01:39 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:55 2011
Message-Id: <20110708001655.365173876@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:15:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wolfram Sang <w.sang@pengutronix.de>, Dave Airlie <airlied@redhat.com>
Subject: [027/107] drm: populate irq_by_busid-member for pci
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wolfram Sang <w.sang@pengutronix.de>

commit 45e97ab65026a3391cb2c938f834ca5db4d2e5b3 upstream.

Commit 8410ea (drm: rework PCI/platform driver interface) implemented
drm_pci_irq_by_busid() but forgot to make it available in the
drm_pci_bus-struct.

This caused a freeze on my Radeon9600-equipped laptop when executing glxgears.
Thanks to Michel for noticing the flaw.

[airlied: made function static also]

Reported-by: Michel Dänzer <daenzer@vmware.com>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/drm_pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -251,7 +251,7 @@ err:
 }
 
 
-int drm_pci_irq_by_busid(struct drm_device *dev, struct drm_irq_busid *p)
+static int drm_pci_irq_by_busid(struct drm_device *dev, struct drm_irq_busid *p)
 {
 	if ((p->busnum >> 8) != drm_get_pci_domain(dev) ||
 	    (p->busnum & 0xff) != dev->pdev->bus->number ||
@@ -292,6 +292,7 @@ static struct drm_bus drm_pci_bus = {
 	.get_name = drm_pci_get_name,
 	.set_busid = drm_pci_set_busid,
 	.set_unique = drm_pci_set_unique,
+	.irq_by_busid = drm_pci_irq_by_busid,
 	.agp_init = drm_pci_agp_init,
 };
 



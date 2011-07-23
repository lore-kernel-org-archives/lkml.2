Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab1GWHub (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 03:50:31 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:39704 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751269Ab1GWHuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 03:50:23 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19SXXoqS8NSRUMxk07Xofmg7Xc65jYFk964ZXsVTb
	dSg1Pjh8t3MdJi
Subject: Re: [ANNOUNCE] 3.0-rt1
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.02.1107222203400.2702@ionos>
References: <alpine.LFD.2.02.1107222203400.2702@ionos>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Jul 2011 09:50:02 +0200
Message-ID: <1311407402.8453.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-22 at 22:37 +0200, Thomas Gleixner wrote:
> Dear RT Folks,
> 
> I'm pleased to announce the 3.0-rt1 release.

drivers-dca-convert-dcalock-to-raw.patch needs incremental update.

---
 drivers/dca/dca-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-3.0-rt/drivers/dca/dca-core.c
===================================================================
--- linux-3.0-rt.orig/drivers/dca/dca-core.c
+++ linux-3.0-rt/drivers/dca/dca-core.c
@@ -101,10 +101,10 @@ static void unregister_dca_providers(voi
 
 	INIT_LIST_HEAD(&unregistered_providers);
 
-	spin_lock_irqsave(&dca_lock, flags);
+	raw_spin_lock_irqsave(&dca_lock, flags);
 
 	if (list_empty(&dca_domains)) {
-		spin_unlock_irqrestore(&dca_lock, flags);
+		raw_spin_unlock_irqrestore(&dca_lock, flags);
 		return;
 	}
 
@@ -116,7 +116,7 @@ static void unregister_dca_providers(voi
 
 	dca_free_domain(domain);
 
-	spin_unlock_irqrestore(&dca_lock, flags);
+	raw_spin_unlock_irqrestore(&dca_lock, flags);
 
 	list_for_each_entry_safe(dca, _dca, &unregistered_providers, node) {
 		dca_sysfs_remove_provider(dca);



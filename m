Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab1BUECn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:02:43 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:60485
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755768Ab1BUECl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:02:41 -0500
Date: Mon, 21 Feb 2011 04:02:47 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Andrew Morton <akpm@osdl.org>, Oleg Nesterov <oleg@redhat.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com, Daniel Lezcano <daniel.lezcano@free.fr>
Subject: [PATCH 3/4] Add the required user_ns parameter to security_capable
Message-ID: <20110221040247.GC12580@mail.hallyn.com>
References: <20110221040156.GA12580@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110221040156.GA12580@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a compile failure.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
---
 drivers/pci/pci-sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index ea25e5b..90a6b04 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -369,7 +369,7 @@ pci_read_config(struct file *filp, struct kobject *kobj,
 	u8 *data = (u8*) buf;
 
 	/* Several chips lock up trying to read undefined config space */
-	if (security_capable(filp->f_cred, CAP_SYS_ADMIN) == 0) {
+	if (security_capable(&init_user_ns, filp->f_cred, CAP_SYS_ADMIN) == 0) {
 		size = dev->cfg_size;
 	} else if (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
 		size = 128;
-- 
1.7.0.4


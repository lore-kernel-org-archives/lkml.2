Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab3AHULF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 15:11:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab3AHULD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 15:11:03 -0500
Message-ID: <50EC7DAF.8030606@redhat.com>
Date: Tue, 08 Jan 2013 15:12:31 -0500
From: Tony Camuso <tcamuso@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: minyard@acm.org
CC: Corey Minyard <tcminyard@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        openipmi-developer@lists.sourceforge.net, grant.likely@secretlab.ca,
        k-tanaka@ce.jp.nec.com, myamazak@redhat.com
Subject: [PATCH] ipmi: replace call to try_smi_init() with call to add_smi()
References: <1355424008-20491-1-git-send-email-tcamuso@redhat.com> <50CA31BB.2030507@acm.org> <50CB3662.5080100@redhat.com>
In-Reply-To: <50CB3662.5080100@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upstream commit 9e368fa0 added function ipmi_pnp_probe(), which
calls try_smi_init() directly.

try_smi_init() allocates resources for IPMI driver. However
try_smi_init() can be called again, and the allocated resources
can be unexpectedly released when the same IPMI resource
information is found on both ACPI namespace and SMBIOS table.
ipmi_pnp_probe() should call add_smi() instead of try_smi_init()

For reference, see upstream commit ...
2407d77a1a013b88ee3b817f2b934e420e5376f5

Signed-off-by: Tony Camuso <tcamuso@redhat.com>

---
  drivers/char/ipmi/ipmi_si_intf.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index afb89be..20d13c6 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2223,7 +2223,7 @@ static int __devinit ipmi_pnp_probe(struct pnp_dev *dev,
  	info->dev = &dev->dev;
  	pnp_set_drvdata(dev, info);
  
-	return try_smi_init(info);
+	return add_smi(info);
  
  err_free:
  	kfree(info);
-- 
1.7.1

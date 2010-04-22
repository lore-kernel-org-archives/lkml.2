Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab0DVTeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:34:23 -0400
Received: from kroah.org ([198.145.64.141]:41563 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756925Ab0DVT3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:55 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:23 2010
Message-Id: <20100422190923.707779731@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Matt Domsch <Matt_Domsch@dell.com>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       James Morris <jmorris@namei.org>, maximilian attems <max@stro.at>
Subject: [182/197] tpm: autoload tpm_tis based on system PnP IDs
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matt Domsch <Matt_Domsch@dell.com>

commit 31bde71c202722a76686c3cf69a254c8a912275a upstream.

The tpm_tis driver already has a list of supported pnp_device_ids.
This patch simply exports that list as a MODULE_DEVICE_TABLE() so that
the module autoloader will discover and load the module at boottime.

Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>
Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: James Morris <jmorris@namei.org>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tpm/tpm_tis.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -637,6 +637,7 @@ static struct pnp_device_id tpm_pnp_tbl[
 	{"", 0},		/* User Specified */
 	{"", 0}			/* Terminator */
 };
+MODULE_DEVICE_TABLE(pnp, tpm_pnp_tbl);
 
 static __devexit void tpm_tis_pnp_remove(struct pnp_dev *dev)
 {



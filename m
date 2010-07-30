Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760231Ab0G3Sex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:34:53 -0400
Received: from kroah.org ([198.145.64.141]:58041 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759824Ab0G3Ryt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:49 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:37 2010
Message-Id: <20100730175137.468770716@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>
Subject: [043/205] TPM: ReadPubEK output struct fix
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

commit 02a077c52ef7631275a79862ffd9f3dbe9d38bc2 upstream.

This patch adds a missing element of the ReadPubEK command output,
that prevents future overflow of this buffer when copying the
TPM output result into it.

Prevents a kernel panic in case the user tries to read the
pubek from sysfs.

Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tpm/tpm.h |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -224,6 +224,7 @@ struct	tpm_readpubek_params_out {
 	u8	algorithm[4];
 	u8	encscheme[2];
 	u8	sigscheme[2];
+	__be32	paramsize;
 	u8	parameters[12]; /*assuming RSA*/
 	__be32	keysize;
 	u8	modulus[256];



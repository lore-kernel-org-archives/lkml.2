Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab0FNQ62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:58:28 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:40478 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab0FNQ61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:58:27 -0400
Subject: [PATCH] TPM: ReadPubEK output struct fix
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: jmorris@namei.org
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Mon, 14 Jun 2010 13:58:22 -0300
Message-ID: <1276534702.5670.8.camel@blackbox.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a missing element of the ReadPubEK command output, 
that prevents future overflow of this buffer when copying the 
TPM output result into it.

Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 8e00b4d..792868d 100644
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
-- 
1.6.6.1




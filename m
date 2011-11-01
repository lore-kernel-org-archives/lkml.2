Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab1KABLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 21:11:32 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:32790 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab1KABLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 21:11:31 -0400
Date: Tue, 1 Nov 2011 12:11:29 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the crypto-current
	tree
Message-ID: <20111101011128.GA30055@gondor.apana.org.au>
References: <20111101115851.2e37ac680db78bdba0661691@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101115851.2e37ac680db78bdba0661691@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 11:58:51AM +1100, Stephen Rothwell wrote:
> Hi Herbert,
> 
> After merging the crypto-current tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
>   GEN     /scratch/sfr/x86_64_allmodconfig/Makefile
> scripts/kconfig/conf --allmodconfig Kconfig
> net/Kconfig:5:error: recursive dependency detected!
> net/Kconfig:5:	symbol NET is selected by CRYPTO_USER
> crypto/Kconfig:103:	symbol CRYPTO_USER depends on CRYPTO
> crypto/Kconfig:15:	symbol CRYPTO is selected by BT
> net/bluetooth/Kconfig:5:	symbol BT depends on NET
> warning: (SCSI_CXGB3_ISCSI && SCSI_CXGB4_ISCSI && SCSI_BNX2X_FCOE) selects NETDEVICES which has unmet direct dependencies (NET)
> warning: (SCSI_CXGB3_ISCSI && SCSI_CXGB4_ISCSI && SCSI_BNX2_ISCSI && SCSI_BNX2X_FCOE) selects ETHERNET which has unmet direct dependencies (NETDEVICES && NET)

Hmm, don't know why I didn't see that here.

Does making it a dependency cause this to go away?

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 259dea9..527a857 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -102,8 +102,8 @@ config CRYPTO_MANAGER2
 
 config CRYPTO_USER
 	tristate "Userspace cryptographic algorithm configuration"
+	depends on NET
 	select CRYPTO_MANAGER
-	select NET
 	help
 	  Userapace configuration for cryptographic instantiations such as
 	  cbc(aes).

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

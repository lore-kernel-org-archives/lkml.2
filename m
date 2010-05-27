Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812Ab0E0WLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:11:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57621 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab0E0WLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:11:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=V0sUuTjWbdeGOrsaZ+OuFOOmYqIQkp1irK+wPi8FgiMAwPMyztIpAkJGAyFbhM+9GQ
         dLTU7wYLrClQZ7m1xkwGwI2CFNfZz9lIHg0qHwWKelAi2HXHg8VAelU+oMb6z+6xVSYH
         /JXKnFZLKbbFdeWwsoPU3iekXkkYcrfMW+QLw=
MIME-Version: 1.0
Date: Fri, 28 May 2010 03:11:09 +0500
Message-ID: <AANLkTil2oZOuDtAYyao-hM7oV2-QRrPXPRgwWtbTiKA4@mail.gmail.com>
Subject: [PATCH] Correcting Kconfig for default security module
From: Shaz <shazalive@gmail.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear James,

The following patch removes the confusion that if someone want to have
LSM as secondary and chooses DAC as the default. This will disable LSM
as discussed on SELinux mailing list.

------------------------------------------------------------------------------------------------------------------------------------------------------------

diff -uNr linux-2.6.34/security/Kconfig linux-2.6.34-my/security/Kconfig
--- linux-2.6.34-orig/security/Kconfig	2010-05-17 02:17:36.000000000 +0500
+++ linux-2.6.34/security/Kconfig	2010-05-28 02:43:07.000000000 +0500
@@ -148,11 +148,10 @@
 	default DEFAULT_SECURITY_SELINUX if SECURITY_SELINUX
 	default DEFAULT_SECURITY_SMACK if SECURITY_SMACK
 	default DEFAULT_SECURITY_TOMOYO if SECURITY_TOMOYO
-	default DEFAULT_SECURITY_DAC

 	help
 	  Select the security module that will be used by default if the
-	  kernel parameter security= is not specified.
+	  kernel parameter security= is not specified. DAC stays as the default.

 	config DEFAULT_SECURITY_SELINUX
 		bool "SELinux" if SECURITY_SELINUX=y
@@ -163,9 +162,7 @@
 	config DEFAULT_SECURITY_TOMOYO
 		bool "TOMOYO" if SECURITY_TOMOYO=y

-	config DEFAULT_SECURITY_DAC
-		bool "Unix Discretionary Access Controls"
-
+	
 endchoice

 config DEFAULT_SECURITY

-- 
Shaz

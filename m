Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab0KDOqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 10:46:09 -0400
Received: from nm2-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.248]:24520 "HELO
	nm2-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751661Ab0KDOqH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 10:46:07 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 983147.28218.bm@omp1010.mail.sp2.yahoo.com
Message-ID: <360123.63685.qm@web110515.mail.gq1.yahoo.com>
X-YMail-OSG: KD4Je74VM1kFPkROui3g2sRj52rzZEK7KpVELA3qaJcGAHv
 dGLdvxrSr_ZekF0wVdJFHOha3Dnf7brf4uMRSRMWkitZ7ewyQ4t5YdJ6tJWk
 vZWUl3OwpR760.BQbajlpw3v2gl6xkf9Q6BUJZ0BTikKsX_qEeM.KdggAFGT
 CcEjFKFssXQxmN6YhIO9PkfQPOQyBNikhC4oBpuC38YsET1GaA7hygTDSVeE
 amrwl8sJiG6whOEp0iLZhWexyikmX8bm5a6eH_9Lnf1i1YDe5u6CcfYH5sha
 z6ZglM.QucafXCfYArrHuxKj8.goG5oMp4hvJayKq5WPpgycqsbHnr9tK5Zb
 NAD3ey4gCSP6nEK3l9R8jG0H8gjgMSVruW4IkARU3
X-RocketYMMF: multiplicador
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Thu, 4 Nov 2010 07:46:02 -0700 (PDT)
From: =?iso-8859-1?Q?Andr=E9_Luis_Pereira_dos_Santos_-_BSRSoft?= 
	<andre@bsrsoft.com.br>
Reply-To: andre@bsrsoft.com.br
Subject: [PATCH 1/1] security: Reordering the boot message security framework
To: James Morris <jmorris@namei.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>

Hi.
I did the reorganization of the boot message security framework so that it is not issued before the start in fact occur:

Signed-off-by: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
---

Signed-off-by: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
--- linux-2.6.36/security/security.c    2010-10-20 18:30:22.000000000 -0200
+++ linux-2.6.36-patched/security/security.c    2010-11-04 12:20:04.000000000 -0200
@@ -56,12 +56,13 @@ static void __init do_security_initcalls
  */
 int __init security_init(void)
 {
-       printk(KERN_INFO "Security Framework initialized\n");

        security_fixup_ops(&default_security_ops);
        security_ops = &default_security_ops;
        do_security_initcalls();

+       printk(KERN_INFO "Security Framework initialized\n");
+
        return 0;
 }


      

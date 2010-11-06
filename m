Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab0KFCqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 22:46:38 -0400
Received: from nm7.bullet.mail.sp2.yahoo.com ([98.139.91.77]:46505 "HELO
	nm7.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752328Ab0KFCqg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 22:46:36 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 602290.52955.bm@omp1056.mail.sp2.yahoo.com
Message-ID: <842020.67434.qm@web110515.mail.gq1.yahoo.com>
X-YMail-OSG: 9DDUx7QVM1nXZqsIP2RYmgoFkHDSMv.tzQ9dDiztfGYIbBw
 rgNsVaaDhqz1TuYORXWkmXP8KchWXfD3VAJPywDojqHrFArc9MwUKXxbhbL3
 CM96LgWb_R52hEWikO3sZSteBthvTnGqcaiAUskyvW1CKX3y8k0BlZXjL1JD
 I_X.YBifM96oDuq0TFbE81ZZXQGsVQPdfjrGztraOM6MaLX_qnezSUXt5WPx
 suxa.lFRCNnYvwKLVCYt4LmFNForbxPpYEIkjx0zyNfPxulT.anjO3EVgVOK
 Pa4cWjxcsKbTpjivddBqdwBGU9oW.QpWZchD_fRij5Ejd.1jhxdEvZr4f8jU
 m2qxI7mQLmplXiUM8l1aWyLX9e86mFBbLYyPSYpNs
X-RocketYMMF: multiplicador
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Fri, 5 Nov 2010 19:46:34 -0700 (PDT)
From: =?iso-8859-1?Q?Andr=E9_Luis_Pereira_dos_Santos_-_BSRSoft?= 
	<andre@bsrsoft.com.br>
Reply-To: andre@bsrsoft.com.br
Subject: [PATCH v3 1/1] security: Reordering the boot message security framework 2.6.37-rc1
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi.
I did the reorganization of the boot message security framework so that it is not issued before the start in fact occur:


 
Signed-off-by: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
---
Signed-off-by: Andre Luis Pereira dos Santos <andre@bsrsoft.com.br>
--- linux-2.6.37-rc1/security/security.c        2010-11-01 09:54:12.000000000 -0200
+++ linux-2.6.37-rc1-patched/security/security.c        2010-11-04 15:04:04.000000000 -0200
@@ -56,12 +56,12 @@ static void __init do_security_initcalls
  */
 int __init security_init(void)
 {
-       printk(KERN_INFO "Security Framework initialized\n");
-
        security_fixup_ops(&default_security_ops);
        security_ops = &default_security_ops;
        do_security_initcalls();

+       printk(KERN_INFO "Security Framework initialized\n");
+
        return 0;
 }


      

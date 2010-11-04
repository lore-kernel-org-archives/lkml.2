Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab0KDTGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 15:06:03 -0400
Received: from nm1.bullet.mail.sp2.yahoo.com ([98.139.91.71]:43985 "HELO
	nm1.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752676Ab0KDTF7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 15:05:59 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 982819.26621.bm@omp1040.mail.sp2.yahoo.com
Message-ID: <516163.98392.qm@web110512.mail.gq1.yahoo.com>
X-YMail-OSG: VekBkB4VM1naLQKmF9zz7XbBSQosqKz9o7nVz9cY7lEIkoQ
 YaBVWQl9r9l8InKDyfPquRx9tPSkDCTJvUT.Xqmr.MzYrBf3ph4irJf.DXsy
 hPFAj9fd4slO3b3cY8XWbGlZIYXEiXuzO0Ln8.3NTmPeizszDlsDOKMNUJ7p
 UyTGS7mzegSCeoV67gcPrk2PdtJ_.P.M6GBoobc3XCjy9c3l_Ur58oxTrFlw
 XpYYndB0.DwsmG35aX3knm8nQey06sWYYwjm8._LAgPa4wGe14Ub1ibVRuNr
 hEeLDiO0tXHYC6P.rZpQHROO8euj5hZl51nbVazzwsDXms8ML4xiNNshwbSF
 xyT13lX5uCRZrozWIu6is7tWkyMZdXD.2dYPNtjY0
X-RocketYMMF: multiplicador
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.105.279950
Date: Thu, 4 Nov 2010 12:05:58 -0700 (PDT)
From: =?iso-8859-1?Q?Andr=E9_Luis_Pereira_dos_Santos_-_BSRSoft?= 
	<andre@bsrsoft.com.br>
Reply-To: andre@bsrsoft.com.br
Subject: [PATCH v2 1/1] security: Reordering the boot message security framework 2.6.37-rc1
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
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


      

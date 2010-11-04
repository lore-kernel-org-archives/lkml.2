Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab0KDRlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 13:41:35 -0400
Received: from nm15-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.208]:41746 "HELO
	nm15-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751937Ab0KDRlc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 13:41:32 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 333231.78472.bm@omp1002.mail.sp2.yahoo.com
Message-ID: <10017.15266.qm@web110516.mail.gq1.yahoo.com>
X-YMail-OSG: EAgJjAAVM1mdDML3l8vQr44bxhK9wkSCb.42hK7usOk3C_F
 KM5db_vGWuM2JK1GKxRE.pPSnbXFWSbrf5DkpCSaqXAXnaVZVOAzUNQ8Pdvm
 Zrc1ykOWSnb0NVSQBl8sjmjZ7GJrqTuZmMv2eVam3vOqZyRqmtS5n3He6Fhb
 k6Qwxqdff9cythlOsDK1mxtZNyA4unsLiRKIyRAQt4spZuBfE8S7_YjHYBpX
 .7g.US.j4hptbavgrvFOqmXm6oDzjpZudkhREAcBun_PdeigvyxkAwcbRgXT
 E6faj8L1Jyh5fudXiXnhrlGQwdpjPid4h1v5o3Scq1UVQOHM7gL4EBFJ.yWn
 I_ky4j2b2QEJES96p3ubUdOhk3WiGv97EWvt4O6iL
X-RocketYMMF: multiplicador
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Thu, 4 Nov 2010 10:41:30 -0700 (PDT)
From: =?iso-8859-1?Q?Andr=E9_Luis_Pereira_dos_Santos_-_BSRSoft?= 
	<andre@bsrsoft.com.br>
Reply-To: andre@bsrsoft.com.br
Subject: [PATCH 1/1] security: Reordering the boot message security framework 2.6.37-rc1
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



      

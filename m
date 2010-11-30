Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab0K3TJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:09:38 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:37382 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756197Ab0K3TIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:08:53 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: lIafO_sVM1nROeQ3GahAieGKdIFwGBuo8tTY58cgTMn1bow
 bQLJvO2E0MBuq9vMDyQHXFZV.PcSjsWlOT6LCLIO9pm3eOT1WKs6gtc4DBjZ
 ZIjJb7vaSGTbBY5xVcmM_FXANZITTalQbfCNX3vlDQPkDOOi6f.8CX9tZUhA
 2w5kEVvDIxZT_Ox_ifG3bL_hS6F3oaYZ8a80KapHhSMP_MyHY0BvGJT6pLdj
 6MmEjSmP1E6K86fcqz04xz2hlv55ADIcRmmjXD9F1.c5GnJW2VNmK5APaxSy
 WWJjuLOKVLx37ckThctHaf.o4Nhze3No-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101130190851.727701203@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 30 Nov 2010 13:07:25 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, William Hubbs <w.d.hubbs@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org
Subject: [thisops uV3 18/18] Fakekey: Simplify speakup_fake_key_pressed through this_cpu_ops
References: <20101130190707.457099608@linux.com>
Content-Disposition: inline; filename=this_cpu_fake_key
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The whole function can be expressed as a simple this_cpu_read() operation.
The function overhead is now likely multiple times that of the single
instruction that is executed in it.

Cc: William Hubbs <w.d.hubbs@gmail.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 drivers/staging/speakup/fakekey.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: linux-2.6/drivers/staging/speakup/fakekey.c
===================================================================
--- linux-2.6.orig/drivers/staging/speakup/fakekey.c	2010-11-30 12:10:12.000000000 -0600
+++ linux-2.6/drivers/staging/speakup/fakekey.c	2010-11-30 12:14:12.000000000 -0600
@@ -96,10 +96,5 @@ void speakup_fake_down_arrow(void)
 	 */
 bool speakup_fake_key_pressed(void)
 {
-	bool is_pressed;
-
-	is_pressed = get_cpu_var(reporting_keystroke);
-	put_cpu_var(reporting_keystroke);
-
-	return is_pressed;
+	return this_cpu_read(reporting_keystroke);
 }


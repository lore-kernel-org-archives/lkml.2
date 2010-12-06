Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab0LFRRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:17:32 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:35024 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753767Ab0LFRQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:16:43 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: VNVeRnUVM1kaPOnpw2.JXgDQvyvtnGypNN3KnTdtAOqHOir
 YOL6D1Tsm7CxKvTo5cWzrIJS1mzDI3cnNKN5B8rxE9_y2KwZ_iiXh2Hife5q
 ZaURFUDcPl_vZRALAfU0B96RcuJNkJAsCZeoDOQJQfZdjZ.oCmiViwLhWrsO
 9KFxXYx1Q3zwIDxUUd_EsYorq0zNgLOmgnhO.HSUtEabE5Kr8VN87Wv.pU92
 VTp_Yht38xXbIh9lykUgVYFxL0_JWXjShFtDzsp1A3J7oAkDxAI5c
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101206171640.890602570@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 11:16:26 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, William Hubbs <w.d.hubbs@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [Use cpuops V1 08/11] Fakekey: Simplify speakup_fake_key_pressed through this_cpu_ops
References: <20101206171618.302060721@linux.com>
Content-Disposition: inline; filename=cpuops_fake_key
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


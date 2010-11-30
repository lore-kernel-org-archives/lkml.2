Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab0K3UF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:05:58 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:37748 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756614Ab0K3UF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:05:57 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: t9icndMVM1lkedhQ9IbTVoElV_SjsvDakDiWcihSJo_RKoH
 JZwamxuRY6pnf.XTwOyvTjZSGkvnK1mmKBvJ8lLZXvMMt1nX71iFunwiRWQF
 KbZxaY4pIqkghEsG4MC385Ew9hrsGCfKkPgi_SHbZdIK6SZZIx_7wS8g59Ks
 otvSWWYm1THgGExQFfv.0QAyaqmrjrMCa6V5CMfHxKTkRqNZ4_IBIGSGkDsy
 0siuCjRtQTTKVyYiv8.g3OzPAP9u_AAjvaRD5_6hpW9vsYNvzVA69ZTUG8Qi
 .DurXrtRpLC2dsNK9ivB4
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 30 Nov 2010 14:05:53 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: akpm@linux-foundation.org
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [extra] timers: Use this_cpu_read
In-Reply-To: <20101130190707.457099608@linux.com>
Message-ID: <alpine.DEB.2.00.1011301404490.4039@router.home>
References: <20101130190707.457099608@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: timers: Use this_cpu_read

Eric asked for this.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 kernel/timer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c	2010-11-30 14:01:41.000000000 -0600
+++ linux-2.6/kernel/timer.c	2010-11-30 14:02:05.000000000 -0600
@@ -1249,7 +1249,7 @@ static unsigned long cmp_next_hrtimer_ev
  */
 unsigned long get_next_timer_interrupt(unsigned long now)
 {
-	struct tvec_base *base = __get_cpu_var(tvec_bases);
+	struct tvec_base *base = __this_cpu_read(tvec_bases);
 	unsigned long expires;

 	spin_lock(&base->lock);
@@ -1292,7 +1292,7 @@ void update_process_times(int user_tick)
  */
 static void run_timer_softirq(struct softirq_action *h)
 {
-	struct tvec_base *base = __get_cpu_var(tvec_bases);
+	struct tvec_base *base = __this_cpu_read(tvec_bases);

 	hrtimer_run_pending();



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab0LPSPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 13:15:21 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:22818 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754768Ab0LPSPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 13:15:18 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 5KjhIEUVM1m_gUl2zlbup3S_ZocV72wF9eBNMFvKc3hPnDb
 Bg0J__80T2AIYyE0Nb0l64zXuz8hKvJMHk9xTuRsTPfWmJ67CMMq6Ax2upfB
 Kg4gGxqmvR5nbKLcMNR2NgYiivws8cYS7q79EQKPLz_21SYWJ.ap48WZ8DSW
 6XZAxJkXyNmCEHUp0dVnoyftYBwsYZJruQjTpzgHHkLQSS0vwAZmKSilvDOO
 LE5h0Kmrw4uwbOSM3losJw9VD0NyaRJtEIQWIReFHRvf4KykvxY1HXyyPT.P
 HhDiqH9n4ksM_0XJeVJBS26frm4p2fRTHLGIZpyFv1IKCKQ--
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 16 Dec 2010 12:15:15 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <htejun@gmail.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: gameport: use this_cpu_read instead of lookup
In-Reply-To: <4D0A3AF2.50508@gmail.com>
Message-ID: <alpine.DEB.2.00.1012161214500.21588@router.home>
References: <20101214162842.542421046@linux.com>  <20101214162855.392020353@linux.com> <1292345072.5934.32.camel@edumazet-laptop> <alpine.DEB.2.00.1012141055220.17229@router.home> <4D07A2B7.8080405@zytor.com> <alpine.DEB.2.00.1012141109470.17229@router.home>
 <4D07A7CB.7010205@zytor.com> <4D07A95C.7030703@kernel.org> <4D0814AF.7080209@zytor.com> <4D08ECEF.3040909@kernel.org> <4D08EE57.8010602@zytor.com> <4D08EF4E.8070403@kernel.org> <4D0A3AF2.50508@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Christoph Lameter <cl@linux.com>

---
 drivers/input/gameport/gameport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/input/gameport/gameport.c
===================================================================
--- linux-2.6.orig/drivers/input/gameport/gameport.c	2010-12-16 11:46:18.000000000 -0600
+++ linux-2.6/drivers/input/gameport/gameport.c	2010-12-16 11:46:56.000000000 -0600
@@ -123,7 +123,7 @@ static int gameport_measure_speed(struct
 	}

 	gameport_close(gameport);
-	return (cpu_data(raw_smp_processor_id()).loops_per_jiffy *
+	return (this_cpu_read(cpu_info.loops_per_jiffy) *
 		(unsigned long)HZ / (1000 / 50)) / (tx < 1 ? 1 : tx);

 #else


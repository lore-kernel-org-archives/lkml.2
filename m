Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934006Ab2J3QjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:39:16 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47846 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933807Ab2J3QjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:39:14 -0400
Date: Tue, 30 Oct 2012 09:36:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: [PATCH tip/core/rcu 0/4] SRCU changes for 3.8
Message-ID: <20121030163650.GA23518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-8974-0000-0000-00001057692D
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000198; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00186993; UDB=6.00042359; UTC=2012-10-30
 16:39:13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch series contains SRCU changes allowing srcu_structs to be
statically initialized.  The patches are as follows:

1.	Add Lai Jiangshan as author for srcu.c and srcu.h.
	(Courtesy Lia Jiangshan.)
2.	Export process_srcu() so that the initialization macro may
	be invoked anywhere.  (Courtesy Lia Jiangshan.)
3.	Add DEFINE_SRCU().  (Courtesy Lia Jiangshan.)
4.	Add DEFINE_STATIC_SRCU().  This cannot be emulated by
	"static DEFINE_SRCU()" due to forward-reference issues.
	(Courtesy Lia Jiangshan.)

							Thanx, Paul

 b/include/linux/srcu.h |   34 ++++++++++++++++++++++++++++++++++
 b/kernel/rcutorture.c  |   41 ++++++-----------------------------------
 b/kernel/srcu.c        |    8 ++++----
 3 files changed, 44 insertions(+), 39 deletions(-)


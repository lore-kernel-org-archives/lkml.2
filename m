Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab2KPT0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:26:25 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:54676 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab2KPT0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:26:24 -0500
Date: Fri, 16 Nov 2012 11:24:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: [PATCH tip/core/rcu] Add documentation for the new rcuexp debugfs
 trace fil
Message-ID: <20121116192458.GA32740@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111619-7606-0000-0000-000005750FCD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu: Add documentation for the new rcuexp debugfs trace file

This commit adds the documentation of the rcuexp debugfs trace file
that records statistics for expedited grace periods.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

 b/Documentation/RCU/trace.txt |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 79ce989..c776968 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -41,6 +41,8 @@ also rcu/rcu_preempt) the following files will be present:
 
 rcudata:
 	Displays fields in struct rcu_data.
+rcuexp:
+	Displays statistics for expedited grace periods.
 rcugp:
 	Displays grace-period counters.
 rcuhier:
@@ -233,6 +235,45 @@ o	"ktl" is the low-order 16 bits (in hexadecimal) of the count of
 	This field is displayed only for CONFIG_RCU_BOOST kernels.
 
 
+The output of "cat rcu/rcu_preempt/rcuexp" looks as follows:
+
+s=21872 d=21872 w=0 tf=0 wd1=0 wd2=0 n=0 sc=21872 dt=21872 dl=0 dx=21872
+
+These fields are as follows:
+
+o	"s" is the starting sequence number.
+
+o	"d" is the ending sequence number.  When the starting and ending
+	numbers differ, there is an expedited grace period in progress.
+
+o	"w" is the number of times that the sequence numbers have been
+	in danger of wrapping.
+
+o	"tf" is the number of times that contention has resulted in a
+	failure to begin an expedited grace period.
+
+o	"wd1" and "wd2" are the number of times that an attempt to
+	start an expedited grace period found that someone else had
+	completed an expedited grace period that satisfies the
+	attempted request.  "Our work is done."
+
+o	"n" is number of times that contention was so great that
+	the request was demoted from an expedited grace period to
+	a normal grace period.
+
+o	"sc" is the number of times that the attempt to start a
+	new expedited grace period succeeded.
+
+o	"dt" is the number of times that we attempted to update
+	the "d" counter.
+
+o	"dl" is the number of times that we failed to update the "d"
+	counter.
+
+o	"dx" is the number of times that we succeeded in updating
+	the "d" counter.
+
+
 The output of "cat rcu/rcu_preempt/rcugp" looks as follows:
 
 completed=31249  gpnum=31250  age=1  max=18


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353Ab1D1Ppv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:45:51 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56900 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933249Ab1D1Ppt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:45:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Thiago Farina <tfransosi@gmail.com>
Subject: Re: [PATCH] s390: convert old cpumask API into new one
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
In-Reply-To: <BANLkTi=FwXMo=qRAS=1ORDF28kxXiR=G3Q@mail.gmail.com>
References: <20110429000304.3D60.A69D9226@jp.fujitsu.com> <BANLkTi=FwXMo=qRAS=1ORDF28kxXiR=G3Q@mail.gmail.com>
Message-Id: <20110429004726.3D83.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Fri, 29 Apr 2011 00:45:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -1016,21 +1016,21 @@ int __ref smp_rescan_cpus(void)
> >
> >        get_online_cpus();
> >        mutex_lock(&smp_cpu_state_mutex);
> > -       newcpus = cpu_present_map;
> > +       cpumask_copy(&newcpus, cpu_present_mask);
> >        rc = __smp_rescan_cpus();
> >        if (rc)
> >                goto out;
> > -       cpus_andnot(newcpus, cpu_present_map, newcpus);
> > -       for_each_cpu_mask(cpu, newcpus) {
> > +       cpumask_andnot(&newcpus, cpu_present_mask, &newcpus);
> > +       for_each_cpu(cpu,&newcpus) {
> please, could you add a space between cpu and ,&newcpus?

Thank you for finding.



>From 46812a238d85243a18dcec0749ba42d5f1a0e1ab Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 29 Apr 2011 00:44:43 +0900
Subject: [PATCH] s390: coding style fix

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 arch/s390/kernel/smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 4cc09b8..a80798b 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -1021,7 +1021,7 @@ int __ref smp_rescan_cpus(void)
 	if (rc)
 		goto out;
 	cpumask_andnot(&newcpus, cpu_present_mask, &newcpus);
-	for_each_cpu(cpu,&newcpus) {
+	for_each_cpu(cpu, &newcpus) {
 		rc = smp_add_present_cpu(cpu);
 		if (rc)
 			set_cpu_present(cpu, false);
-- 
1.7.3.1




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab2BAS4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 13:56:39 -0500
Received: from nm10.bullet.mail.sp2.yahoo.com ([98.139.91.80]:29206 "HELO
	nm10.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751129Ab2BAS4i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 13:56:38 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 27194.96871.bm@omp1015.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=KF3p8ZQEybGsxnLkR3RYWzP52y05+wAeB1pilL5kO5zImSwZbYgfABjyhmhqg/uVGDkX5JV4HVxx27ks6GacQIjjXVsPD3KU8y4MkESEkhC/jpVbPfb01TDuEkxFBFJQsQGD6PvSTUGOSIYEtaCCRoy00cbVlhQfuaX5aSsiwKo=;
X-YMail-OSG: COdR2ZsVM1kmA1Bj_Iwp_5eqw1MEVRpQMcHZdAPSQhIrdGP
 nElkWe3rFOncSTKL1MQFGdnFOPnbgjt6veK2gns28sCNsdsNU5gwjl2EDJih
 qMrCz5rL9ymzZ9v2PrCvBwOL7e.zYA2yT6fknpT74SLdUvlEXhD0eBvnrpQg
 A0xdCnJoTI.WR3vLsgS_fTFZrrd9Gd4MYjM0n3.i0yqpXseCZjDRylUQvVQf
 .8OlksuHkmKaebLxp5x1SD72kuJEPkSBEtlvXVQpXWZG_NdTnQj60.pNHIgy
 hvgSocYVW1duO7BazZcntRtzstj19fikxclrCXg13Brev3vmyLugqjfkAEd2
 DiwZVaEjzGzunaUx1g7oimmRaF0ulwLS_XAvL2CUpEeOl1aTE4wtnbgLIOsC
 u5QxJRl7B522_h0KjRNEiTCiSHaJ40YMnWmq029kWW3VAC40OqnG7WDYa
X-Mailer: YahooMailWebService/0.8.116.331537
References: <1328122427.31465.YahooMailNeo@web113520.mail.gq1.yahoo.com>
Message-ID: <1328122597.90242.YahooMailNeo@web113506.mail.gq1.yahoo.com>
Date: Wed, 1 Feb 2012 10:56:37 -0800 (PST)
From: Vinay Shankarkumar <vc376@yahoo.com>
Reply-To: Vinay Shankarkumar <vc376@yahoo.com>
Subject: CFS scheduler behavior regards root group
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "vc376@yahoo.com" <vc376@yahoo.com>
In-Reply-To: <1328122427.31465.YahooMailNeo@web113520.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hello.
we are testing CPU shares concept with cgroups enabled, on the .32 kernel
and observing this --
        When the load on the root group (init group) is increased, the performance
of the processes in the child cgroups decreases. Is this expected? should the share
ratio if the groups (root and child) hold good and the child performance stay same
as before the increase in load on the root group?

      I think this behavior is in accordance with the below comment, is that correct?
since there is no ->se associated with the init task group, what we are observing is valid?
/*

* How much cpu bandwidth does init_task_group get? * * In case of task-groups formed thr' the cgroup filesystem, * it * gets 100% of the cpu resources in the system. This overall * system cpu resource is divided among the tasks of * init_task_group and its child task-groups in a fair manner, * based on each entity's (task or task-group's) weight * (se->load.weight). * * In other words, if init_task_group has 10 tasks of weight * 1024) and two child groups A0 and A1 (of weight 1024 each), * then A0's share of the cpu resource is: * *      A0's bandwidth = 1024 / (10*1024 + 1024 + 1024) = *      8.33% * * We achieve this by letting init_task_group's tasks sit * directly in rq->cfs (i.e init_task_group->se[] = NULL). */
Is there a way to limit the share of the root cgroup so that the behavior we are
observing can be changed?


Please kindly copy me in the responses as I have not yet subscribed to the mailing list.

Thanks in advance,
-Vinay.      

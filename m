Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928Ab2FHBVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 21:21:11 -0400
Received: from nm24-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.226]:36544 "HELO
	nm24-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759763Ab2FHBVJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 21:21:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 19114.58981.bm@omp1052.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=0AhYeBRNaU68Ty3AqnLij9EX+utbNQKwDFeuKRCnnePYVaDsryfAX9LxZBOfgBeOPEQmn5apyY+AR4BmLXNXOGopux2pDOGWZz9UjSZkjcsKbZ0gvGtlFBBBuVKV7Erz2x1eziR6pxzT5Ms167F3+2X9DcSjVSUAX4hFwB4WZfo=;
X-YMail-OSG: c4rEE4YVM1m2a.42bTsuWxMjFHhqDKwpLXnL7ujmU1yRZcX
 xoLlFjcf3nhLn27ru7SS8T4UZtyj11dG9gPeG1BbNhn0fOH5ZDlUgSN8VrPP
 if3c2O2Cnju5_xChdypGTcDWR5LaKWUAcwYEaNrCasjHIIvBb7jz9C6P8eVJ
 mZYEjS7NVT5dobeQNoA6gPU.TcQGFEijfccTcJnIhMIe8ppFy50T4CGNtmKA
 YcRUSDDkC61ayuSs_rehPsii1pRmM4GMOKoNcJycwW_2xpkV4dtDEyzxt.zn
 7Rdu3pjwiLu43l8W7vXhOHIKaMRZj0EhvNinWzr9ew2AdDqMIhQ2Ny_A17AF
 oMFyOkc0RHoNv4jjUNuTsshACGZrKm8Pu8ubkC7z7Oy4fYp6RiSBPxpHW9P2
 8XXOuJdlJVrOlKQ3gyFpPy_Oe3zJZHW_xKf0VkmWQogQ._ZpqTods0PeZPPK
 UhBEJluj5FxaoVqWpOoMNPR4T8GcvHGjHuNvsSjIIHubZ4_zA40UGmb1s6jq
 XB8TyMWc8XYWQahsHHEWs8vJsgO8M395v.yc9hKLhJ7wfum0WqeLYoKdgytR
 O2FFlYC0yOx8RS_CrzvO3haEa6BEtjKpXwX_EAxrKRbZiLAiECsfagTQjENA
 1Hp58rExDURR.MYvf69b80UDvcNC3Of214YLWvmBiQLz2OzHsQK.m.bGJ8hQ
 603EvIAVR1iiyhm3pOIJ_c3WDLN5renTafxxWujXX7bfmUJmwphsSKZxdKFG
 o
X-Mailer: YahooMailWebService/0.8.118.349524
Message-ID: <1339118347.78794.YahooMailNeo@web112018.mail.gq1.yahoo.com>
Date: Thu, 7 Jun 2012 18:19:07 -0700 (PDT)
From: Ron Chen <ron_chen_123@yahoo.com>
Reply-To: Ron Chen <ron_chen_123@yahoo.com>
Subject: memcg cgroup controller & sbrk interaction
To: Linux Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are from the Open Grid Scheduler, which is the official Open Source Grid Engine. Open Grid Scheduler/
Grid Engine ( http://gridscheduler.sourceforge.net ) is used by many compute farms & HPC sites for job scheduling.

In the next release, we are using cgroups to define a Job Container interface for batch jobs:

http://blogs.scalablelogic.com/2012/05/grid-engine-cgroups-integration.html


However, not only us, but others have found that the memcg controller does not cause sbrk(2) or mmap(2) to
return error when the cgroup is under high memory pressure. Further, when the amount of free memory is
really low, the Linux Kernel OOM killer picks something and kills it.

http://www.spinics.net/lists/cgroups/msg02622.html


We also would like to see if it is technically possible for the Virtual Memory Manager to interact with the
memory controller properly and give us the semantics of setrlimit(2). So basically if the current address
space usage exceeds the "memory.memsw.limit_in_bytes" limit defined by the administrator, then the
memory allocation system calls (example: mmap(2), sbrk(2), etc) will return error such that the OOM
killer is not invoked.

Thanks in advance.

 -Ron

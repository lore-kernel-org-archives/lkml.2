Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758Ab2FGSH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 14:07:58 -0400
Received: from nm14-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.246]:28018 "HELO
	nm14-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760930Ab2FGSH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 14:07:56 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 915385.52237.bm@omp1050.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=GNSiH/q3mcu6f5YmBL1yAAZNmsS+78BWeFp+bp+pXCmhGz4EceRdTxAI0swxUhn4efPsdT0mh6pGRzzygvraN9eb96W/TubLbOolt9qIrMferqNRGvPEeAHBrLL8PKVBStpOedoVGBkQ+Z5FCpi0yHORkX6S/nZGUKI569o7KBM=;
X-YMail-OSG: e9B2FXsVM1nJqCz8XfkIJgA4ON3ufAJGpuBFtuuJdmzjO1b
 BJoa5piWieyNbY5Y8g2JDQSI4TZ0e5iVny1Nkk3BBKwej9RH6.qeyMguug9i
 SGPpPS_SRhue_k1oicJMZWXyFZEpmRQYHCv4.jUuxGPJ8.sko3CdayB2uThB
 .v9IbrnlOsPm1cu5Mt_an_bx4SHifUC9eydghOPIIcVMbT9nacmtbilwiUyM
 g7HbJSKMQZGKc080IqlaaxxFvzlVq398wvM5HCs72.VUegXkoUIcjDas5xoF
 l2RZI29GX_2jndUW3CIswqiVjJUaw9Z0JWxaVzerbG7o1zWU7JhH.GPehrTi
 5btxXBsinYQTmYM3zWJpdMVGgPHQSVi1qH1idF.abCeXl7A_N4GInL954_qe
 bnWkz
X-Mailer: YahooMailWebService/0.8.118.349524
Message-ID: <1339092355.77924.YahooMailNeo@web43504.mail.sp1.yahoo.com>
Date: Thu, 7 Jun 2012 11:05:55 -0700 (PDT)
From: Sunny Das <internet_everyone@yahoo.com>
Reply-To: Sunny Das <internet_everyone@yahoo.com>
Subject: User space starved by kernel 
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks,

In a single vCPU VM with Linux 3.2.14, running just IP routing using Ixia, what we see is that user space processes starve for CPU and are not scheduled for a very long time. We have a network heartbeat daemon running inside the VM which sends out packets every 5 seconds to the master in the cluster. Once this daemon fails 3 successive heartbeats, it commits suicide. Running this daemon with SCHED_RR policy did not help.

Just looking at the 'top' from the console (whenever it manages to refresh), at the peak traffic, its clear that CPU is consumed by kernel spending a huge (98-99% si) amount of time servicing software interrupts.

Now, here is the kicker: we patched the kernel with (Con's) BFS scheduler and reran our setup. The network HB daemon is able to send out HBs regularly and cluster stays sane under peak traffic. Throughput shown by Ixia is not affected either. Now, we don't want to use BFS for our production installations. So, here is the question: Are there any settings in CFS or cgroups which we can tune to alter this behavior? Any other things we can try?


Will really appreciate your help.

Thanks a lot.
Sunny

PS: The reason for using a user space daemon for HB was that if our user space control plane is not able to schedule in a timely manner, the node's status in the cluster is hosed for all practical purposes.


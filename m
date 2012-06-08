Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313Ab2FHBDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 21:03:21 -0400
Received: from nm11-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.240]:29822 "HELO
	nm11-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757319Ab2FHBDU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 21:03:20 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 947414.1793.bm@omp1054.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=WmiIMHfChpzJ2KPN5Yua3qvqvqsUfM23u5rqJYB4OGPWkLfXtGSDV7wu2XXvrFL6/SAzLjQ7TuKvAtsYNSoVY4OOG+Dc79Mq+5oGlCJ6wTV25zqBx5Vi6qqYvWL2A3sSBWqP0blAOMqCdHyEbquM8HzFO5qJ1iA6XgtoVNw7YSs=;
X-YMail-OSG: rc4.5oMVM1nb3kaNuZdJKgkzfwNShseUEsOtJMmCcqeIZbg
 yraqIm0ZiteuvPPb_Zd.zYiQ2cBU.OX7y0c8EQ0WkxTocYuzHK85vDtZE00y
 jxKiLh.XZpf6GwidS4Z7N8zgjjEoWDrFt6kqKRbDHDRE08bEo_vb5Hr8y6NM
 C.tzlpuzCbBIbKABWuDA7HkhPtbSau1wTsa7mro_KekCaQf.4QSxbxkzrLTw
 m25f1ufShCvSZYDgIn8zLul._rnBxTfPdZG1dkKOuPW15yYfp2.QOqrqyTpQ
 gGL8c6bH0607GCFI32IaifIaDY96YfH7qZBoP4C5mcU845Mjigkb16GYCFhU
 7rVHT3J6PBIR0mu5TNLymtjJqd6CYHq4RhYGUkd4iuD1GAItMYD4_n3mYvg0
 HQBnsK_bdZwxVPbHpAh1t8hL8uVOe9hjqTW6jWZGmnf_u_.3ZnmwrC5CzYWo
 nos3haCnbwIbn4G89vu96_Oem
X-Mailer: YahooMailWebService/0.8.118.349524
References: <1339092355.77924.YahooMailNeo@web43504.mail.sp1.yahoo.com>
Message-ID: <1339117399.30282.YahooMailNeo@web43507.mail.sp1.yahoo.com>
Date: Thu, 7 Jun 2012 18:03:19 -0700 (PDT)
From: Sunny Das <internet_everyone@yahoo.com>
Reply-To: Sunny Das <internet_everyone@yahoo.com>
Subject: Re: User space starved by kernel 
To: Sunny Das <internet_everyone@yahoo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1339092355.77924.YahooMailNeo@web43504.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Has anybody got any suggestions for me to try? We tried to tune these three parameters down, but that did not help the situation:

/proc/sys/kernel/sched_latency_ns
/proc/sys/kernel/sched_min_granularity_ns
/proc/sys/kernel/sched_wakeup_granularity_ns


-Sunny


----- Original Message -----
From: Sunny Das <internet_everyone@yahoo.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: 
Sent: Thursday, June 7, 2012 11:05 AM
Subject: User space starved by kernel 

Hi Folks,

In a single vCPU VM with Linux 3.2.14, running just IP routing using Ixia, what we see is that user space processes starve for CPU and are not scheduled for a very long time. We have a network heartbeat daemon running inside the VM which sends out packets every 5 seconds to the master in the cluster. Once this daemon fails 3 successive heartbeats, it commits suicide. Running this daemon with SCHED_RR policy did not help.

Just looking at the 'top' from the console (whenever it manages to refresh), at the peak traffic, its clear that CPU is consumed by kernel spending a huge (98-99% si) amount of time servicing software interrupts.

Now, here is the kicker: we patched the kernel with (Con's) BFS scheduler and reran our setup. The network HB daemon is able to send out HBs regularly and cluster stays sane under peak traffic. Throughput shown by Ixia is not affected either. Now, we don't want to use BFS for our production installations. So, here is the question: Are there any settings in CFS or cgroups which we can tune to alter this behavior? Any other things we can try?


Will really appreciate your help.

Thanks a lot.
Sunny

PS: The reason for using a user space daemon for HB was that if our user space control plane is not able to schedule in a timely manner, the node's status in the cluster is hosed for all practical purposes.

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


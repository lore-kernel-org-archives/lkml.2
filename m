Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab1JaKRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 06:17:23 -0400
Received: from home.kolivas.org ([59.167.196.135]:55304 "EHLO mine.kolivas.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932508Ab1JaKRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 06:17:22 -0400
X-Greylist: delayed 613 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Oct 2011 06:17:22 EDT
From: Con Kolivas <con@kolivas.org>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: HT (Hyper Threading) aware process scheduling doesn't work as it should
Date: Mon, 31 Oct 2011 21:06:29 +1100
Message-ID: <1479015.f2tEjKr9vR@quad>
User-Agent: KMail/4.7.2 (Linux/2.6.38.4-ck1; KDE/4.7.2; x86_64; ; )
In-Reply-To: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
References: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Oct 2011 07:57:12 PM Artem S. Tashkinov wrote:
> I've found out that even on Linux 3.0.8 the process scheduler doesn't
> correctly distributes the load amongst virtual CPUs. E.g. on a 4-core
> system (8 total virtual CPUs) the process scheduler often run some
> instances of four different tasks on the same physical CPU.

> Any thoughts? comments? I think this is quite a serious problem.

Intense cache locality logic, power saving concepts, cpu frequency governor 
behaviour and separate runqueues per CPU within the current CPU process 
scheduler in the current mainline linux kernel will ocasionally do this. Some 
workloads will be better, while others will be worse. Feel free to try my BFS 
cpu scheduler if you wish a CPU process scheduler that spreads work more 
evenly across CPUs. 

Alas the last version I synced up with will not apply cleanly past about 3.0.6 
I believe:

http://ck.kolivas.org/patches/bfs/3.0.0/3.0-sched-bfs-413.patch

Regards,
Con Kolivas

-- 
-ck

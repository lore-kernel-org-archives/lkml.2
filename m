Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934410Ab1JaLmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 07:42:33 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:39349 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933982Ab1JaLmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 07:42:31 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18Rp/INiKURK/ueFqweRxYrdbFzYmt293BCmvYBsK
	oz/R6NVYSrZLbX
Subject: Re: HT (Hyper Threading) aware process scheduling doesn't work as
 it should
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <con@kolivas.org>
Cc: "Artem S. Tashkinov" <t.artem@lycos.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1479015.f2tEjKr9vR@quad>
References: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
	 <1479015.f2tEjKr9vR@quad>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Oct 2011 12:42:28 +0100
Message-ID: <1320061348.6389.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-31 at 21:06 +1100, Con Kolivas wrote:
> On Sun, 30 Oct 2011 07:57:12 PM Artem S. Tashkinov wrote:
> > I've found out that even on Linux 3.0.8 the process scheduler doesn't
> > correctly distributes the load amongst virtual CPUs. E.g. on a 4-core
> > system (8 total virtual CPUs) the process scheduler often run some
> > instances of four different tasks on the same physical CPU.
> 
> > Any thoughts? comments? I think this is quite a serious problem.
> 
> Intense cache locality logic, power saving concepts, cpu frequency governor 
> behaviour and separate runqueues per CPU within the current CPU process 
> scheduler in the current mainline linux kernel will ocasionally do this. Some 
> workloads will be better, while others will be worse. Feel free to try my BFS 
> cpu scheduler if you wish a CPU process scheduler that spreads work more 
> evenly across CPUs. 
> 
> Alas the last version I synced up with will not apply cleanly past about 3.0.6 
> I believe:
> 
> http://ck.kolivas.org/patches/bfs/3.0.0/3.0-sched-bfs-413.patch

Yeah, it handles independent tasks well, but cache misses can be
excruciatingly painful for the others.

Q6600 box, configs as identical as possible, tbench 8

3.0.6-bfs413       728.6 MB/sec
3.0.8             1146.7 MB/sec

	-Mike


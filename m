Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab1GZQev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 12:34:51 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:57192 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab1GZQer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 12:34:47 -0400
Date: Tue, 26 Jul 2011 18:34:24 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        kobayashi.kk@ncos.nec.co.jp
Subject: Re: [PATCH] proc/softirqs: only show state for online cpus
Message-ID: <20110726163424.GC2576@osiris.boeblingen.de.ibm.com>
References: <1311599418-1915-1-git-send-email-yong.zhang0@gmail.com>
 <4E2E507F.7030607@jp.fujitsu.com>
 <CAM2zO=CGkVCMNZS8F6LxFi-NdYXf0fDLB_AEc00xrPvO_D02qw@mail.gmail.com>
 <4E2E6102.3060600@jp.fujitsu.com>
 <CAM2zO=CxriXK4bqGbwhfkfdgSpGwe1mAJE=6cYpDAf0Hxji0sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM2zO=CxriXK4bqGbwhfkfdgSpGwe1mAJE=6cYpDAf0Hxji0sQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 03:29:43PM +0800, Yong Zhang wrote:
> > Offtopic, /proc/interrupt should be protected by get_online_cpus().
> > Otherwise the header (i.e. cpu number) and the actual statistics fields
> > can be mismatched likes following. Am I missing something?
> 
> I think you are right. The reader could be preempted by cpu hotplug.
> 
> After searching the whole tree, only s390 take cpu_hotplug.lock,
> but its usage is not currect:
> 
> arch/s390/kernel/irq.c:
> int show_interrupts(struct seq_file *p, void *v)
> {
>           get_online_cpus();
>           .........
>           put_online_cpus();
> }
> 
> Because the reader will call show_interrupts nr_irqs times.
> So get_online_cpus()/put_online_cpus() should be put upper,
> maybe interrupts_open(). How do you think about it?

Indeed, it's broken. You're going to submit a patch?

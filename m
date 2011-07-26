Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab1GZHws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 03:52:48 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33151 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab1GZHwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 03:52:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E2E7246.6050204@jp.fujitsu.com>
Date: Tue, 26 Jul 2011 16:52:38 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: yong.zhang0@gmail.com
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        kobayashi.kk@ncos.nec.co.jp
Subject: Re: [PATCH] proc/softirqs: only show state for online cpus
References: <1311599418-1915-1-git-send-email-yong.zhang0@gmail.com> <4E2E507F.7030607@jp.fujitsu.com> <CAM2zO=CGkVCMNZS8F6LxFi-NdYXf0fDLB_AEc00xrPvO_D02qw@mail.gmail.com> <4E2E6102.3060600@jp.fujitsu.com> <CAM2zO=CxriXK4bqGbwhfkfdgSpGwe1mAJE=6cYpDAf0Hxji0sQ@mail.gmail.com>
In-Reply-To: <CAM2zO=CxriXK4bqGbwhfkfdgSpGwe1mAJE=6cYpDAf0Hxji0sQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Offtopic, /proc/interrupt should be protected by get_online_cpus().
>> Otherwise the header (i.e. cpu number) and the actual statistics fields
>> can be mismatched likes following. Am I missing something?
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

I agree with you.



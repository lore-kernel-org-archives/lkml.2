Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab1G0Cl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 22:41:56 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48591 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab1G0Clx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 22:41:53 -0400
MIME-Version: 1.0
In-Reply-To: <20110726163424.GC2576@osiris.boeblingen.de.ibm.com>
References: <1311599418-1915-1-git-send-email-yong.zhang0@gmail.com>
	<4E2E507F.7030607@jp.fujitsu.com>
	<CAM2zO=CGkVCMNZS8F6LxFi-NdYXf0fDLB_AEc00xrPvO_D02qw@mail.gmail.com>
	<4E2E6102.3060600@jp.fujitsu.com>
	<CAM2zO=CxriXK4bqGbwhfkfdgSpGwe1mAJE=6cYpDAf0Hxji0sQ@mail.gmail.com>
	<20110726163424.GC2576@osiris.boeblingen.de.ibm.com>
Date: Wed, 27 Jul 2011 10:41:53 +0800
Message-ID: <CAM2zO=BvgSeTiD16zVbb+3To418vkbZ3LEYzzsuZixZtEY-GSw@mail.gmail.com>
Subject: Re: [PATCH] proc/softirqs: only show state for online cpus
From: Yong Zhang <yong.zhang0@gmail.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        kobayashi.kk@ncos.nec.co.jp
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 12:34 AM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
> On Tue, Jul 26, 2011 at 03:29:43PM +0800, Yong Zhang wrote:
>> > Offtopic, /proc/interrupt should be protected by get_online_cpus().
>> > Otherwise the header (i.e. cpu number) and the actual statistics fields
>> > can be mismatched likes following. Am I missing something?
>>
>> I think you are right. The reader could be preempted by cpu hotplug.
>>
>> After searching the whole tree, only s390 take cpu_hotplug.lock,
>> but its usage is not currect:
>>
>> arch/s390/kernel/irq.c:
>> int show_interrupts(struct seq_file *p, void *v)
>> {
>>           get_online_cpus();
>>           .........
>>           put_online_cpus();
>> }
>>
>> Because the reader will call show_interrupts nr_irqs times.
>> So get_online_cpus()/put_online_cpus() should be put upper,
>> maybe interrupts_open(). How do you think about it?
>
> Indeed, it's broken. You're going to submit a patch?
>

Yeah, coming soon :)

Thanks,
Yong



-- 
Only stand for myself

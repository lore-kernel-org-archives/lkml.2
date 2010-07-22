Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab0GVT3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 15:29:18 -0400
Received: from smtp-out.google.com ([74.125.121.35]:28716 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab0GVT3Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 15:29:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=hYAyu07Cug+SoJHZ+mF5d/ikuMuLvFJtmpqIhp6tlooJSuWTQkhzVr0/uDN3cSIFq
	hJNQ7NnFNcfhwe6R10oig==
MIME-Version: 1.0
In-Reply-To: <20100712092004.3b27e13e.kamezawa.hiroyu@jp.fujitsu.com>
References: <4C369009.80503@ds.jp.nec.com> <20100709134546.GC3672@redhat.com> 
	<4C37BC1A.20102@ds.jp.nec.com> <AANLkTikECHfrksrk3QnD3X07pmgXdpo5-fv7hDLm2Zxw@mail.gmail.com> 
	<20100710132417.GA2752@redhat.com> <20100712092004.3b27e13e.kamezawa.hiroyu@jp.fujitsu.com>
From: Greg Thelen <gthelen@google.com>
Date: Thu, 22 Jul 2010 12:28:50 -0700
Message-ID: <AANLkTin9TCziHU-AX42aVWpaFDX5=4NwojGxFSFnRFAq@mail.gmail.com>
Subject: Re: [RFC][PATCH 00/11] blkiocg async support
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Nauman Rafique <nauman@google.com>,
        Munehiro Ikeda <m-ikeda@ds.jp.nec.com>, linux-kernel@vger.kernel.org,
        Ryo Tsuruta <ryov@valinux.co.jp>, taka@valinux.co.jp,
        Andrea Righi <righi.andrea@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
        balbir@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 11, 2010 at 5:20 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Sat, 10 Jul 2010 09:24:17 -0400
> Vivek Goyal <vgoyal@redhat.com> wrote:
>
>> On Fri, Jul 09, 2010 at 05:55:23PM -0700, Nauman Rafique wrote:
>>
>> [..]
>> > > Well, right.  I agree.
>> > > But I think we can work parallel.  I will try to struggle on both.
>> >
>> > IMHO, we have a classic chicken and egg problem here. We should try to
>> > merge pieces as they become available. If we get to agree on patches
>> > that do async IO tracking for IO controller, we should go ahead with
>> > them instead of trying to wait for per cgroup dirty ratios.
>> >
>> > In terms of getting numbers, we have been using patches that add per
>> > cpuset dirty ratios on top of NUMA_EMU, and we get good
>> > differentiation between buffered writes as well as buffered writes vs.
>> > reads.
>> >
>> > It is really obvious that as long as flusher threads ,etc are not
>> > cgroup aware, differentiation for buffered writes would not be perfect
>> > in all cases, but this is a step in the right direction and we should
>> > go for it.
>>
>> Working parallel on two separate pieces is fine. But pushing second piece
>> in first does not make much sense to me because second piece does not work
>> if first piece is not in. There is no way to test it. What's the point of
>> pushing a code in kernel which only compiles but does not achieve intented
>> purposes because some other pieces are missing.
>>
>> Per cgroup dirty ratio is a little hard problem and few attempts have
>> already been made at it. IMHO, we need to first work on that piece and
>> get it inside the kernel and then work on IO tracking patches. Lets
>> fix the hard problem first that is necessary to make second set of patches
>> work.
>>
>
> I've just waited for dirty-ratio patches because I know someone is working on.
> But, hmm, I'll consider to start work by myself.

I have some patches that I have to address the dirty-ratios.  I will post them.

These dirty-ratio patches do not do anything intelligent wrt to
per-cgroup writeback.  When a cgroup dirty ratio is exceeded, a
per-bdi writeback is triggered.

> (Off-topic)
> BTW, why io-cgroup's hierarchy level is limited to 2 ?
> Because of that limitation, libvirt can't work well...
>
> Thanks,
> -Kame
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

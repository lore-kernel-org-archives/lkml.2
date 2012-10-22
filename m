Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab2JVPfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:35:13 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54427 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab2JVPfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:35:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAHGf_=rYgA=yAjcvziGbN0k48zTZn8+5XQJxoMwZ4wvrX6x4sA@mail.gmail.com>
References: <506C0AE8.40702@jp.fujitsu.com> <506C0C53.60205@jp.fujitsu.com>
 <CAHGf_=p7PaQs-kpnyB8uC1MntHQfL-CXhhq4QQP54mYiqOswqQ@mail.gmail.com>
 <50727984.20401@cn.fujitsu.com> <CAHGf_=pCrx8AkL9eiSYVgwvT1v0SW2__P_DW-1Wwj_zskqcLXw@mail.gmail.com>
 <507E77D1.3030709@cn.fujitsu.com> <CAHGf_=rxGeb0RsgEFF2FRRfdX0wiE9cDyVaftsG3E8AgyzYi1g@mail.gmail.com>
 <508118A6.80804@cn.fujitsu.com> <CAHGf_=qfzEJ0VjeYkKFVtyew+wYM-rHS4nqmXU4t7HYGuv8k9w@mail.gmail.com>
 <5082305A.2050108@cn.fujitsu.com> <CAHGf_=rYgA=yAjcvziGbN0k48zTZn8+5XQJxoMwZ4wvrX6x4sA@mail.gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Mon, 22 Oct 2012 11:34:49 -0400
X-Google-Sender-Auth: CErLPN1NlwIs7z5jnFmobr2-Ua8
Message-ID: <CAHGf_=qK=mAAwor7iXxDtwTtW2Qhui_8GmtHGreMuFuQVGWAvQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] acpi,memory-hotplug : add memory offline code to acpi_memory_device_remove()
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 11:11 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>>> ??
>>> If resource was not allocated a driver, a driver doesn't need to
>>> deallocate it when
>>> error path. I haven't caught your point.
>>>
>>
>> REMOVAL_NORMAL can be in 2 cases:
>> 1. error path. If init call fails, we don't call it. We call this function
>>    only when something fails after init.
>> 2. unbind the device from the driver.
>>    If we don't offline and remove memory when unbinding the device from the driver,
>>    the device may be out of control. When we eject this driver, we don't offline and
>
> Memory never be out of control by driver unloading. It is controled
> from kernel core. It is an exception from regular linux driver model.

Ah, got it.
acpi_bus_hot_remove_device() evaluate PS3 before EJ0. Then
your first patch may cause memory lost.

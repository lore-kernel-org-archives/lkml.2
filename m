Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2JSSUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 14:20:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54321 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2JSSUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 14:20:14 -0400
MIME-Version: 1.0
In-Reply-To: <508118A6.80804@cn.fujitsu.com>
References: <506C0AE8.40702@jp.fujitsu.com> <506C0C53.60205@jp.fujitsu.com>
 <CAHGf_=p7PaQs-kpnyB8uC1MntHQfL-CXhhq4QQP54mYiqOswqQ@mail.gmail.com>
 <50727984.20401@cn.fujitsu.com> <CAHGf_=pCrx8AkL9eiSYVgwvT1v0SW2__P_DW-1Wwj_zskqcLXw@mail.gmail.com>
 <507E77D1.3030709@cn.fujitsu.com> <CAHGf_=rxGeb0RsgEFF2FRRfdX0wiE9cDyVaftsG3E8AgyzYi1g@mail.gmail.com>
 <508118A6.80804@cn.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 19 Oct 2012 14:19:53 -0400
X-Google-Sender-Auth: fCohFU0KRzuLk18hhDEepsAk2FM
Message-ID: <CAHGf_=qfzEJ0VjeYkKFVtyew+wYM-rHS4nqmXU4t7HYGuv8k9w@mail.gmail.com>
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

> Hmm, IIRC, if the memory is recognized from kerenl before driver initialization,
> the memory device is not managed by the driver acpi_memhotplug.

Yup.


> I think we should also deal with REMOVAL_NORMAL here now. Otherwise it will cause
> some critical problem: we unbind the device from the driver but we still use
> it. If we eject it, we have no chance to offline and remove it. It is very dangerous.

??
If resource was not allocated a driver, a driver doesn't need to
deallocate it when
error path. I haven't caught your point.

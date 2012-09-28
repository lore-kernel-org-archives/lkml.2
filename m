Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031379Ab2I1WVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 18:21:45 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48133 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964850Ab2I1WVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 18:21:42 -0400
MIME-Version: 1.0
In-Reply-To: <50651E68.3040208@jp.fujitsu.com>
References: <1346837155-534-1-git-send-email-wency@cn.fujitsu.com>
 <1346837155-534-2-git-send-email-wency@cn.fujitsu.com> <506509E4.1090000@gmail.com>
 <50651E68.3040208@jp.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 28 Sep 2012 18:15:22 -0400
X-Google-Sender-Auth: J8e3PU7qCmBhFCMIuCNZKtL7jSM
Message-ID: <CAHGf_=oJ_Jmjqcdr4cPJghf7PX+vfmZe=CV2sdQQhS5agzG15w@mail.gmail.com>
Subject: Re: [RFC v9 PATCH 01/21] memory-hotplug: rename remove_memory() to offline_memory()/offline_pages()
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Ni zhan Chen <nizhan.chen@gmail.com>, wency@cn.fujitsu.com, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, benh@kernel.crashing.org, paulus@samba.org,
        cl@linux.com, minchan.kim@gmail.com, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 11:50 PM, Yasuaki Ishimatsu
<isimatu.yasuaki@jp.fujitsu.com> wrote:
> Hi Chen,
>
>
> 2012/09/28 11:22, Ni zhan Chen wrote:
>>
>> On 09/05/2012 05:25 PM, wency@cn.fujitsu.com wrote:
>>>
>>> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>>
>>> remove_memory() only try to offline pages. It is called in two cases:
>>> 1. hot remove a memory device
>>> 2. echo offline >/sys/devices/system/memory/memoryXX/state
>>>
>>> In the 1st case, we should also change memory block's state, and notify
>>> the userspace that the memory block's state is changed after offlining
>>> pages.
>>>
>>> So rename remove_memory() to offline_memory()/offline_pages(). And in
>>> the 1st case, offline_memory() will be used. The function
>>> offline_memory()
>>> is not implemented. In the 2nd case, offline_pages() will be used.
>>
>>
>> But this time there is not a function associated with add_memory.
>
>
> To associate with add_memory() later, we renamed it.

Then, you introduced bisect breakage. It is definitely unacceptable.

NAK.

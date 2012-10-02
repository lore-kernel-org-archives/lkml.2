Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab2JBJnC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 05:43:02 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:51230 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab2JBJm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 05:42:59 -0400
Message-ID: <506AB719.70904@gmail.com>
Date: Tue, 02 Oct 2012 17:42:49 +0800
From: Ni zhan Chen <nizhan.chen@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        wency@cn.fujitsu.com
Subject: Re: [PATCH 0/2] memory-hotplug : notification of memoty block's state
References: <506AA4E2.7070302@jp.fujitsu.com>
In-Reply-To: <506AA4E2.7070302@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2012 04:25 PM, Yasuaki Ishimatsu wrote:
> We are trying to implement a physical memory hot removing function as
> following thread.
>
> https://lkml.org/lkml/2012/9/5/201
>
> But there is not enough review to merge into linux kernel.
>
> I think there are following blockades.
>   1. no physical memory hot removable system
>   2. huge patch-set
>
> If you have a KVM system, we can get rid of 1st blockade. Because
> applying following patch, we can create memory hot removable system
> on KVM guest.
>
> http://lists.gnu.org/archive/html/qemu-devel/2012-07/msg01389.html
>
> 2nd blockade is own problem. So we try to divide huge patch into
> a small patch in each function as follows: 
>
>  - bug fix
>  - acpi framework
>  - kernel core
>
> We had already sent bug fix patches.
>
> https://lkml.org/lkml/2012/9/27/39
>
> And the patch fixes following bug.
>
> remove_memory() offlines memory. And it is called by following two cases:
>
> 1. echo offline >/sys/devices/system/memory/memoryXX/state
> 2. hot remove a memory device
>
> In the 1st case, the memory block's state is changed and the notification
> that memory block's state changed is sent to userland after calling
> offline_memory(). So user can notice memory block is changed.,

Hi Yasuaki,

Thanks for splitting the patchset, it's more easier to review this time.
One question:

How can notify userspace? you mean function node_memory_callback or
...., but
this function basically do nothing.

>
> But in the 2nd case, the memory block's state is not changed and the
> notification is not also sent to userspcae even if calling offline_memory().
> So user cannot notice memory block is changed.
>
> We should also notify to userspace at 2nd case.
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>


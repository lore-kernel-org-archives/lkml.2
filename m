Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab1CWRV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:21:28 -0400
Received: from smtp-out.google.com ([74.125.121.67]:51611 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab1CWRV1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:21:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=HixpfuNjgDJwMyLqEMn5S40t8bDq+nH6WCiHCvp5yfcSUkqGErOkUwVbBKY0JYCgiQ
         bI3elYcEmlvtdAAfXyeA==
MIME-Version: 1.0
In-Reply-To: <20110323135241.4ada8334.kamezawa.hiroyu@jp.fujitsu.com>
References: <1300835335-2777-1-git-send-email-teravest@google.com>
 <1300835335-2777-3-git-send-email-teravest@google.com> <20110323135241.4ada8334.kamezawa.hiroyu@jp.fujitsu.com>
From: Justin TerAvest <teravest@google.com>
Date: Wed, 23 Mar 2011 10:21:01 -0700
Message-ID: <AANLkTinnDTa8_rVorBsacm-uHqJSA=JbYM9RKXswd8Sr@mail.gmail.com>
Subject: Re: [PATCH v2 2/8] block,fs,mm: IO cgroup tracking for buffered write
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: vgoyal@redhat.com, jaxboe@fusionio.com, m-ikeda@ds.jp.nec.com,
        ryov@valinux.co.jp, taka@valinux.co.jp, righi.andrea@gmail.com,
        guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
        ctalbott@google.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 9:52 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 22 Mar 2011 16:08:49 -0700
> Justin TerAvest <teravest@google.com> wrote:
>
>> +static inline void page_cgroup_set_blkio_id(struct page_cgroup *pc,
>> +                             unsigned long id)
>> +{
>> +     unsigned long old, new, prev;
>> +
>> +     /* pc->flags isn't lock protected, so we must cmpxchg. */
>> +     WARN_ON(id >= (1UL << PAGE_TRACKING_ID_BITS));
>> +     do {
>> +             new = old = pc->flags;
>> +             new &= (1UL << PAGE_TRACKING_ID_SHIFT) - 1;
>> +             new |= (unsigned long)(id << PAGE_TRACKING_ID_SHIFT);
>> +             prev = cmpxchg(&pc->flags, old, new);
>> +     } while (prev != old);
>
> How to support archs which doesn't have cmpxchg ?
> At least, you need take care of compile error.

Hi Kame,

Is there really no generic cmpxchg()? I thought that was what
include/asm-generic/cmpxchg-local.h was for.

Thanks,
Justin

>
> Thanks,
> -Kame
>
>

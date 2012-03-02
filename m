Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965445Ab2CBWxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 17:53:14 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41576 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757037Ab2CBWxM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 17:53:12 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of robdclark@gmail.com designates 10.52.68.206 as permitted sender) smtp.mail=robdclark@gmail.com; dkim=pass header.i=robdclark@gmail.com
MIME-Version: 1.0
In-Reply-To: <e39f63$3uf6dn@fmsmga002.fm.intel.com>
References: <1330616161-1937-1-git-send-email-daniel.vetter@ffwll.ch>
	<1330616161-1937-3-git-send-email-daniel.vetter@ffwll.ch>
	<e39f63$3uf6dn@fmsmga002.fm.intel.com>
Date: Fri, 2 Mar 2012 16:53:11 -0600
X-Google-Sender-Auth: Dl8I2_9tJOkF_0l3ENklj0agdgU
Message-ID: <CAF6AEGs4QyGfZyOnewigYDMi6K=62Cmb8Ntd-zQRbasTXnjy-g@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 2/3] dma-buf: add support for kernel cpu access
From: Rob Clark <rob.clark@linaro.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, linaro-mm-sig@lists.linaro.org,
        LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 2, 2012 at 4:38 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Thu,  1 Mar 2012 16:36:00 +0100, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>> Big differences to other contenders in the field (like ion) is
>> that this also supports highmem, so we have to split up the cpu
>> access from the kernel side into a prepare and a kmap step.
>>
>> Prepare is allowed to fail and should do everything required so that
>> the kmap calls can succeed (like swapin/backing storage allocation,
>> flushing, ...).
>>
>> More in-depth explanations will follow in the follow-up documentation
>> patch.
>>
>> Changes in v2:
>>
>> - Clear up begin_cpu_access confusion noticed by Sumit Semwal.
>> - Don't automatically fallback from the _atomic variants to the
>>   non-atomic variants. The _atomic callbacks are not allowed to
>>   sleep, so we want exporters to make this decision explicit. The
>>   function signatures are explicit, so simpler exporters can still
>>   use the same function for both.
>> - Make the unmap functions optional. Simpler exporters with permanent
>>   mappings don't need to do anything at unmap time.
>
> Are we going to have to have a dma_buf->ops->begin_async_access(&me, dir)
> variant for coherency control of rendering with an imported dma_buf?
> There is also no concurrency control here between multiple importers
> doing simultaneous begin_cpu_access(). I presume that is going to be a
> common function across all exporters so the midlayer might offer a
> semaphore as a library function and then the
> dma_buf->ops->begin_cpu_access() becomes mandatory as at a minimum it
> has to point to the default implementation.

Initially the expectation was that userspace would not pass a buffer
to multiple subsystems for writing (or that if it did, it would get
the undefined results that one could expect)..  so dealing w/
synchronization was punted.

I expect, though, that one of the next steps is some sort of
sync-object mechanism to supplement dmabuf

BR,
-R

> -Chris
>
> --
> Chris Wilson, Intel Open Source Technology Centre
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

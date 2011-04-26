Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab1DZG3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 02:29:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62289 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab1DZG3S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 02:29:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PWLd4E5jmr1De7yo9Jq13BNuXJ70lfoCFaQpscJlyoglpHxjrtgf5qWP2oYjZevvhK
         FAQH+ziq5nnLEmKq0gCySUNPISHxP0ZBOUE+AHyGpKdZuvhhYoS6wMSoVr/79pxkJp9B
         xIPL08B2RAWYV6eARAb8GpMvy6GHZgU7fLmA4=
MIME-Version: 1.0
In-Reply-To: <20110426062535.GB19717@localhost>
References: <BANLkTin8mE=DLWma=U+CdJaQW03X2M2W1w@mail.gmail.com>
	<20110426055521.GA18473@localhost>
	<BANLkTik8k9A8N8CPk+eXo9c_syxJFRyFCA@mail.gmail.com>
	<BANLkTim0MNgqeh1KTfvpVFuAvebKyQV8Hg@mail.gmail.com>
	<20110426062535.GB19717@localhost>
Date: Tue, 26 Apr 2011 14:29:15 +0800
Message-ID: <BANLkTinM9DjK9QsGtN0Sh308rr+86UMF0A@mail.gmail.com>
Subject: Re: readahead and oom
From: Dave Young <hidave.darkstar@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 2:25 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> On Tue, Apr 26, 2011 at 02:07:17PM +0800, Dave Young wrote:
>> On Tue, Apr 26, 2011 at 2:05 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
>> > On Tue, Apr 26, 2011 at 1:55 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>> >> On Tue, Apr 26, 2011 at 01:49:25PM +0800, Dave Young wrote:
>> >>> Hi,
>> >>>
>> >>> When memory pressure is high, readahead could cause oom killing.
>> >>> IMHO we should stop readaheading under such circumstances。If it's true
>> >>> how to fix it?
>> >>
>> >> Good question. Before OOM there will be readahead thrashings, which
>> >> can be addressed by this patch:
>> >>
>> >> http://lkml.org/lkml/2010/2/2/229
>> >
>> > Hi, I'm not clear about the patch, could be regard as below cases?
>> > 1) readahead alloc fail due to low memory such as other large allocation
>>
>> For example vm balloon allocate lots of memory, then readahead could
>> fail immediately and then oom
>
> If true, that would be the problem of vm balloon. It's not good to
> consume lots of memory all of a sudden, which will likely impact lots
> of kernel subsystems.
>
> btw readahead page allocations are completely optional. They are OK to
> fail and in theory shall not trigger OOM on themselves. We may
> consider passing __GFP_NORETRY for readahead page allocations.

Good idea, care to submit a patch?

-- 
Regards
dave

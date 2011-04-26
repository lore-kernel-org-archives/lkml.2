Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab1DZGXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 02:23:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59916 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab1DZGXK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 02:23:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dCXSRmykHNzOEQ1HEzAPSZSEJa7zW3YEV52DTBohsB1YEbg1jdVLzj9E53U2vH5C1M
         PP+oHxPF6CaZ55J7l7XSyIYnk7UMZaCiUZOT7Bt/im24lVjiUZjkGz5rGxqby5azcoIQ
         WcETNYU1bO/bXv6k6Xt4iuRdxe0IQyG91WcwE=
MIME-Version: 1.0
In-Reply-To: <20110426061353.GA19717@localhost>
References: <BANLkTin8mE=DLWma=U+CdJaQW03X2M2W1w@mail.gmail.com>
	<20110426055521.GA18473@localhost>
	<BANLkTik8k9A8N8CPk+eXo9c_syxJFRyFCA@mail.gmail.com>
	<20110426061353.GA19717@localhost>
Date: Tue, 26 Apr 2011 14:23:08 +0800
Message-ID: <BANLkTi=JoSwpNk0xW4PSYBhuNa1Q1G9LMw@mail.gmail.com>
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

On Tue, Apr 26, 2011 at 2:13 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> On Tue, Apr 26, 2011 at 02:05:12PM +0800, Dave Young wrote:
>> On Tue, Apr 26, 2011 at 1:55 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>> > On Tue, Apr 26, 2011 at 01:49:25PM +0800, Dave Young wrote:
>> >> Hi,
>> >>
>> >> When memory pressure is high, readahead could cause oom killing.
>> >> IMHO we should stop readaheading under such circumstances。If it's true
>> >> how to fix it?
>> >
>> > Good question. Before OOM there will be readahead thrashings, which
>> > can be addressed by this patch:
>> >
>> > http://lkml.org/lkml/2010/2/2/229
>>
>> Hi, I'm not clear about the patch, could be regard as below cases?
>> 1) readahead alloc fail due to low memory such as other large allocation
>> 2) readahead thrashing caused by itself
>
> When memory pressure goes up (not as much as allocation failures and OOM),
> the readahead pages may be reclaimed before they are read() accessed
> by the user space. At the time read() asks for the page, it will have
> to be read from disk _again_. This is called readahead thrashing.
>
> What the patch does is to automatically detect readahead thrashing and
> shrink the readahead size adaptively, which will the reduce memory
> consumption by readahead buffers.

Thanks for the explanation.

But still there's the question, if the allocation storm occurs when
system startup, the allocation is so quick that the detection of
thrashing is too late to avoid readahead. Is this possible?

>
> Thanks,
> Fengguang
>
>> >
>> > However there seems no much interest on that feature.. I can separate
>> > that out and resubmit it standalone if necessary.

Would like to test your new patch

>> >
>> > Thanks,
>> > Fengguang
>> >
>>
>>
>>
>> --
>> Regards
>> dave
>



-- 
Regards
dave

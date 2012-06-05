Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761702Ab2FEKVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:21:25 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61020 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761621Ab2FEKVX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:21:23 -0400
MIME-Version: 1.0
In-Reply-To: <1338891271.28282.155.camel@twins>
References: <1338520856-21020-1-git-send-email-zheng.z.yan@intel.com>
	<CABPqkBScjC5fJbTc1rYtbtRqOCyJ+7QUbdE32DgMcffBAGJNVw@mail.gmail.com>
	<CAAM7YAkYgUjwQptYvyeVawzcD5x4c-bTT_=+6AMyUb+-6HoMuQ@mail.gmail.com>
	<1338891271.28282.155.camel@twins>
Date: Tue, 5 Jun 2012 12:21:21 +0200
Message-ID: <CABPqkBSv8CbMzUiRsN2uOF1v6rFTpzhQqNbo7OKe-nzsus0GDg@mail.gmail.com>
Subject: Re: [PATCH] perf: Fix intel shared extra msr allocation
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Yan, Zheng" <zheng.z.yan@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 12:14 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2012-06-01 at 22:11 +0800, Yan, Zheng wrote:
>>
>> The real problem is from __intel_shared_reg_put_constraints(). it set
>> reg->alloc to 0
>
> ok
>
>> and decreases fake_cpuc->shared_regs->regs[reg->idx]'s
>> reference count.
>
> So? That's fake state, who cares what its left in?
>
Right, that's what I am trying to elucidate. Who cares about it
beyond validate_group()? The fake_cpuc is reallocated for each
validate group. And this includes the fake shared_regs.

>> Later when deleting the event,  put_constraints() will find
>> reg->alloc is 0 and it won't decrease the shared msr's reference count.
>
> OK, so the only problem is us setting reg->alloc to 0?

I agree with the first part of the patch in intel_try_alt_er(), we
should not touch
the actual event struct. But I am still unclear about the reg->alloc part.

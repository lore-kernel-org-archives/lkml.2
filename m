Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab2BPQhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 11:37:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53707 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2BPQhj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 11:37:39 -0500
MIME-Version: 1.0
In-Reply-To: <1329409183.2293.245.camel@twins>
References: <CAMQu2gzfNAwtf1c6jrTZpfGMSqBgBrQKmFTeCFzbvMh9ESBDUg@mail.gmail.com>
	<CAMsRxfKR1ODH56BtcUT5Dv6qOVEYGVheEcW9ugXsZmLKok==bg@mail.gmail.com>
	<CAMQu2gwWt6oQPjxc1YHgOoxVkHdck_q78Xf==7ncwRj0_uS-JQ@mail.gmail.com>
	<CAMQu2gyCPtbNfBa5V8ve2JORN+sDeAY+hvR0g0_9U354JgcuiA@mail.gmail.com>
	<CAMsRxfJVEgVJoHcaPQbMg5mwz=tZUce4oibDUxtnevSF8bGY9g@mail.gmail.com>
	<CAMQu2gxVUqDF2HkPD=QeX0N_tUd=9FTd+T+1LHCR0tsCgQxC8Q@mail.gmail.com>
	<CAMsRxfJH+9MS=Svmh0BvDSb8xqsPe2HPobkeKcn8JO35npjhwQ@mail.gmail.com>
	<CACVXFVMx9Zx3ZQr6Q-17x5NVL8iuBJjOjtw39FJiWX=fGkZNZA@mail.gmail.com>
	<1329323900.2293.150.camel@twins>
	<CACVXFVPce0A3LfL=mFo3UbN-Om7xLOo_d-LfKXDjdN5dFQdhiA@mail.gmail.com>
	<20120216150004.GE2641@mudshark.cambridge.arm.com>
	<CACVXFVM472hz+na7o2wJr1CPq-W=YB7i0UwtrsUf62+ryzWp8A@mail.gmail.com>
	<1329409183.2293.245.camel@twins>
Date: Fri, 17 Feb 2012 00:37:35 +0800
Message-ID: <CACVXFVOygObWqPMLjg6uOB6inBkvvUjsQncNW0fbmpa4Xspw0Q@mail.gmail.com>
Subject: Re: oprofile and ARM A9 hardware counter
From: Ming Lei <ming.lei@canonical.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Will Deacon <will.deacon@arm.com>, "eranian@gmail.com" <eranian@gmail.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        David Long <dave.long@linaro.org>,
        "b-cousson@ti.com" <b-cousson@ti.com>,
        "mans@mansr.com" <mans@mansr.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 12:19 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2012-02-17 at 00:12 +0800, Ming Lei wrote:
>> is triggered: u64 delta = 100 -  1000000 = 18446744073708551716.
>
> on x86 we do:
>
>  int shift = 64 - x86_pmu.cntval_bits;
>  s64 delta;
>
>  delta = (new_raw_count << shift) - (prev_raw_count << shift);
>  delta >>= shift;
>
> This deals with short overflows (on x86 the registers are typically 40
> or 48 bits wide). If the arm register is 32 you can of course also get
> there with some u32 casts.

Good idea, but it may not work if new_raw_count is bigger than prev_raw_count.

thanks
--
Ming Lei

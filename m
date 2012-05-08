Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab2EHXKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 19:10:18 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35056 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab2EHXKP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 19:10:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAHGf_=p4py5m1Pe1xon=9FcEEyf6AxW+Pc9Yy9gCvNtbXM_40A@mail.gmail.com>
References: <CAHGf_=qdE3yNw=htuRssfav2pECO1Q0+gWMRTuNROd_3tVrd6Q@mail.gmail.com>
	<CAHGf_=ojhwPUWJR0r+jVgjNd5h_sRrppzJntSpHzxyv+OuBueg@mail.gmail.com>
	<x49ehr4lyw1.fsf@segfault.boston.devel.redhat.com>
	<CAHGf_=rzcfo3OnwT-YsW2iZLchHs3eBKncobvbhTm7B5PE=L-w@mail.gmail.com>
	<x491un3nc7a.fsf@segfault.boston.devel.redhat.com>
	<CAPa8GCCgLUt1EDAy7-O-mo0qir6Bf5Pi3Va1EsQ3ZW5UU=+37g@mail.gmail.com>
	<20120502081705.GB16976@quack.suse.cz>
	<CAPa8GCCnvvaj0Do7sdrdfsvbcAf0zBe3ssXn45gMfDKCcvJWxA@mail.gmail.com>
	<20120502091837.GC16976@quack.suse.cz>
	<CAHGf_=qfuRZzb91ELEcArNaNHsfO4BBMPO8a-QRBzFNaT2ev_w@mail.gmail.com>
	<20120502192325.GA18339@quack.suse.cz>
	<CAHGf_=oOx1qPFEboQeuaeMKtveM2==BSDG=xdfRHz+gFx1GAfw@mail.gmail.com>
	<CAKgNAkjybL_hmVfONUHtCbBe_VxQHNHOrmWQErGWDUqHiczkFg@mail.gmail.com>
	<CAHGf_=p4py5m1Pe1xon=9FcEEyf6AxW+Pc9Yy9gCvNtbXM_40A@mail.gmail.com>
Date: Wed, 9 May 2012 09:10:15 +1000
Message-ID: <CAPa8GCCh-RrjsQKzh9+Sxx-joRZw4qkpxR9n4svo+QopxAj_XQ@mail.gmail.com>
Subject: Re: [PATCH] Describe race of direct read and fork for unaligned buffers
From: Nick Piggin <npiggin@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: mtk.manpages@gmail.com, Jan Kara <jack@suse.cz>,
        Jeff Moyer <jmoyer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-man@vger.kernel.org, linux-mm@kvack.org, mgorman@suse.de,
        Andrea Arcangeli <aarcange@redhat.com>, Woodman <lwoodman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 May 2012 01:29, KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:
>> So, am I correct to assume that right text to add to the page is as below?
>>
>> Nick, can you clarify what you mean by "quiesced"?
>
> finished?

Yes exactly. That might be a simpler word. Thanks!

>
>>
>> [[
>> O_DIRECT IOs should never be run concurrently with fork(2) system call,
>> when the memory buffer is anonymous memory, or comes from mmap(2)
>> with MAP_PRIVATE.
>>
>> Any such IOs, whether submitted with asynchronous IO interface or from
>> another thread in the process, should be quiesced before fork(2) is called.
>> Failure to do so can result in data corruption and undefined behavior in
>> parent and child processes.
>>
>> This restriction does not apply when the memory buffer for the O_DIRECT
>> IOs comes from mmap(2) with MAP_SHARED or from shmat(2).
>> Nor does this restriction apply when the memory buffer has been advised
>> as MADV_DONTFORK with madvise(2), ensuring that it will not be available
>> to the child after fork(2).
>> ]]
>
> I don't have good English and I can't make editorial check. But at least,
> I don't find any technical incorrect explanation here.
>
>  Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

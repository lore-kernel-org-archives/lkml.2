Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333Ab2GCHj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 03:39:56 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62761 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab2GCHjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 03:39:54 -0400
MIME-Version: 1.0
In-Reply-To: <03e601cd58ec$5b8177b0$12846710$%szyprowski@samsung.com>
References: <1331120259-30780-1-git-send-email-Barry.Song@csr.com> <03e601cd58ec$5b8177b0$12846710$%szyprowski@samsung.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 3 Jul 2012 15:39:34 +0800
Message-ID: <CAGsJ_4yjV+HDXdYraJ6CdJrSz1EPGgE6BRvO-_9n+6_UWfxqww@mail.gmail.com>
Subject: Re: [PATCH v4] mm: cma: add a simple kernel module as the helper to
 test CMA
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Barry Song <Barry.Song@csr.com>, mina86@mina86.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Barry Song <Baohua.Song@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

2012/7/3 Marek Szyprowski <m.szyprowski@samsung.com>:
> Hello,
>
> On Wednesday, March 07, 2012 12:38 PM Barry Song wrote:
>
>> From: Barry Song <Baohua.Song@csr.com>
>>
>> Any write request to /dev/cma_test will let the module to allocate memory from
>> CMA, for example:
>>
>> 1st time
>> $ echo 1024 > /dev/cma_test
>> will require cma_test to request 1MB(1024KB)
>> 2nd time
>> $ echo 2048 > /dev/cma_test
>> will require cma_test to request 2MB(2048KB)
>>
>> Any read request to /dev/cma_test will let the module to free the 1st valid
>> memory from CMA, for example:
>>
>> 1st time
>> $ cat /dev/cma_test
>> will require cma_test to free the 1MB allocated in the first write request
>> 2nd time
>> $ cat /dev/cma_test
>> will require cma_test to free the 2MB allocated in the second write request
>>
>> Signed-off-by: Barry Song <Baohua.Song@csr.com>
>> ---
>>  tools/cma/Makefile   |   13 +++++
>>  tools/cma/cma_test.c |  140 ++++++++++++++++++++++++++++++++++++++++++++++++++
>
> I'm sorry for such a long delay in processing this patch, but I wanted first to be sure
> that the core CMA code gets into mainline, then I got busy with other dma-mapping
> related stuff.

now CMA stuff has been in mainline, i think it makes more senses if
you involve this while you let people merge CMA because it is a CMA
test component.

>
> IMHO the right place for such code is in drivers/misc instead of tools/cma.
>
> This patch contains a kernel module source code so it should be put with other kernel
> modules. tools/ directory is aimed to contain user space code useful for developing and
> testing Linux kernel.

this one is aiming to test CMA, it should be in tools/ as Michal
Nazarewicz and i have talked about that.
it is not a real driver at all.

>
> Make sure that you also add Greg Kroah-Hartman <gregkh@linuxfoundation.org> on CC:,
> he maintains misc drivers.
>
>> (snipped)
>
> Best regards
> --
> Marek Szyprowski
> Samsung Poland R&D Center

-barry

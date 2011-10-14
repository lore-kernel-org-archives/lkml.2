Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab1JNOpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 10:45:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47162 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab1JNOpL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 10:45:11 -0400
MIME-Version: 1.0
In-Reply-To: <4E97F83F.6050501@alcatel-lucent.com>
References: <4E946279.8090800@alcatel-lucent.com>
	<4E97F83F.6050501@alcatel-lucent.com>
Date: Fri, 14 Oct 2011 22:45:09 +0800
Message-ID: <CAJd=RBAR6gy2=NFkEAOqH-K+YcUYQKZhsB9YAJi0-TvWFvEKMg@mail.gmail.com>
Subject: Re: [PATCH] binfmt_elf.c: core file shrinking
From: Hillf Danton <dhillf@gmail.com>
To: Thanh-Lam NGUYEN <thanh-lam.nguyen@alcatel-lucent.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 4:52 PM, Thanh-Lam NGUYEN
<thanh-lam.nguyen@alcatel-lucent.com> wrote:
> Sorry for upping the patch,
> as it is my first contribution I would like to know if there is any
> problem with it.
>
> Best regard
> Thanh lam NGUYEN
>
> On 11/10/2011 17:36, Thanh-Lam NGUYEN wrote:
>
>> The vma_shrink function looks for the 1st allocated and the last
>> allocated page. Only this part is dumped to the disk (the virual
>> start address and the size are dupdated to reflect the new dumped
>> information).
>>
>> Signed-off-by: Thanh Lam NGUYEN <thanh-lam.nguyen@alcatel-lucent.com>
>> Signed-off-by: Benjamin ZORES <Benjamin.Zores@alcatel-lucent.com>
>> ---
>>  linux/fs/binfmt_elf.c |   54
>> ++++++++++++++++++++++++++++++++++++++++++++++----

corrupted message?

>>  1 file changed, 55 insertions(+), 4 deletions(-)
>>
>> --- linux/fs/binfmt_elf.c
>> +++ linux/fs/binfmt_elf.c
>> @@ -1085,6 +1085,48 @@
>>   * Jeremy Fitzhardinge <jeremy@sw.oz.au>
>>   */
>>
>> +/*
>> + * Search for 1st and last allocated page from vma_start to vma_end.
>> + * Update vma_start and vma_end to reflect the result.
>> + */
>> +void vma_shrink(struct vm_area_struct *vma, unsigned long *vma_start,
>> +             unsigned long *vma_end)
>> +{
>> +     int allocated;
>> +     unsigned long start, addr, end;
>> +
>> +     allocated = 0;
>> +     start = end = *vma_start;
>> +     for (addr = *vma_start; _addr < *vma_end; addr += PAGE_SIZE) {
                                        -----^
                                        where is _addr from?

>> +             struct page *page;
>> +             if (get_user_pages(current, current->mm, addr, 1, 0, 1,
>> +                                &page, NULL) <= 0) {
>> +                     /* NO PAGE */

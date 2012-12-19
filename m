Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab2LSRgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 12:36:41 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:39408 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab2LSRgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 12:36:33 -0500
MIME-Version: 1.0
In-Reply-To: <20121219172207.GF24895@liondog.tnic>
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
	<1355814959-10573-27-git-send-email-yinghai@kernel.org>
	<20121219172207.GF24895@liondog.tnic>
Date: Wed, 19 Dec 2012 09:36:31 -0800
X-Google-Sender-Auth: UDeIcyDmUhQoghlhOsQ0zR0FqSE
Message-ID: <CAE9FiQW_CO19Un3YBkZpeP0wzFf4GNMuz3UMyhJxxqDniCLP=Q@mail.gmail.com>
Subject: Re: [PATCH v7 26/27] x86: add Crash kernel low reservation
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 9:22 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Dec 17, 2012 at 11:15:58PM -0800, Yinghai Lu wrote:
>> +static u64 __init get_mem_size(unsigned long limit_pfn)
>> +{
>> +     int i;
>> +     u64 pages = 0;
>> +     unsigned long start_pfn, end_pfn;
>> +
>> +     for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
>> +             start_pfn = min_t(unsigned long, start_pfn, limit_pfn);
>> +             end_pfn = min_t(unsigned long, end_pfn, limit_pfn);
>> +             pages += end_pfn - start_pfn;
>> +     }
>> +
>> +     return pages << PAGE_SHIFT;
>> +}
>
> This needs an empty function prototype for the .config variant where both
>
> # CONFIG_BLK_DEV_INITRD is not set
> # CONFIG_KEXEC is not set
>
> otherwise:
>
> arch/x86/kernel/setup.c:295:19: warning: ‘get_mem_size’ defined but not used [-Wunused-function]
>
> At a second glance though, a better fix might be if that whole
> if-deffery in setup.c could be cleaned up a bit.
>

ok,  will move the function into e820.c or memblock.c

Thanks

Yinghai

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab1HEIDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 04:03:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab1HEIDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 04:03:43 -0400
Message-ID: <4E3BA3B2.7090903@redhat.com>
Date: Fri, 05 Aug 2011 16:02:58 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] drivers/base/inode.c: let vmstat_text be optional
References: <20110804145834.3b1d92a9eeb8357deb84bf83@canb.auug.org.au> <20110804152211.ea10e3e7.rdunlap@xenotime.net> <4E3B57C3.80203@redhat.com> <4E3B82FD.1040500@xenotime.net>
In-Reply-To: <4E3B82FD.1040500@xenotime.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年08月05日 13:43, Randy Dunlap 写道:
> On 08/04/11 19:38, Cong Wang wrote:
>> 于 2011年08月05日 06:22, Randy Dunlap 写道:
>>> From: Randy Dunlap<rdunlap@xenotime.net>
>>>
>>> vmstat_text is only available when PROC_FS or SYSFS is enabled.
>>> This causes build errors in drivers/base/node.c when they are
>>> both disabled:
>>>
>>> drivers/built-in.o: In function `node_read_vmstat':
>>> node.c:(.text+0x10e28f): undefined reference to `vmstat_text'
>>>
>>> Rather than litter drivers/base/node.c with #ifdef/#endif around
>>> the affected lines of code, add macros for optional sysdev
>>> attributes so that those lines of code will be ignored, without
>>> using #ifdef/#endif in the .c file(s).  I.e., the ifdeffery
>>> is done only in a header file with sysdev_create_file_optional()
>>> and sysdev_remove_file_optional().
>>>
>>
>> This looks ugly for me, because other sysfs files here are not optional
>> only due to that they don't rely on vmstat_text.
>>
>> I still think my approach to fix this is better, that is, introducing
>> a new Kconfig for drivers/base/node.c which depends on CONFIG_SYSFS.
>
> Did you post a patch for that?  I must have missed it.

Yes, see https://lkml.org/lkml/2011/7/19/31.

I think I need to resend it. :)


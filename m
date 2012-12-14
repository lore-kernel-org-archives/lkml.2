Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab2LNAjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 19:39:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41268 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028Ab2LNAjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 19:39:08 -0500
Message-ID: <50CA7515.9080701@zytor.com>
Date: Thu, 13 Dec 2012 16:38:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 19/27] x86, boot: update comments about entries for
 64bit image
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org> <1355436141-8668-20-git-send-email-yinghai@kernel.org> <50CA6478.20008@zytor.com> <CAE9FiQURsKT8Ufy7NmWUzrzkYoH65Edk6e_kJkw_+YYx=1bXTg@mail.gmail.com>
In-Reply-To: <CAE9FiQURsKT8Ufy7NmWUzrzkYoH65Edk6e_kJkw_+YYx=1bXTg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 04:13 PM, Yinghai Lu wrote:
> On Thu, Dec 13, 2012 at 3:27 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 12/13/2012 02:02 PM, Yinghai Lu wrote:
>>> +      * If we come here from a bootloader, kernel(text+data+bss+brk),
>>> +      * ramdisk, zero_page, command line could be above 4G.
>>> +      * We depend on an identity mapped page table being provided
>>> +      * that maps our entire kernel(text+data+bss+brk), and hopefully
>>> +      * all of memory.
>>
>> We should make it explicit what we depend on.  We certainly *can* depend
>> only on text+data+bss+brk ... with the dynamic page table approach we
>> can do that, and that would be most conservative; if we depend on other
>> things we should make that explicit, not just here but in boot.txt.
>
> yes, in my version, only need kernel(text+data+bss+brk) get mapped.
> aka the INIT_SIZE for decompressing.
>

It is definitely the minmum we can rely on, and so is the minimum we 
should rely on.  In fact, we don't even need .bss/.brk to be mapped, but 
we probably should require that as a matter of protocol.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


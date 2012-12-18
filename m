Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab2LRUti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 15:49:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33649 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556Ab2LRUth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 15:49:37 -0500
Message-ID: <50D0D6D1.70400@zytor.com>
Date: Tue, 18 Dec 2012 12:49:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "Wessel, Jason" <jason.wessel@windriver.com>
Subject: Re: [PATCH v7 06/27] x86, 64bit: early #PF handler set page table
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org> <1355814959-10573-7-git-send-email-yinghai@kernel.org> <CAE9FiQXrpQtZ7Sq=xfjscKjKzZ6P89uPG0bByER8q48jEgYx_g@mail.gmail.com>
In-Reply-To: <CAE9FiQXrpQtZ7Sq=xfjscKjKzZ6P89uPG0bByER8q48jEgYx_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2012 12:43 PM, Yinghai Lu wrote:
> On Mon, Dec 17, 2012 at 11:15 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> -v8: we need to keep that handler alive until init_mem_mapping and don't
>>       let early_trap_init to trash that early #PF handler.
>>       So split early_trap_pf_init out and move it down. - Yinghai
>
> Peter,
>
> looks like moving down early_trap_init would break kgdb.
>
> we could make temporary early pgt cover 1G, and kernel and stop updating later.
>
> please check attached patch.
>
> init_mem_mapping need to be change a little: map BRK at first then switch pgt.
>
> Thanks
>
> Yinghai
>

That is putting the cart before the horse.  What is the specific 
requirement with kgdb here (I didn't see any email on that, please don't 
have private back conversations)?  Either way, however, kgdb is a tool 
to debug the kernel... having it a barrier for proper functionality of 
the kernel is not acceptable.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab0LPQ25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 11:28:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47025 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab0LPQ24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 11:28:56 -0500
Message-ID: <4D0A3E31.4000109@zytor.com>
Date: Thu, 16 Dec 2010 08:28:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Maxim Uvarov <muvarov@gmail.com>,
        linux-kernel@vger.kernel.org, Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
References: <20101208141942.GA2335@redhat.com> <4D00823A.9050808@kernel.org> <20101209124117.GA6032@redhat.com> <4D01377B.5070809@kernel.org> <20101213100848.GA2237@redhat.com> <4D0663F0.2060103@kernel.org> <4D06783C.6040009@zytor.com> <20101214224135.GB19693@redhat.com> <20101215103954.GA2243@redhat.com> <4D09958D.2040907@kernel.org> <20101216143925.GA13870@redhat.com>
In-Reply-To: <20101216143925.GA13870@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 06:39 AM, Vivek Goyal wrote:
> On Wed, Dec 15, 2010 at 08:29:01PM -0800, Yinghai Lu wrote:
>> please check
>>
>> [PATCH] x86, crashkernel, 32bit: only try to get range under 512M
>>
>> Steanishlaw report kdump is 32bit is broken.
>>
>> in misc.c for decompresser, it will do sanity checking to make sure heap
>> heap under 512M.
> 
> Thanks Yinghai. I am wondering why on 32bit heap has to be with-in 512MB.
> I think you are referring to following check in
> arch/x86/boot/compressed/misc.c.
> 
> 	if (end > ((-__PAGE_OFFSET-(512 <<20)-1) & 0x7fffffff))
> 		error("Destination address too large");
> 
> It was introduced here.
> 
> commit 968de4f02621db35b8ae5239c8cfc6664fb872d8
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Thu Dec 7 02:14:04 2006 +0100
> 
>     [PATCH] i386: Relocatable kernel support
> 
> Eric,
> 
> It has been long. By any chance would you remember where does above
> constraint come from?
> 

It might, in fact, be bogus; specifically a proxy for the fact that we
need the kernel memory including bss and brk below the lowmem boundary,
which isn't well-defined.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


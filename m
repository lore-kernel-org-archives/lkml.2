Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280Ab1DMWLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 18:11:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34613 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933068Ab1DMWLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 18:11:44 -0400
Message-ID: <4DA61F8D.3000005@zytor.com>
Date: Wed, 13 Apr 2011 15:11:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@elte.hu>,
        Alex Deucher <alexdeucher@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com> <20110412090207.GE19819@8bytes.org> <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com> <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu> <20110413172147.GI19819@8bytes.org> <4DA5F62F.3030504@kernel.org> <20110413193459.GL19819@8bytes.org> <4DA60C30.4060606@kernel.org> <20110413215025.GA18463@8bytes.org> <4DA61CCF.2080805@kernel.org>
In-Reply-To: <4DA61CCF.2080805@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2011 02:59 PM, Yinghai Lu wrote:
> On 04/13/2011 02:50 PM, Joerg Roedel wrote:
>> On Wed, Apr 13, 2011 at 01:48:48PM -0700, Yinghai Lu wrote:
>>> -	addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<20);
>>> +	addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<21);
>>
>> Btw, while looking at this code I wondered why the 512M goal is enforced
>> by the alignment. Start could be set to 512M instead and the alignment
>> can be aper_size as it should. Any reason for such a big alignment?
>>
> 
> when using bootmem, try to use big alignment (512M ), so we could avoid take ram range below 512M.
> 

Yes, his question was why on Earth are you using 0 as start if that is
the purpose.

On top of that, where the hell does the magic 512 MiB come from?  It
looks like it is either completly ad hoc, or it has something to do with
where the kexec kernel was allocated once upon a time.

	-hpa

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261Ab1DMWBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 18:01:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50719 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320Ab1DMWBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 18:01:37 -0400
Message-ID: <4DA61D26.8050500@zytor.com>
Date: Wed, 13 Apr 2011 15:01:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Alex Deucher <alexdeucher@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com> <20110412090207.GE19819@8bytes.org> <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com> <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu> <20110413172147.GI19819@8bytes.org> <4DA5F62F.3030504@kernel.org> <20110413193459.GL19819@8bytes.org> <4DA60C30.4060606@kernel.org> <20110413215025.GA18463@8bytes.org>
In-Reply-To: <20110413215025.GA18463@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2011 02:50 PM, Joerg Roedel wrote:
> On Wed, Apr 13, 2011 at 01:48:48PM -0700, Yinghai Lu wrote:
>> -	addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<20);
>> +	addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<21);
> 
> Btw, while looking at this code I wondered why the 512M goal is enforced
> by the alignment. Start could be set to 512M instead and the alignment
> can be aper_size as it should. Any reason for such a big alignment?
> 
> 	Joerg
> 
> P.S.: The box is still in the office, I will try this debug-patch
>       tomorrow.

The only reason that I can think of is that the aperture itself can be
huge, and perhaps 512 MiB is the biggest such known.  512ULL<<21 is of
course a particularly moronic way to write 1 GiB, but it was a debug patch.

The value 512 MiB apparently comes from
7677b2ef6c0c4fddc84f6473f3863f40eb71821b, which is apparently totally ad
hoc; effectively it tries to prevent a collision with kexec by
hardcoding the kdump allocation as it sat at that point in time in the
GART assignment rules.

Yeah.  Brilliant.

	-hpa


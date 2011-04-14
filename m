Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab1DNGK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 02:10:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39188 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756574Ab1DNGK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 02:10:28 -0400
Message-ID: <4DA68FBB.4030807@zytor.com>
Date: Wed, 13 Apr 2011 23:10:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Dave Airlie <airlied@redhat.com>
CC: Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Linux 2.6.39-rc3
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>	 <20110412090207.GE19819@8bytes.org>	 <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com>	 <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu>	 <20110413172147.GI19819@8bytes.org> <4DA5F62F.3030504@kernel.org>	 <4DA654D6.2060103@zytor.com> <1302746853.4842.20.camel@clockmaker-el6>
In-Reply-To: <1302746853.4842.20.camel@clockmaker-el6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2011 07:07 PM, Dave Airlie wrote:
>>
>> Okay, staring at this, it definitely seems toxic to overlay the GART
>> over memory areas reserved by the BIOS.  If I were to guess, I would say
>> that the problem here seems to be that the kernel thinks it is
>> overlaying 64 MiB of memory, but the actual GART is in fact 512 MiB in
>> size -- 131072 CPU pages -- which now overlaps the BIOS reserved areas.
>>
>> Alex D., could you comment on the "num cpu pages" bit?
> 
> These are not CPU addresses. I think we've stated that already. Not the
> droids.
> 
> the num cpu pages is how many CPU pages would be needed to fill the GPU
> GTT, for those crazy cases where CPU pagesize != GPU pagesize.
> 

OK, well, something is still weird.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


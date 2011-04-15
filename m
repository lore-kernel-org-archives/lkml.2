Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003Ab1DOUXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 16:23:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48370 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab1DOUXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 16:23:06 -0400
Message-ID: <4DA8A8F3.90406@zytor.com>
Date: Fri, 15 Apr 2011 13:22:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>,
        Alexandre Demers <alexandre.f.demers@gmail.com>,
        Joerg Roedel <joro@8bytes.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alex Deucher <alexdeucher@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
References: <BANLkTik7W0u92n_s0t32dsoLULu4QTZneA@mail.gmail.com> <4DA6145D.9070703@kernel.org> <BANLkTinud+4nUkZtnYRrU_gAFaMDWRa_AA@mail.gmail.com> <4DA655E7.3000904@zytor.com> <BANLkTimqR_M5keMqr5WAuz-t+1BkCZbwCg@mail.gmail.com> <BANLkTincU4rM+SqhzGOK_Rgxgg8fqJOOdQ@mail.gmail.com> <20110415131152.GJ18463@8bytes.org> <4DA8535B.4080901@gmail.com> <20110415142724.GK18463@8bytes.org> <4DA895A2.4060307@gmail.com> <20110415190641.GA20770@elte.hu> <4DA899EA.8010602@kernel.org>
In-Reply-To: <4DA899EA.8010602@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2011 12:18 PM, Yinghai Lu wrote:
> On 04/15/2011 12:06 PM, Ingo Molnar wrote:
> 
>>
>> Joerg, mind submitting it with a changelog that includes everything we learned 
>> about this bug and all the Tested-by's in place?
>>
>> Is anyone of the opinion that we should try to revert the allocation 
>> order/alignment changes in addition to this fix?
> 
> We should figure out what is written to 0xa0001000 (main memory) by GPU before internal GART is setup.
> 
> Joerg,
> can you insert some dump code in the drm/radon code to find out which function cause the problem?
> 

Yes, I would like to make sure we don't just paper over a real bug
(again).  I think we still should talk Joerg's patch since it seems to
be the right thing to do anyway, but I do want to make sure we don't
have a memory-overwrite bug in the kernel that we're papering over.

	-hpa

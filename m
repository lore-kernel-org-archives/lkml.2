Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab2JFASA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 20:18:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42956 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab2JFAR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 20:17:58 -0400
Message-ID: <506F78A2.3050408@zytor.com>
Date: Fri, 05 Oct 2012 17:17:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/13] x86, mm: Revert back good_end setting for 64bit
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org> <1348991844-12285-5-git-send-email-yinghai@kernel.org> <alpine.DEB.2.02.1210011139320.29232@kaball.uk.xensource.com> <20121003165105.GA30214@jshin-Toonie> <CAE9FiQW7vcwSUen_TD8tZQd6aDU2-on5_T4Bjr6aqN1bxM_5Cg@mail.gmail.com> <20121004164630.GB2244@phenom.dumpdata.com> <CAE9FiQUBohwjOzOm26yJME=JzZ7eH55hM+Q=Kc4Pz+ocaw90Jg@mail.gmail.com> <871uhcsk93.fsf@xmission.com> <CAE9FiQVx93B_imGbs1ms7gcu_-Z9HvkcGePQi9XpWQo0SKu-Kg@mail.gmail.com> <87ehlcr4et.fsf@xmission.com>
In-Reply-To: <87ehlcr4et.fsf@xmission.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2012 02:32 PM, Eric W. Biederman wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
>
>> On Fri, Oct 5, 2012 at 2:04 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>>> Is there a git commit that explains what the 'big range' problem is?
>>>
>>> At least on x86_64 this was recently tested and anywhere below 4G is
>>> good, and there is a patch floating around somewhere to remove this
>>> issue.
>>
>> patch for kernel or kexec-tools?
>
> kernel.
>
> The sgi guys needed a kdump kernel with 1G of ram to dump their all of
> the memory on one of their crazy large machines and so investigated
> this.
>
> Basically they found that a kdump kernel loaded anywhere < 4G worked,
> the only change that was needed was to relaxy the 896M hard code.
>
> In one test they had a kdump kernel loaded above 2G.
>

Seriously, any case where we can't load anywhere in physical ram on 
x86-64 is a bug.  i386 is another matter.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


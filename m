Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab2JFAgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 20:36:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43131 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab2JFAgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 20:36:23 -0400
Message-ID: <506F7CF5.2070904@zytor.com>
Date: Fri, 05 Oct 2012 17:36:05 -0700
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
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org> <1348991844-12285-5-git-send-email-yinghai@kernel.org> <alpine.DEB.2.02.1210011139320.29232@kaball.uk.xensource.com> <20121003165105.GA30214@jshin-Toonie> <CAE9FiQW7vcwSUen_TD8tZQd6aDU2-on5_T4Bjr6aqN1bxM_5Cg@mail.gmail.com> <20121004164630.GB2244@phenom.dumpdata.com> <CAE9FiQUBohwjOzOm26yJME=JzZ7eH55hM+Q=Kc4Pz+ocaw90Jg@mail.gmail.com> <871uhcsk93.fsf@xmission.com> <CAE9FiQVx93B_imGbs1ms7gcu_-Z9HvkcGePQi9XpWQo0SKu-Kg@mail.gmail.com> <87ehlcr4et.fsf@xmission.com> <506F78A2.3050408@zytor.com> <87zk40mokt.fsf@xmission.com>
In-Reply-To: <87zk40mokt.fsf@xmission.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2012 05:28 PM, Eric W. Biederman wrote:
>>
>> Seriously, any case where we can't load anywhere in physical ram on x86-64 is a
>> bug.  i386 is another matter.
>
> As I recall there are data structures like the IDT that only have a
> 32bit base address.
>

Not true.  The only one I know of is memory for the trampoline which has 
to be below 1M.  The < 1M space is already handled specially for good 
reason.

> According to the bzImage header we don't support ramdisks above 4G.
> I think we also have a 32bit address for the kernel command line
> in the bzImage header.

There are pointers in the bzImage header, that is true.  We can fix that 
problem, though, at least for entry via the 64-bit entry point.

> In the case of kdump in particular there is a need for DMAable
> memory and in general that means memory below 4G.  So as long
> as we only support one memory extent for kdump it makes sense
> for that segment to be below 4G.

"In general" meaning "no iotlb"?  In that case you have some unknown 
address space restriction which may or may not be 4G...

> For a normal x86_64 kernel which gets to use most of the memory it
> definitely should be loadable anywhere in memory.

Yes.  We should fix problems, like the limitations in the boot_params 
structure.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


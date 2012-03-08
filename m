Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab2CHGAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 01:00:32 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:46818 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab2CHGAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 01:00:30 -0500
Message-ID: <4F584AFC.9070300@oss.ntt.co.jp>
Date: Thu, 08 Mar 2012 15:00:28 +0900
From: =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Don Zickus <dzickus@redhat.com>, linux-tip-commits@vger.kernel.org,
        torvalds@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, mingo@elte.hu, Yinghai Lu <yinghai@kernel.org>,
        akpm@linux-foundation.org, vgoyal@redhat.com
Subject: Re: [PATCH 2/2] boot: add early NMI counter
References: <CAE9FiQVPnO8-tuPoio0Wxv=8rjdm2tJbBk3+3ystueyYtZn9BA@mail.gmail.com> <20120216172735.GX9751@redhat.com> <CAE9FiQVhbAM9vjx-uFcuc0ndsUp0aez9_TsQHStje5G5iwYbag@mail.gmail.com> <20120216215603.GH9751@redhat.com> <m1y5s2ku36.fsf@fess.ebiederm.org> <m1fwe9bpk2.fsf@fess.ebiederm.org> <20120217195430.GO9751@redhat.com> <m1y5s07rn3.fsf@fess.ebiederm.org> <20120220151419.GU9751@redhat.com> <m1obss39a4.fsf@fess.ebiederm.org> <20120221135934.GF26998@redhat.com> <m1ipip6xe8.fsf@fess.ebiederm.org> <4F573E1C.2060909@oss.ntt.co.jp> <4F573E74.5040504@oss.ntt.co.jp> <4F573EF0.1080501@oss.ntt.co.jp> <m1399j1ysk.fsf@fess.ebiederm.org>
In-Reply-To: <m1399j1ysk.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2012 01:50 PM, Eric W. Biederman wrote:
> Fernando Luis Vázquez Cao<fernando@oss.ntt.co.jp>  writes:
>
>> Subject: [PATCH] boot: add early NMI counter
>>
>> From: Fernando Luis Vazquez Cao<fernando@oss.ntt.co.jp>
>>
>> We currently ignore early NMIs but it would be nice to be able to
>> know whether they actually occurred.
>>
>> This patch adds an early NMI counter and exports it trough
>> /proc/interrupts with the name of ENM (Early NMI).
> For a userspace interface I suspect we just want to dump the count
> into the NMI counter.
>
> It probably makes sense to have a separate variable in early boot like
> you do, but then about the time we setup the normal NMI handler move the
> NMI count over and possibly do something like reboot if that is our
> policy.

I am fine with either approach. I guess that is the x86 maintainers'
call. Ingo, Thomas, Peter, what do you think? Should I add a new
entry to /proc/interrupts or move over the early NMI count to the
existing per-cpu NMI counter?

Thanks,
Fernando

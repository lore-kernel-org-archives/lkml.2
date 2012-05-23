Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169Ab2EWIKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 04:10:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57253 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757182Ab2EWIKo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 04:10:44 -0400
MIME-Version: 1.0
In-Reply-To: <1337759644.9698.49.camel@twins>
References: <1337754751-9018-1-git-send-email-kernelfans@gmail.com>
	<1337754751-9018-2-git-send-email-kernelfans@gmail.com>
	<1337759644.9698.49.camel@twins>
Date: Wed, 23 May 2012 16:10:43 +0800
Message-ID: <CAFgQCTvhVs8-onz3huovYe=StOYJe2pJO-nka_7KogSju6AttQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] sched: add virt sched domain for the guest
From: Liu ping fan <kernelfans@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 3:54 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-05-23 at 14:32 +0800, Liu Ping Fan wrote:
>> From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
>>
>> The guest's scheduler can not see the numa info on the host and
>> this will result to the following scene:
>>   Supposing vcpu-a on nodeA, vcpu-b on nodeB, when load balance,
>> the tasks' pull and push between these vcpus will cost more. But
>> unfortunately, currently, the guest is just blind to this.
>>
>> This patch want to export the host numa info to the guest, and help
>> guest to rebuild its sched domain based on host's info.
>
> Hell no, we're not going to export sched domains, if kvm/qemu wants this
> its all in sysfs.
>
> The whole sched_domain stuff is a big enough pain as it is, exporting
> this and making it a sodding API is the worst thing ever.
>
> Whatever brainfart made you think this is needed anyway? sysfs contains
> the host topology, qemu can already create whatever guest topology you
> want (see the -smp and -numa arguments), so what gives?

I think -numa option will be used to emulate the special virtual
machine to customer, and do not necessary map to host topology.
And even we map them exactly with -numa option, the movement of vcpu
threads among host nodes will break the topology initialized by -numa
option.
So give the guest a opportunity to adjust its topology?

Thanks and regards,
pingfan

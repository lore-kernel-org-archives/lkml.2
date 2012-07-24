Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab2GXNfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 09:35:40 -0400
Received: from relay.parallels.com ([195.214.232.42]:37642 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab2GXNfj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 09:35:39 -0400
Message-ID: <500EA4A2.8050806@parallels.com>
Date: Tue, 24 Jul 2012 17:35:30 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Olof Johansson <olof@lixom.net>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Subject: Re: [REGRESSION] [PATCH] block: uninitialized ioc->nr_tasks triggers
 WARN_ON
References: <20120717213643.GA24726@quad.lixom.net> <20120717222444.GG24336@google.com>
In-Reply-To: <20120717222444.GG24336@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

07/18/2012 02:24 AM, Tejun Heo пишет:
> Hello, Olof.
>
> On Tue, Jul 17, 2012 at 02:36:43PM -0700, Olof Johansson wrote:
>> It seems like the init of ioc->nr_tasks was removed in that patch,
>> so it starts out at 0 instead of 1.
>>
>> Tejun, is the right thing here to add back the init, or should something else
>> be done?
>>
>> The below patch removes the warning, but I haven't done any more extensive
>> testing on it.
>>
>>
>> Signed-off-by: Olof Johansson <olof@lixom.net>
> Right, the patch shouldn't have replaced the init.
>
>   Acked-by: Tejun Heo <tj@kernel.org>
>
> Fortunately, the effect of the bug is limited.  ioc->nr_tasks only
> used to veto block cgroup migration if a task has ioc which is shared
> by multiple tasks.  Currently, the only known program using CLONE_IO
> is dump and even if somebody migrates some threads of a single dump
> instance to a different block cgroup, the result won't be catastrophic
> although block cgroup policies would become ambiguous.  IMHO, it
> should be okay to route this through -stable after 3.5.  Jens?

Please notice that annoying WARN_ON comes from world-visible 
ioc_task_link(). So any third-party module using ioc_task_link() ends up 
in that clutter in logs. E.g. OpenVZ ploop block-device uses 
ioc_task_link().

Thanks,
Maxim


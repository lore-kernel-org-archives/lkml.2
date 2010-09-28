Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab0I1VQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 17:16:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7757 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab0I1VQG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 17:16:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=r7k17uXPJv3kmMQz949qrwMCy7/21ZSctYroM/Eor4VKYdYUD/i3NQzBRwdL55UAyY
         QEupXKJtfsBz4dyONa2Q==
MIME-Version: 1.0
In-Reply-To: <1285682273.7469.3.camel@marge.simson.net>
References: <1285633798-26886-1-git-send-email-ncrao@google.com> <1285682273.7469.3.camel@marge.simson.net>
From: Nikhil Rao <ncrao@google.com>
Date: Tue, 28 Sep 2010 14:15:42 -0700
Message-ID: <AANLkTin=Dic2UE55yUaam8NzGHTib=9s=x-wyzk03BU0@mail.gmail.com>
Subject: Re: [PATCH 0/3][RFC] Improve load balancing when tasks have large
 weight differential
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 6:57 AM, Mike Galbraith <efault@gmx.de> wrote:
> On Mon, 2010-09-27 at 17:29 -0700, Nikhil Rao wrote:
>> Hi all,
>>
>> I have attached a series of patches that improve load balancing when there is a
>> large weight differential between tasks. These patches are based off the
>> feedback Peter Zijlstra gave in an earlier post (see http://thread.gmane.org/gmane.linux.kernel/1015966).
>> They can be applied to v2.6.36-rc5 or -tip without conflicts.
>>
>> Tested with the following setup.
>> - Test machine is a 16 cpu box (quad-socket, quad-core).
>> - Baseline is v2.6.36-rc5 kernel
>>
>> We spawn 16 SCHED_IDLE soaker threads and one SCHED_NORMAL task. On the
>> baseline kernel, the machine has ~18% idle time. With these patches applied on
>> top of baseline, idle time drops to 0%.
>
> Hm. I can get it stuck with one core idle on ym little quad.
>
> top - 15:53:22 up 11 min, 17 users,  load average: 5.05, 4.40, 2.51
> Tasks: 270 total,   7 running, 263 sleeping,   0 stopped,   0 zombie
> Cpu(s): 75.3%us,  0.0%sy,  0.0%ni, 24.7%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
>
>  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
>  7455 root       5 -15  7996  340  256 R  100  0.0   0:59.93 1 pert
>  7421 root      20   0  7996  340  256 R   50  0.0   4:20.01 3 pert
>  7422 root      20   0  7996  340  256 R   50  0.0   3:45.81 2 pert
>  7423 root      20   0  7996  340  256 R   50  0.0   4:09.45 2 pert
>  7424 root      20   0  7996  344  256 R   50  0.0   4:12.75 3 pert
>
>

Mike,

Thanks for running this. I've not been able to reproduce what you are
seeing on the few test machines that I have (different combinations of
MC, CPU and NODE domains). Can you please give me more info about
your setup?

-Thanks,
Nikhil

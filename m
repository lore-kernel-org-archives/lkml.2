Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab1KBGdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 02:33:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45321 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab1KBGdl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 02:33:41 -0400
MIME-Version: 1.0
In-Reply-To: <20111101152320.GA30466@redhat.com>
References: <CAGr+u+zkPiZpGefstcbJv_cj929icWKXbqFy1uR22Hns1hzFeQ@mail.gmail.com>
	<20111101152320.GA30466@redhat.com>
Date: Wed, 2 Nov 2011 12:03:39 +0530
Message-ID: <CAGr+u+wgAYVWgdcG6o+6F0mDzuyNzoOxvsFwq0dMsR3JNnZ-cA@mail.gmail.com>
Subject: Re: Issue with core dump
From: trisha yad <trisha1march@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-mm <linux-mm@kvack.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <htejun@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks all for your answer.

In loaded embedded system the time at with code hit do_user_fault()
and core_dump_wait() is bit
high, I check on my  system it took 2.7 sec. so it is very much
possible that core dump is not correct.
It  contain global value updated.

So is it possible at time of send_signal() we can stop modification of
faulty thread memory ?


Thanks



On Tue, Nov 1, 2011 at 8:53 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 11/01, trisha yad wrote:
>>
>> Dear all,
>>
>> I am running a multithreaded  application. So consider a global
>> variable x which is used by a, b and c thread.
>>
>> In thread 'a' do abnormal operation(invalid memory access) and kernel
>> send signal kill to it. In the mean time Thread 'b' and Thread 'c'
>> got schedule and update
>> the variable x. when I got the core file, variable x  got updated, and
>> I am not  getting actual value that is present at time of crash of
>> thread a.
>> But In core file I got updated value of x. I want In core file exact
>> the same memory status as it at time of abnormal operation(invalid
>> memory access)
>
> Yes, this is possible.
>
>> Is there any solution for such problem. ?
>>
>> I want in core dump the same status  of memory as at time of abnormal
>> operation(invalid memory access).
>
> I don't think we can "fix" this.
>
> We can probably change complete_signal() to notify other threads
> "immediately", but this is not simple and obviously can not close
> the window completely.
>
> Whatever we do, we can't "stop" other threads at the time when
> thread 'a' traps. All we can do is to try to shrink the window.
>
> Oleg.
>
>

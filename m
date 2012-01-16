Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab2APFzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 00:55:14 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36082 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab2APFzN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 00:55:13 -0500
MIME-Version: 1.0
In-Reply-To: <CAGdaada1=84Pmz5Zp+TjwDWvEtdHJq7DCxm5Lx6yeUqDvzerHg@mail.gmail.com>
References: <CAKwxwqwM0usOqvbu8ZaG6=SXS6tjQXqtrGjXnbEUMuqZaUs8Sg@mail.gmail.com>
 <CAGdaada1=84Pmz5Zp+TjwDWvEtdHJq7DCxm5Lx6yeUqDvzerHg@mail.gmail.com>
From: Prateek Sharma <prateek3.14@gmail.com>
Date: Mon, 16 Jan 2012 11:24:51 +0530
Message-ID: <CAKwxwqxsU204wfJoQH_B1v=W3=qmh4b_7J3LB+OVSAAp7VrnNw@mail.gmail.com>
Subject: Re: High sleep_on_page latency
To: Mulyadi Santosa <mulyadi.santosa@gmail.com>
Cc: kernelnewbies@kernelnewbies.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 10:41 AM, Mulyadi Santosa
<mulyadi.santosa@gmail.com> wrote:
> Hi Prateek...
>
> On Mon, Jan 16, 2012 at 11:48, Prateek Sharma <prateek3.14@gmail.com> wrote:
>> The latencytop output for the process doing the IO (qemu) is below:
>>
>> Process qemu-system-x86 (6239)             Total: 31363.7 msec
>> [sleep_on_page]                                   1966.5 msec         81.4 %
>> Waiting for event (select)                          5.0 msec          7.8 %
>> [kvm_vcpu_block]                                    5.0 msec          8.5 %
>> synchronous write                                   1.7 msec          0.0 %
>> Userspace lock contention                           1.5 msec          2.3 %
>
> Which qemu version do you use now? AFAIK certain new qemu versions
> already uses iothreads by default. That should reduce I/O latency...
> AFAIK too iothreads is not enabled by default...but for qemu 1.0 above
> it's enabled by default. Are you compiling from source?
>

I am using qemu-kvm 0.15, with KVM.

> Regarding the function sleep_on_page(). It's in turn io_schedule().
> And here's the comment above the function declaration of
> io_schedule():
> /*
> * This task is about to go to sleep on IO. Increment rq->nr_iowait so
> * that process accounting knows that this is a task in IO wait state.
> */
>
> You can confirm it by yourself in:
> http://lxr.linux.no/#linux+v3.2.1/kernel/sched.c#L5872
>

   My initial understanding was that sleep_on_page is 'called' by
__lock_page, which is usually called by file_read .
    So, i assumed that sleep_on_page is for the page-lock contention.
My primary confusion is with the interpretation of latencytop output.
2 seconds even for I/O to complete seems awfully long.


> Hope it helps....
>
> --
> regards,
>
> Mulyadi Santosa
> Freelance Linux trainer and consultant
>
> blog: the-hydra.blogspot.com
> training: mulyaditraining.blogspot.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab0EJMWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 08:22:51 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:50532 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab0EJMWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 08:22:49 -0400
Message-ID: <4BE7FB7B.5010600@oss.ntt.co.jp>
Date: Mon, 10 May 2010 21:26:35 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>, mtosatti@redhat.com,
       agraf@suse.de, fernando@oss.ntt.co.jp, kvm@vger.kernel.org,
       kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/12] KVM, x86, ppc, asm-generic: moving dirty bitmaps
 to user space
References: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com> <4BE7F6D7.3060005@redhat.com>
In-Reply-To: <4BE7F6D7.3060005@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>
>> get.org get.opt switch.opt
>>
>> slots[7].len=32768 278379 66398 64024
>> slots[8].len=32768 181246 270 160
>> slots[7].len=32768 263961 64673 64494
>> slots[8].len=32768 181655 265 160
>> slots[7].len=32768 263736 64701 64610
>> slots[8].len=32768 182785 267 160
>> slots[7].len=32768 260925 65360 65042
>> slots[8].len=32768 182579 264 160
>> slots[7].len=32768 267823 65915 65682
>> slots[8].len=32768 186350 271 160
>>
>> At a glance, we know our optimization improved significantly compared
>> to the original get dirty log ioctl. This is true for both get.opt and
>> switch.opt. This has a really big impact for the personal KVM users who
>> drive KVM in GUI mode on their usual PCs.
>>
>> Next, we notice that switch.opt improved a hundred nano seconds or so for
>> these slots. Although this may sound a bit tiny improvement, we can feel
>> this as a difference of GUI's responses like mouse reactions.
>
> 100 ns... this is a bit on the low side (and if you can measure it
> interactively you have much better reflexes than I).
>
>> To feel the difference, please try GUI on your PC with our patch series!
>
> No doubt get.org -> get.opt is measurable, but get.opt->switch.opt is
> problematic. Have you tried profiling to see where the time is spent
> (well I can guess, clearing the write access from the sptes).

Sorry but no, and I agree with your guess.
Anyway, I want to do some profiling to confirm this guess.


BTW, If we only think about performance improvement of time, optimized
get(get.opt) may be enough at this stage.

But if we consider the future expansion like using user allocated bitmaps,
new API's introduced for switch.opt won't become waste, I think, because we
need a structure to get and export bitmap addresses.


>>
>> In usual workload, the number of dirty pages varies a lot for each
>> iteration
>> and we should gain really a lot for relatively clean cases.
>
> Can you post such a test, for an idle large guest?

OK, I'll do!

>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab0IOQNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 12:13:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214Ab0IOQNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 12:13:35 -0400
Message-ID: <4C90F09F.9080307@redhat.com>
Date: Wed, 15 Sep 2010 18:13:19 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Bryan Donlan <bdonlan@gmail.com>
CC: Christopher Yeoh <cyeoh@au1.ibm.com>, linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH] Cross Memory Attach
References: <20100915104855.41de3ebf@lilo> <4C90A6C7.9050607@redhat.com> <AANLkTi=rmUUPCm212Sju-wW==5cT4eqqU+FEP_hX-Z_y@mail.gmail.com>
In-Reply-To: <AANLkTi=rmUUPCm212Sju-wW==5cT4eqqU+FEP_hX-Z_y@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/15/2010 04:46 PM, Bryan Donlan wrote:
> On Wed, Sep 15, 2010 at 19:58, Avi Kivity<avi@redhat.com>  wrote:
>
>> Instead of those two syscalls, how about a vmfd(pid_t pid, ulong start,
>> ulong len) system call which returns an file descriptor that represents a
>> portion of the process address space.  You can then use preadv() and
>> pwritev() to copy memory, and io_submit(IO_CMD_PREADV) and
>> io_submit(IO_CMD_PWRITEV) for asynchronous variants (especially useful with
>> a dma engine, since that adds latency).
>>
>> With some care (and use of mmu_notifiers) you can even mmap() your vmfd and
>> access remote process memory directly.
> Rather than introducing a new vmfd() API for this, why not just add
> implementations for these more efficient operations to the existing
> /proc/$pid/mem interface?

Yes, opening that file should be equivalent (and you could certainly 
implement aio via dma for it).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.


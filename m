Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303Ab0LVAzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 19:55:31 -0500
Received: from mail.lang.hm ([64.81.33.126]:41462 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab0LVAza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 19:55:30 -0500
Date: Tue, 21 Dec 2010 16:53:02 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Huang Ying <ying.huang@intel.com>
cc: David Howells <dhowells@redhat.com>, "Luck, Tony" <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "greg@kroah.com" <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [concept & "good taste" review] persistent store
In-Reply-To: <1292977616.8743.87.camel@yhuang-dev>
Message-ID: <alpine.DEB.2.00.1012211651000.27461@asgard.lang.hm>
References: <1292892072.8743.70.camel@yhuang-dev>  <1292813234.8743.66.camel@yhuang-dev>  <4d0662e511688484b3@agluck-desktop.sc.intel.com>  <AANLkTindPUkF7fCkdbqSstNHFjF3_7fEYh18nhQFx_AJ@mail.gmail.com>  <AANLkTim3OpjPysjdCLDuFgFOipmcxyr2ay5cvUAu5PHi@mail.gmail.com>
  <AANLkTinpYJddhgbf7=Pw_TtGrnWaC8fwo2xv1XRsT1w7@mail.gmail.com>  <AANLkTimA4x8oWyq71nOxB=Otp3Y0i3Kcu27DG0ajaXUG@mail.gmail.com>  <AANLkTinCG+E6ZzpeRqsJP+-qvNDQXW4VZFgJ1c-sTryL@mail.gmail.com>  <4D0BEE1F.7020008@zytor.com>  <AANLkTinwFt+KDKNEYP9MWQ7wGb9qk=E2Xa3RJB3+MJnN@mail.gmail.com>
  <AANLkTinoV_pL=Ygqq4qt4f8c+wsdc9r9K7rcJ58aHjD1@mail.gmail.com>  <AANLkTikhtWjFBQmA111Q+2JGRudrRNAmegGThMagr4vF@mail.gmail.com>  <20101219091752.GA16150@liondog.tnic>  <AANLkTi=9UZ5BYWo5xT=jh0upRP6PraH4S=t=tL49YRdr@mail.gmail.com>  <17027.1292841992@redhat.com>
   <32058.1292926258@redhat.com> <1292977616.8743.87.camel@yhuang-dev>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Dec 2010, Huang Ying wrote:

> On Tue, 2010-12-21 at 18:10 +0800, David Howells wrote:
>> Huang Ying <ying.huang@intel.com> wrote:
>>
>>>>> - for OOPS messages will not cause system panic, it will go to disk and
>>>>> will not use up the persistent storage.
>>>>
>>>> You can't guarantee that an oops didn't just kill your ability to actually
>>>> write your syslog to disk or out across the network.
>>>
>>> I do not need to guarantee that. If the OOPS message can not be written
>>> to disk, just keeping it in persistent storage, and that is the very
>>> value of persistent storage.  But for OOPS can go to disk safely, we do
>>> not need to waste persistent storage for it.
>>
>> My point is how do you know an oops message will actually manage to get to
>> disk?  There's a userspace program (syslogd) between the kernel log and the
>> disk or network.
>
> The user space program (syslogd) is in my big picture, it will guarantee
> an oops meesage actually go to disk via something like fsync.  After
> doing that, the user space program can erase the corresponding record in
> persistent storage to free the space.  So all in all, oops messages not
> causing system panic or disk error will go to disk eventually and being
> freed and will not use up the persistent storage.

almost nobody runs syslog with a fsync after each message anymore. the 
problem is that doing so reduced throughput so much that you ended up 
loosing more messages (and causing processes to block, resulting in 
user-visible problems) because the messages had to queue up for 
processing.

so if you want to record critical messages and be guaranteed that they are 
on disk, you will be needing a specific application, and not just using 
standard syslog.

David Lang

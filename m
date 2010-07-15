Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935041Ab0GOXnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 19:43:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37873 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935022Ab0GOXnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 19:43:04 -0400
Message-ID: <4C3F9CBB.3080300@zytor.com>
Date: Thu, 15 Jul 2010 16:41:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
References: <20100714222115.GA30122@Krystal>	<AANLkTikLG4xVYfvuMtbuzsqcnzo1ut4dFAm6piqy2Lh7@mail.gmail.com>	<AANLkTin21xBD-BFY4ZX2BPRFnT5-LkgGugvWsvTEP4Mr@mail.gmail.com>	<AANLkTil4LYSjS88P2CopOVi3Ty9pxwFPsaw0328KlPSu@mail.gmail.com>	<20100715183153.GA9276@Krystal>	<AANLkTilfXUtQznSzOmO9ecoaviIt62Hv6jdUOMSRLdrF@mail.gmail.com>	<AANLkTimAn0uMpeYKctO0qxM6nwbfev3RHARLZIbf991k@mail.gmail.com>	<20100715220117.GA1499@Krystal>	<AANLkTinL3S3iMSoP0fb6bxn9IY62OmytBtbqCKy9CZk2@mail.gmail.com>	<AANLkTinOTwnSNgwX7PnalhzwWMjwie0Xk_Lnrn_0bLzz@mail.gmail.com>	<20100715225844.GA25420@one.firstfloor.org>	<4C3F97A5.4020107@zytor.com> <AANLkTinLg2Xx0x6jrKkK_em6dA0cEfujnV3XIZ6I10jI@mail.gmail.com>
In-Reply-To: <AANLkTinLg2Xx0x6jrKkK_em6dA0cEfujnV3XIZ6I10jI@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2010 04:23 PM, Linus Torvalds wrote:
> On Thu, Jul 15, 2010 at 4:20 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 07/15/2010 03:58 PM, Andi Kleen wrote:
>>>> Why do we force IST use for NMI, btw? Maybe we shouldn't, and just use
>>>> the normal kernel stack mechanisms?
>>>
>>> If you don't use IST the SYSCALL entry is racy during the window
>>> when RSP is not set up yet (same for MCE etc.)
>>>
>>
>> Right, the kernel stack is not ready.
> 
> Well, it may not be ready for the _current_ NMI handler, but if we're
> going to do a stack switch in sw on NMI anyway... ?
> 

No, the problem is that without IST it'll try to drop the NMI stack
frame itself *on the user stack*.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


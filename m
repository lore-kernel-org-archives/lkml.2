Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934736Ab0GOUq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 16:46:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36081 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934699Ab0GOUq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 16:46:27 -0400
Message-ID: <4C3F7339.6070505@zytor.com>
Date: Thu, 15 Jul 2010 13:44:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
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
        Andi Kleen <andi@firstfloor.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
References: <AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com> <20100714170617.GB4955@Krystal> <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com> <20100714203940.GC22096@Krystal> <AANLkTinM0eFnreNB5l_6f20oSGBchqAtYPb57tM01kUB@mail.gmail.com> <20100714222115.GA30122@Krystal> <AANLkTikLG4xVYfvuMtbuzsqcnzo1ut4dFAm6piqy2Lh7@mail.gmail.com> <AANLkTin21xBD-BFY4ZX2BPRFnT5-LkgGugvWsvTEP4Mr@mail.gmail.com> <20100715164450.GC30989@Krystal> <AANLkTik4mdj3h16CU2GUQAQuG4yeAWFuZsqbPC0ra6Id@mail.gmail.com> <20100715173836.GA17376@Krystal>
In-Reply-To: <20100715173836.GA17376@Krystal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2010 10:38 AM, Mathieu Desnoyers wrote:
>>
>> Of course, if there is some trap that re-enables interrupts even if
>> the trap happened in an interrupt-disabled region, then that would
>> change things, but that would be a bad bug regardless (and totally
>> independently of any NMI issues). So in that sense it's a "could
>> happen", but it's something that would be a totally separate bug.
> 
> Yep, this kind of scenario would therefore be a bug that does not belong to the
> specific realm of nmis.
> 

Yes, the only specific issue here is NMI -> trap -> IRET -> [nested
NMI], which is what this whole thing is about.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


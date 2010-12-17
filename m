Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab0LQXOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 18:14:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40099 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab0LQXN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 18:13:57 -0500
Message-ID: <4D0BEE1F.7020008@zytor.com>
Date: Fri, 17 Dec 2010 15:11:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, greg@kroah.com,
        akpm@linux-foundation.org, ying.huang@intel.com,
        Borislav Petkov <bp@alien8.de>, David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [concept & "good taste" review] persistent store
References: <4d0662e511688484b3@agluck-desktop.sc.intel.com>	<AANLkTindPUkF7fCkdbqSstNHFjF3_7fEYh18nhQFx_AJ@mail.gmail.com>	<AANLkTim3OpjPysjdCLDuFgFOipmcxyr2ay5cvUAu5PHi@mail.gmail.com>	<AANLkTinpYJddhgbf7=Pw_TtGrnWaC8fwo2xv1XRsT1w7@mail.gmail.com>	<AANLkTimA4x8oWyq71nOxB=Otp3Y0i3Kcu27DG0ajaXUG@mail.gmail.com> <AANLkTinCG+E6ZzpeRqsJP+-qvNDQXW4VZFgJ1c-sTryL@mail.gmail.com>
In-Reply-To: <AANLkTinCG+E6ZzpeRqsJP+-qvNDQXW4VZFgJ1c-sTryL@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2010 03:08 PM, Tony Luck wrote:
> 
> Do we have any good models for "journals" ... apart from
> the console log?  Ying & I did talk about just using printk
> to drop all the saved information onto the console (with
> some sort of "previous" prefix on each line to make
> it easy to find, and to make sure that someone glancing
> at the messages wouldn't worry that that OOPs scrolling
> by was happening now).  But this seemed like a really bad
> idea (especially if someone has enough persistent store to
> capture all of __logbuf).
> 
> So the downside of "everything is a file" is that we don't
> have much infrastructure for things that don't look like
> files - and trying to build some results in some special
> custom tools being needed to access the data, which
> just makes things harder to use.
> 
> People trying to write to /dev/pstore will figure out quickly
> that you can't do that. There are no "ops" to make new files,
> directories, symlinks or even to rename existing ones. You
> can overwrite existing files (because I don't trap "open" to
> deny them write access - but the 0444 mode is supposed
> to be a visual clue to not do that).
> 

There are two models I can think of:

1. a file where the head is automatically dropped as space requires.
2. a filesystem where the oldest files are automatically reclaimed.

1 has been implemented in actual systems, 2 is kind of a logical extension.

	-hpa

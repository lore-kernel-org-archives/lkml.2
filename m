Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab0JAPWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 11:22:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50153 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932400Ab0JAPW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 11:22:29 -0400
Message-ID: <4CA5FC96.1030300@zytor.com>
Date: Fri, 01 Oct 2010 08:21:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, heukelum@fastmail.fm, tglx@linutronix.de,
        akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: gas 2.16 and assembly macros -- entry_64.S build failure
References: <201009152110.o8FLAJeJ015584@imap1.linux-foundation.org> <4C91F07E0200007800016B50@vpn.id2.novell.com> <20100916082816.GA25681@elte.hu> <4C91F3A30200007800016B64@vpn.id2.novell.com> <20100916101355.GA31458@elte.hu> <4C9219BC0200007800016C53@vpn.id2.novell.com> <4CA52AA5.5040402@zytor.com> <4CA5B7910200007800019F50@vpn.id2.novell.com>
In-Reply-To: <4CA5B7910200007800019F50@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2010 01:27 AM, Jan Beulich wrote:
>>>> On 01.10.10 at 02:26, "H. Peter Anvin" <hpa@zytor.com> wrote:
>> ... but that doesn't work with the macros like movq_cfi.  On those, we
> 
> Is that only because of the register names used as operands to
> movq_cfi etc not having the % specified right away? I don't think
> that is really needed, i.e. the % could go there rather than being
> added in the macro body - the .cfi_* directives are perfectly happy
> with having the prefix there (and I don't know why it was coded
> this way in the first place, as this made it less similar to the plain
> movq while I thought the goal was to keep the differences to a
> minimum).
> 

No, and in fact the problem that spurred this discussion was in the use
of immediates, not registers:

	pushq_cfi $(USER_DS)

Obviously we can't add the % register prefix, since pushq can take
either a register or an immediate (or, for that matter, a memory operand).

>> could argue that at least people won't put $ on them, but cpp will still
>> split them apart with spaces; this apparently causes problems at least
>> as soon as there is an expression more complicated than addition
>> involved (apparently plus signs are okay, but minus signs aren't!)
>>
>> I'm completely lost about how to deal with this.   We can't simply
>> defang the macros -- at least not in a way that is likely to *stay*
>> working -- and dropping the macros is seriously going to impact the
>> debuggability of the kernel.  One way, of course, is to simply declare
>> binutils 2.16 and 2.15.9x (which is apparently included in
>> RHEL/CentOS 4) to be broken beyond repair unless distros backport a fix,
>> and in many ways I think that is the preferred option, but I don't know
>> if that makes sense to others...
> 
> The other alternative, albeit disliked by Ingo, continues to be to use
> __stringify() on all non-trivial operands, which then wouldn't require
> suppressing CONFIG_AS_CFI for pre-2.17 binutils.

You should be taken out and shot for even thinking that, never mind
putting it in writing...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


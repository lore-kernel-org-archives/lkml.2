Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab1CNMU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 08:20:58 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:48997 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab1CNMU5 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Mon, 14 Mar 2011 08:20:57 -0400
Message-Id: <4D7E166C0200007800036451@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 14 Mar 2011 12:21:48 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <sedat.dilek@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, <amodra@gmail.com>,
        "H.J. Lu" <hjl.tools@gmail.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "binutils" <binutils@sourceware.org>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: PATCH: Add --size-check=[error|warning]
References: <AANLkTinDTyupNgZR-0izCWrpwOnE1wEcubn+M3o=Mgy2@mail.gmail.com>
 <4D7E095802000078000363D5@vpn.id2.novell.com>
 <AANLkTikUKE4xzf-NJtK3vMCQmNEYiAXZzi2vMZs9Zy4W@mail.gmail.com>
 <AANLkTimmi7A6cXo8BCHWtBDmauZD4_-dNjThpn1J9DkW@mail.gmail.com>
In-Reply-To: <AANLkTimmi7A6cXo8BCHWtBDmauZD4_-dNjThpn1J9DkW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 14.03.11 at 12:52, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> On Mon, Mar 14, 2011 at 12:38 PM, Sedat Dilek
> <sedat.dilek@googlemail.com> wrote:
>> [ Changing Alan's Email to valid <amodra@gmail.com> in CC ]
>>
>> On Mon, Mar 14, 2011 at 12:26 PM, Jan Beulich <JBeulich@novell.com> wrote:
>>>>>> On 14.03.11 at 12:02, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>> [...]
>>>> [2] Where can someone set a "global behaviour" (hardcoded options) for
>>>> his/her assembler in the kernel's build-system (speaking of
>>>> "--size-check=[error|warning]")?
>>>
>>> Nowhere, selecting behavior is possible only via the command line.
>>>
>>
>> Via command-line, something like this would do it?
>>
>>     $ export AS="/usr/bin/as --size-check=warning
>> [...]

No - $(AS) isn't being used to translate .S files, $(CC) is being used
instead. That's why I pointed at the necessary -B option (so that
the compiler would be able to locate the wrapper H.J. suggested).

> By looking through the binutils source-code, I have seen ASFLAGS.
> 
>      $ ASFLAGS="--size-check=warning" ; export ASFLAGS

Where did you find that? All places where I see references to this
variable are in the testsuite.

Jan


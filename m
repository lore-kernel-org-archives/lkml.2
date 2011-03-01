Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab1CAJiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 04:38:12 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:40245 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909Ab1CAJiK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Tue, 1 Mar 2011 04:38:10 -0500
Message-Id: <4D6CCC8D020000780003442F@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 01 Mar 2011 09:38:05 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Jeff Dike" <jdike@addtoit.com>, "Ingo Molnar" <mingo@elte.hu>
Cc: <heukelum@fastmail.fm>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [tip:x86/asm] x86-64: Add CFI annotations to
	 lib/rwsem_64.S
References: <4D6BCDFF02000078000341B0@vpn.id2.novell.com>
 <tip-39f2205e1abd1b6fffdaf45e1f1c3049a5f8999c@git.kernel.org>
 <20110228182642.GA7041@elte.hu>
 <4D6CBBD502000078000343DF@vpn.id2.novell.com>
 <20110301085630.GA16050@elte.hu>
In-Reply-To: <20110301085630.GA16050@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 01.03.11 at 09:56, Ingo Molnar <mingo@elte.hu> wrote:

> * Jan Beulich <JBeulich@novell.com> wrote:
> 
>> >>> On 28.02.11 at 19:26, Ingo Molnar <mingo@elte.hu> wrote:
>> 
>> > * tip-bot for Jan Beulich <JBeulich@novell.com> wrote:
>> > 
>> >> Commit-ID:  39f2205e1abd1b6fffdaf45e1f1c3049a5f8999c
>> >> Gitweb:     
>> > http://git.kernel.org/tip/39f2205e1abd1b6fffdaf45e1f1c3049a5f8999c 
>> >> Author:     Jan Beulich <JBeulich@novell.com>
>> >> AuthorDate: Mon, 28 Feb 2011 15:31:59 +0000
>> >> Committer:  Ingo Molnar <mingo@elte.hu>
>> >> CommitDate: Mon, 28 Feb 2011 18:06:21 +0100
>> >> 
>> >> x86-64: Add CFI annotations to lib/rwsem_64.S
>> >> 
>> >> These weren't part of the initial commit of this code.
>> >> 
>> >> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>> >> Cc: Alexander van Heukelum <heukelum@fastmail.fm>
>> >> LKML-Reference: <4D6BCDFF02000078000341B0@vpn.id2.novell.com>
>> >> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> >> ---
>> >>  arch/x86/lib/rwsem_64.S |   56 ++++++++++++++++++++++++++++------------------
>> >>  1 files changed, 34 insertions(+), 22 deletions(-)
>> > 
>> > this change breaks the UML build:
>> > 
>> >  tip/arch/um/sys-x86_64/../../x86/lib/rwsem_64.S:46: Error: no such 
>> > instruction: `pushq_cfi %rdi'
>> 
>> Any reason why arch/um/Kconfig.x86 has X86_32 but not
>> X86_64? That's resulting in asm/dwarf2.h producing the 32-bit
>> (pushl_cfi & Co) macros instead of the 64-bit ones. And I
>> wonder what other inconsistencies this may cause...
> 
> No idea - UML seems stale. I've Cc:-ed Jeff Dike just in case.
> 
>> If this is on purpose (i.e. simply adding X86_64 as a new config
>> option there isn't the right solution), what would be the preferred
>> way of fixing this in asm/dwarf2.h:
>> - #ifndef CONFIG_X86_32,
>> - #ifdef CONFIG_64BIT,
>> - yet something else?
> 
> You could try it out - UML isnt that hard to build: "make ARCH=um" and then 
> run the 
> resulting binary. It will produce bootup messages then fails when mounting 
> root. 
> That's enough of a build & functionality test.

That wasn't my question. What I wanted to know was, if adding
X86_64 to UML's Kconfig.x86 isn't acceptable for some reason,
whether any of the possible alternative forms would be preferred
(all of them should work).

Anyway, I'll wait for Jeff's response on whether adjusting the
UML file is going to be acceptable.

Will you want a re-submission or an incremental fix?

Jan


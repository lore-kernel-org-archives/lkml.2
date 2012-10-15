Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab2JOWSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 18:18:08 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:65060 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab2JOWSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 18:18:06 -0400
MIME-Version: 1.0
In-Reply-To: <201210152134.45672.arnd@arndb.de>
References: <1350065376-23353-1-git-send-email-fweisbec@gmail.com>
	<CAFTL4hzLtYZsc_JCVCGW2gWbxp5APgq8P7F-D+76kVOyrTKvRA@mail.gmail.com>
	<1350333581.19292.10.camel@pippen.local.home>
	<201210152134.45672.arnd@arndb.de>
Date: Tue, 16 Oct 2012 00:18:05 +0200
Message-ID: <CAFTL4hzcJz1GgG8g0=CBy07UAQTYm-_YnWCJD_eEobs4LLLoGA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] irq_work: Move irq_work_raise()
 declaration/default definition to arch headers
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/15 Arnd Bergmann <arnd@arndb.de>:
> On Monday 15 October 2012, Steven Rostedt wrote:
>> On Mon, 2012-10-15 at 22:23 +0200, Frederic Weisbecker wrote:
>> > 2012/10/15 Steven Rostedt <rostedt@goodmis.org>:
>> > > On Mon, 2012-10-15 at 17:11 +0100, Catalin Marinas wrote:
>> > > BTW, is there any rational reason that the include path lookup doesn't
>> > > just check for the files in include/asm-generic after looking in
>> > > arch/*/include/asm?
>> > >
>> > > Really, the best way would be just to add the default asm files into
>> > > include/asm-generic and be done with it. I hate the fact that we need to
>> > > touch every arch for every generic default file.
>> >
>> > Agreed. I'm including Arnd in the conversation.
>>
>> As David Howells is doing user space header work, I'll include him too.
>> Maybe someone can shed some light onto this.
>>
>
> A number of people have expressed the wish to do this through Makefile magic, but
> so far nobody has been able to come up with the right incantation.
>
> I've spent a day trying to figure it out, and I think Mark Brown tried some of
> the same things. It's probably not all that hard for someone who is more familiar
> with the Kbuild internals.

This seems to do the trick:

(It's the diff result of ln -s asm-generic include/asm)

diff --git a/include/asm b/include/asm
new file mode 120000
index 0000000..86e8787
--- /dev/null
+++ b/include/asm
@@ -0,0 +1 @@
+asm-generic/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab2DCIj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 04:39:29 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46183 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab2DCIj1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 04:39:27 -0400
MIME-Version: 1.0
In-Reply-To: <20120403073145.GB26826@gmail.com>
References: <20120401160229.4502.2541.stgit@shimauta> <4F7A21B6.8000700@zytor.com>
 <20120403073145.GB26826@gmail.com>
From: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Date: Tue, 3 Apr 2012 17:39:05 +0900
Message-ID: <CADyE4xHy83j6P177zQ9nKk95mfBTS83Aqy=mOe4-RsQeH-VPUg@mail.gmail.com>
Subject: Re: [RFC PATCH -tip 00/16] in-kernel x86 disassember
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/3 Ingo Molnar <mingo@kernel.org>:
>
> * H. Peter Anvin <hpa@zytor.com> wrote:
>
>> On 04/01/2012 09:02 AM, Masami Hiramatsu wrote:
>> > Hi,
>> >
>> > Here is a series of patches of the in-kernel x86 disassembler
>> > for the latest tip tree.
>> > This will show you a pretty disassembled code instead of
>> > just a digital code sequence when you gets a kernel panic etc.
>> > (I know, we also have script/decodecode for the panic use)
>> >
>> > This feature is not for users, but mainly for kernel developers
>> > who can understand disassembly code of x86 ;). This is just like
>> > a joke feature in kernel. (yeah, I spend my spare time for this.
>> > It's my fun :))
>> >
>>
>> This is cool, but I have one major reservation about it: it
>> will make kernel panics take a lot more screen real estate
>> without containing more information, and we already have
>> problems with things scrolling off way too easily.
>
> Yes, I'm not sure we want to do it by default.

Agreed.

>> For that reason I would like to request that this *only*
>> enabled by an explicit command-line option or similar
>> (disasm_oops, maybe?), so that the user has to opt-in.
>
> The existing oops setup knob is an early_param() in
> kernel/panic.c, "oops=".
>
> I'd suggesting extending that in an obvious way. Currently the
> only option that exists is "oops=panic", so a comma delimited
> list of attributes would be the natural extension, allowing:
>
>        oops=panic
>        oops=panic,disasm
>        oops=disasm
>
> Detail: it should do a strncmp(5, str, "disas"), so that every
> usual variant works: oops=disasm, oops=disassemble, etc.

OK, I'll add that.

>
>> [...]  In other words, if *you* are debugging your own kernel,
>> and don't expect to ship oopses off to someone else.
>
> Probably a DEBUG .config option as well, so that distros can
> enable it. OTOH, CONFIG_CMDLINE allows the setting of such
> parameters as well.

This would be good for other parameters, so I think it
should be separately done.

Thank you,

-- 
Masami Hiramatsu
mailto:masami.hiramatsu@gmail.com

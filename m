Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933963Ab2J3QFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:05:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21447 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335Ab2J3QFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:05:30 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=V3PaAaPhDywA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=MpoW4NFLMuQA:10 a=TjdZuqBtraRauxM7rlMA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351613128.8467.109.camel@gandalf.local.home>
Subject: Re: [PATCH] scripts/recordmcount.pl: Support build with
 -ffunction-sections.
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Newton <will.newton@gmail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Tue, 30 Oct 2012 12:05:28 -0400
In-Reply-To: <CAFbHwiRXzWpKjtu2jQzr_COuSLg=HNit-CfkTuArrzc+xP53Og@mail.gmail.com>
References: <CAFbHwiRtBaHkpZqTm6VZ=fCJcyu+dsdpo_kxMHy1egce=rTuyA@mail.gmail.com>
	 <1351609517.8467.85.camel@gandalf.local.home>
	 <CAFbHwiRXzWpKjtu2jQzr_COuSLg=HNit-CfkTuArrzc+xP53Og@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 15:35 +0000, Will Newton wrote:
> On Tue, Oct 30, 2012 at 3:05 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Tue, 2012-10-30 at 14:51 +0000, Will Newton wrote:
> >> Scan any text section whose name begins with ".text." so
> >> we will find all the functions in a kernel built with
> >> -ffunction-sections.
> >
> > A couple of things.
> >
> > First, I'm very paranoid about a blanket "ok" on sections. We must
> > guarantee that all sections that starts with ".text" never is freed. And
> > if it is freed, that it must inform ftrace that it's about to free it
> > before it does. If we can not guarantee this, then we can't do it.
> 
> I share that concern, however it looks like it should be safe. 

Can we confirm that it is safe. I'm not too confident with the words
"looks like" ;-)


> The two
> architectures in tree that enable -ffunction-sections by default are
> parisc and score and they both use a .text.* wildcard in their linker
> script. If the support for building with --gc-sections is ever
> completed then that would require -ffunction-sections and a similar
> wildcard to be applied to section names.

We need to make a way to guarantee any section that is added as ".text"
is never removed (freed), except for modules, which already have a way
to notify ftrace that its removing its text.

> 
> > Second, most archs today do not use recordmcount.pl. They use the new
> > recordmcount.c file.
> 
> Ok, thanks for letting me know. Is the plan to switch over to
> recordmcount.c exclusively at some point?

When all the archs convert.

> 
> The following architectures have some support in recordmcount.c but do
> not enable it:
> 
> sh, powerpc, ia64

Hmm, I have a powerpc, I should get that fixed.

> 
> And the following have no support in recordmcount.c as yet:
> 
> blackfin, microblaze

It's up to the arch maintainers to do the work. If the perl script is
good enough for them then I have no problem maintaining both. But I
don't have the machines to test these archs.

-- Steve



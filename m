Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab2JOVfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 17:35:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52699 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab2JOVfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 17:35:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 1/5] irq_work: Move irq_work_raise() declaration/default definition to arch headers
Date: Mon, 15 Oct 2012 21:34:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1350065376-23353-1-git-send-email-fweisbec@gmail.com> <CAFTL4hzLtYZsc_JCVCGW2gWbxp5APgq8P7F-D+76kVOyrTKvRA@mail.gmail.com> <1350333581.19292.10.camel@pippen.local.home>
In-Reply-To: <1350333581.19292.10.camel@pippen.local.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201210152134.45672.arnd@arndb.de>
X-Provags-ID: V02:K0:xgq6Y9efHSkbruSTRYO34VQ+uj1/btY03IAzyHiZO8t
 L7hx8usrLtrgj0jESuRZ/HNm44SK+SelVnHFS0JVoHy7P6xsJO
 qFGFsc6g2RJQxGaKBKQXwG4FTAVvxcQK8Jned1/v02vqoA0nAf
 g0JCHH6pKGgYzeCGJAgFWATpvRj7jENB1n4v/tLQMDCdICjAYa
 x6bUag0JwI0+0ZLwTjQWO7GjA5QFQbCSkexto8TCokehffSCSL
 5TNp41eAliSDES5IwRwAt6ONrhhO1cXP6/gZ+vV6yaETU/KihN
 Qwm1dEegitRo0u2yU7RkjMcjdkrFvYh50TN0gNU6y04lpiOTcs
 60trCcpBG62HQHiOyHvI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2012, Steven Rostedt wrote:
> On Mon, 2012-10-15 at 22:23 +0200, Frederic Weisbecker wrote:
> > 2012/10/15 Steven Rostedt <rostedt@goodmis.org>:
> > > On Mon, 2012-10-15 at 17:11 +0100, Catalin Marinas wrote:
> > > BTW, is there any rational reason that the include path lookup doesn't
> > > just check for the files in include/asm-generic after looking in
> > > arch/*/include/asm?
> > >
> > > Really, the best way would be just to add the default asm files into
> > > include/asm-generic and be done with it. I hate the fact that we need to
> > > touch every arch for every generic default file.
> > 
> > Agreed. I'm including Arnd in the conversation.
> 
> As David Howells is doing user space header work, I'll include him too.
> Maybe someone can shed some light onto this.
> 

A number of people have expressed the wish to do this through Makefile magic, but
so far nobody has been able to come up with the right incantation.

I've spent a day trying to figure it out, and I think Mark Brown tried some of
the same things. It's probably not all that hard for someone who is more familiar
with the Kbuild internals.

	Arnd

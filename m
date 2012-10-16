Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab2JPJZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 05:25:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60203 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab2JPJZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 05:25:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC PATCH 1/5] irq_work: Move irq_work_raise() declaration/default definition to arch headers
Date: Tue, 16 Oct 2012 09:25:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
References: <1350065376-23353-1-git-send-email-fweisbec@gmail.com> <CAFTL4hzcJz1GgG8g0=CBy07UAQTYm-_YnWCJD_eEobs4LLLoGA@mail.gmail.com> <20121016031240.GA4804@opensource.wolfsonmicro.com>
In-Reply-To: <20121016031240.GA4804@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210160925.11891.arnd@arndb.de>
X-Provags-ID: V02:K0:Rfg65/+kL+a1gRJFokV3lQpDoyGUfyJxfoFOj+HkEBH
 Rc7/2sV2ihe5KZ+xNbEk4oLFZVW6zOuFsGvREEWZlAMVazXxtV
 E0fGHLfbn5FOvnE1IKsQGXltykQlzer72jeWPcI7YuqsDHnOJh
 lX+oZ0M3ebZt4Ww9gOXmurjjCg6L6RxLk/7E2pd4bWla4rv8lB
 tjLVxYVioVxRWbUvf0xZCoJwPh7KBeU0X8WrCC+Sh083Wic/bB
 oQS7rrvPMLt6Wg2/Nrp1pSvJY/qoY4qm0aIwKET9RlMaDN86LS
 Acj5qLoRl+2Wi6xCT6ITEbZxAvXC7OctJQgnt3MLhz+SnP0DFb
 /DbuZmP1m3qk68nCb6ro=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 October 2012, Mark Brown wrote:
> On Tue, Oct 16, 2012 at 12:18:05AM +0200, Frederic Weisbecker wrote:
> 
> I came up with stuff for it, though it needed prettyfying.
> 
> > This seems to do the trick:
> 
> > (It's the diff result of ln -s asm-generic include/asm)

Unfortunately, this is not enough, it breaks "make headers_install",
which now needs to decide whether to install a header that is present
in the architecture directory, or to copy one from the asm-generic
directory otherwise.

On the plus side, the symlink breaks checking into CVS and cross-building
from operating systems that don't support posix file systems, so we
might want to do this anyway. ;-)

> That'd work, but I assume there is some reason why we've got this system
> of explicitly adding each file.  It's not like cpp can test for the
> presence of include files.  If we can't figure out why we're not doing
> this I'd propose we start.

We discussed renaming asm-generic to asm before, but some people objected
to the use of #include_next. There is a smaller problem with opening the
asm/*.h namespace to header files that are not relevant for architctures,
so I'd prefer to have a well-defined list of headers that are implicitly
shared, but it's not a technical argument.

	Arnd

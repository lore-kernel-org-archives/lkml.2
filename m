Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab1GEP0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 11:26:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42804 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab1GEP0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 11:26:14 -0400
Date: Tue, 5 Jul 2011 19:26:07 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Will Drewry <wad@chromium.org>, James Morris <jmorris@namei.org>,
        Chris Evans <scarybeasts@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, djm@mindrot.org,
        kees.cook@canonical.com, rostedt@goodmis.org, fweisbec@gmail.com,
        tglx@linutronix.de, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH v9 05/13] seccomp_filter: Document what seccomp_filter
 is and how it works.
Message-ID: <20110705152607.GA2484@albatros>
References: <1308875813-20122-1-git-send-email-wad@chromium.org>
 <1308875813-20122-5-git-send-email-wad@chromium.org>
 <BANLkTimtYUyXbZjWhjK61B_1WBXE4MoAeA@mail.gmail.com>
 <alpine.LRH.2.00.1106270919290.30367@tundra.namei.org>
 <BANLkTi=sB2R-gWM30a0KKSGXz5p7OHRfeA@mail.gmail.com>
 <alpine.LRH.2.00.1106301128590.13496@tundra.namei.org>
 <20110701115600.GK20990@elte.hu>
 <BANLkTim8CGx89nOg0HX=S1=arunBU3sEGQ@mail.gmail.com>
 <20110701130705.GG12605@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701130705.GG12605@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Fri, Jul 01, 2011 at 15:07 +0200, Ingo Molnar wrote:
> Have you addressed my basic objection of why we should go for a more 
> complex and less capable variant over a shared yet more capable 
> facility:
> 
>   http://lkml.kernel.org/r/20110526091518.GE26775@elte.hu
> 
> ?
> 
> You are pushing the 'filter engine' approach currently, not the 
> (much) more unified 'event filters' approach.

I'm sorry if my question was already addressed - I wasn't CC'ed to the
first series of the patch, I read some emails from lkml.org, so I might
miss something.

You're proposing the more generic solution than a more limited syscalls
filtering thing.  AFAIU, you're trying to merge different security
models like syscalls filtering, defining object policies, hardening,
etc.  This would be a something like a generic framework, which
will be used by specific models like syscalls filtering:

http://marc.info/?l=linux-kernel&m=130639834930092&w=2

I'm worried about one thing, one of important properties of all
*generic* things: what disadvantages would this framework have?  The
generic filtering engine might be:

1) Too slow if it can filter everything and supersets almost every
policy.

2) Too compicated in sense it exposes too much attack surface.  The latest
patch is rather simple to audit, but generic filters, as every generic
thing, is hard to properly audit.  Will mentioned that tracepoints code
is currently a bit complicated for this sort of things.  It is a
subjective point, but anyway.

3) Too complicated in sense of API/usage.  E.g. current SELinux policies
is too hard to configure properly for most of users, plenty of users
just use the predefined policies coming with distributions.  Would be
the "superset" more complicated?

4) Not "generic" enough.  Some awfully cool new security model invented
in 5 years will need some thing that cannot be added to the current
model without changing ABI or will need the full framework refactoring.
This would lead to reimplementing some already existing filters, but in
sense of this model desires.

(I don't claim that event filtering will end with these issues, surely
no, I'm merely asking about possible problems.)


On the contrary, the syscalls sandboxing clearly has potential users
like QEMU and daemons with privilege separation architecture, similar
(but more weak) model with namespaces separation is proven to work just
well.  The set of users is more or less understandable.  The
unprivileged process has a clearly defined set of permitted operations,
which can be enforced by syscalls inhibitions.  The code is simple
enough to audit.

Yes, this model has a limited set of users, but - hey! - every security
model with the same mission will be used only by restricted set of users.


Another perhaps naive question - how long should it take to bring the event
filtering code to the state when it is aleady useful at leasy for the
complete syscalls filtering?  (Will posted a list of issues that were
not addressed in his PoC because of proper API lacking.)  Wouldn't the
time frame be too large to spawn numerous users of not yet complete
solution, leading to the stalling with incomplete/nonscalabe ABI, which
would be worse than any particular speciality models?


Please don't take my words as an attack to your model, but an attempt to
clarify dark spots, which might be a real barrier of your mutual
understanding.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments

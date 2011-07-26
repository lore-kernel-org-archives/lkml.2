Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab1GZUam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 16:30:42 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38694 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab1GZUaj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 16:30:39 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyDufcXR62j=crthVkNybk5is+c-zzr+LRmj_QSUskfmg@mail.gmail.com>
References: <20110722125236.GA24832@elte.hu>
	<CACqU3MUW81UmBK7qBQCZRqzfosrukYM9=o0EZP_DvSjgywfK8g@mail.gmail.com>
	<1311588599.2617.56.camel@laptop>
	<CA+55aFwxqVXb0cFrkgdrDH4J_aF9J7iw8i6ypAda2HiAyeFYpw@mail.gmail.com>
	<20110725190444.GA8302@elte.hu>
	<CA+55aFyDufcXR62j=crthVkNybk5is+c-zzr+LRmj_QSUskfmg@mail.gmail.com>
Date: Tue, 26 Jul 2011 16:30:38 -0400
Message-ID: <CACqU3MWYCL0FC4z_=TEhaUauZHGjF-bnh5L0StfJMEvijwWOSQ@mail.gmail.com>
Subject: Re: [GIT PULL] core/locking changes for v3.1
From: Arnaud Lacombe <lacombar@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 25, 2011 at 3:48 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jul 25, 2011 at 12:04 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> ..
>> net/netfilter/nf_conntrack_core.c: In function ‘nf_conntrack_init’:
>> net/netfilter/nf_conntrack_core.c:1579:3: warning: the comparison
>> will always evaluate as ‘true’ for the address of
>> ‘nf_conntrack_attach’ will never be NULL [-Waddress]
>
> These all seem to be essentially compiler bugs.
>
> We have macros that do generic things (in this case
> "rcu_assign_pointer()" and tests their values. The fact that the tests
> sometimes end up being statically true (or false) is not something the
> compiler should complain about - it should use it to optimize the
> code.
>
> Sad.
>
I'm not sure that it is the compiler fault, or a limitation of the C
language which has no notion of templates and obliges people to do
convoluted hack mixing __typeof__ and macros.

I'd have been interested to use the 'auto' keyword in generic static
inlines declaration. Instead, we have to deal with __typeof__ and
macros, which have no real signification for the compiler itself, so
it cannot make the difference between a conditional in a macros, there
for genericity, and "real" code, where such a warning would be useful.

my 0.2 c.
 - Arnaud

> We can make a compiler bug-report, or disable -Waddress. Or maybe we
> can write the tests in a way that doesn't trigger the compiler bug.
>
> This same issue is why I hated -Wsign-compare. Some of the things gcc
> complained about were just technically moronic. So compiler warnings
> are not always a good thing.
>
>                  Linus
>

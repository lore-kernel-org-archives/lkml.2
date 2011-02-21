Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab1BUFWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 00:22:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39570 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1BUFWB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 00:22:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=qPsxFSW71Zg6svlOy3fRqWqjN6dgd+G74nQjnWzUzermmHdJNkc6ryDeWjpHTPNI+k
         XzbfhpQ4nmOnyjJ7ggpiCJhYsK390BtBwpuyBSkAz76zUjCSzIGRHAEm62FF1HvkXRKJ
         9QJvcABT3SZDXEWTJabgcZBVBxpRSY056z+zs=
MIME-Version: 1.0
In-Reply-To: <20110221043714.GA31194@liondog.tnic>
References: <1298219710-9846-1-git-send-email-bp@alien8.de>
	<20110220175709.GA5178@merkur.ravnborg.org>
	<20110220193906.GC6713@liondog.tnic>
	<20110220195222.GA12915@merkur.ravnborg.org>
	<20110221022316.GA18332@liondog.tnic>
	<AANLkTimZhB8Ong=nJ_mjit+VRtb7g+TQhT9_wvojQ0-e@mail.gmail.com>
	<20110221043714.GA31194@liondog.tnic>
Date: Mon, 21 Feb 2011 00:22:00 -0500
Message-ID: <AANLkTinO+3=4OmRq-vKXVbLV_jtMO45vN3LiY-omz21d@mail.gmail.com>
Subject: Re: [PATCH -v3] kbuild: Add extra gcc checks
From: Arnaud Lacombe <lacombar@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Arnaud Lacombe <lacombar@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        torvalds@linux-foundation.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Feb 20, 2011 at 11:37 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Sun, Feb 20, 2011 at 10:26:13PM -0500, Arnaud Lacombe wrote:
>
>> > The idea behind this option is targeted at developers who, in the
>> > process of writing their code, want to do the occasional
>> >
>> > make W=1 [target.o]
>> >
>> > and let gcc do more extensive code checking for them. Then, they
>> > could eyeball the output for valid gcc warnings about various
>> > bugs/discrepancies which are not reported during the normal build
>> > process.
>> >
>
> [..]
>
>> > +ifeq ("$(origin W)", "command line")
>> > +  KBUILD_ENABLE_EXTRA_GCC_CHECKS = 1
>> > +  export KBUILD_ENABLE_EXTRA_GCC_CHECKS
>> > +endif
>> > +
>> You never check CC is gcc. How can you assert this ?
>
> Hmm, I somehow knew that the other compilers are going to come into the
> discussion :).
>
>> Moreover, can you certify that all the compiler supported to build
>> Linux do support the set of new warnings ?
>
> Well, as you've probably already read in the commit message, this
> option is for devs only, in case they want to do a build-check whether
> the couple of lines they just added to a .c file trigger new compiler
> warnings. So, no, I cannot certify this and I don't have to - this is
> not meant for production use anyway.
>
People _will_ end up using it in production.

>> What about icc ?
>
> I don't know, is anyone using it to build the kernel?
then what would be the point of, say `include/linux/compiler-intel.h' ?

> Even if so, icc
> might have a completely different set of -W options (totally guessing
> here) so you shouldn't use 'make W=1' with it.
>

>> old gcc?
>
> Yes, cc-option should be used in that case, I'll redo the patch.
>
>> LLVM/clang ?
>
> Can you even build the kernel with it?
>
At first sight, partly[0].

> But to make sure we're on the realistic side of things.
Whose realistic side ? yours ? If not, are you speaking for all the
Linux community ? I do not think so.

> First of all,
> the purpose of this is to quickly get gcc scream out while building your
> changes. Secondly, let's face it, the majority of developers, if not
> all, use gcc the kernel code is full of gcc-isms so accomodating all
> the compilers to such a quick-and-dirty test option is just plain too
> much.
That's a statement I would not make. Lots of compiler dependent stuff
is buried in <linux/compiler.h> for a good reason.

> Look at it this way: it is cheaper to upgrade your dev environment
> than add unnecessary and ugly code to kbuild. Even the argument with
> older gcc versions cannot weigh in enough in favor of the cc-option -
> simply upgrade your gcc.
>
Do you speak for users, in the embedded world, of BSP whose supporting
company either went defunct or is no longer maintaining the toolchain
for a dark platform, or say an architecture, in kernel, which do not
have support in mainstream binutils and support's patches are tied
with a given version of binutils/gcc ?

 - Arnaud

[0]: http://lists.cs.uiuc.edu/pipermail/cfe-dev/2010-October/011711.html

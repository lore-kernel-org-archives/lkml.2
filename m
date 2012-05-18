Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab2ERQOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:14:08 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51408 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab2ERQOG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:14:06 -0400
MIME-Version: 1.0
In-Reply-To: <4FB67146.9080804@zytor.com>
References: <4FB67146.9080804@zytor.com>
Date: Fri, 18 May 2012 09:14:05 -0700
Message-ID: <CAMe9rOqp5AUNL7Oeb2fz=nFq6Z-=hdFg_T2kc+jwkYtzOKJv9g@mail.gmail.com>
Subject: Re: Urgent: x86-32 and GNU ld 2.22.52.0.1
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 8:56 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> I need an urgent opinion.  It seems we have an epic mess on our hands.
>
> GNU ld 2.22.52.0.1 silently changed the semantics of section-relative
> symbols that are part of otherwise empty sections, and silently changes
> them to absolute.  We rely on section-relative symbols staying
> section-relative, and actually have several sections in the linker
> script solely for this purpose.

That is I talked to you a couple days ago:

http://sourceware.org/bugzilla/show_bug.cgi?id=14052

> The postprocessor for the x86-32 kernel, relocs.c, currently doesn't
> enforce its audited absolute symbols list.  As part of the
> tip:x86/trampoline rework, however, I made it error out rather that
> silently producing bad output.
>
> Ingo has found that with this particular version of GNU ld, the error
> triggers.  I want to emphasize that this merely catches an error which
> the current version of the tool would have allowed to silently go by,
> which would have (possibly) caused a failure if the kernel was
> subsequently booted in anything but its default location.
>
> There are a few ways we can deal with this, but I think we need to do
> one or the other:
>
> 1. We can blacklist this version of GNU ld.

I think this is the best approach.

> 2. We can uprev the tool to the one from the tip:x86/trampoline work,
>   with error checking, and give it a list of symbols that should
>   be relative but may end up as absolute.  We risk build errors for
>   some people if the list isn't complete.
> 3. We do a minimal forward-port of the error checking into the current
>   tool.
> 4. We add to the list of relative symbols in the current version of
>   the tool without adding the error checking.
>
> However, since it seems clear that we're silently producing corrupt
> kernels out of the current build, I think we need a fix for this for 3.4.
>


-- 
H.J.

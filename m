Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab2LZWac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 17:30:32 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:55656 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab2LZWa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 17:30:28 -0500
Date: Wed, 26 Dec 2012 23:30:26 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: David Rientjes <rientjes@google.com>
cc: David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/build] x86: Default to ARCH= x86 to avoid overriding
 CONFIG_64BIT
In-Reply-To: <alpine.DEB.2.00.1212261343210.20193@chino.kir.corp.google.com>
Message-ID: <alpine.LNX.2.00.1212262323410.23814@swampdragon.chaosbits.net>
References: <1356040315.3198.51.camel@shinybook.infradead.org> <tip-ffee0de411fd4f74f3b788892eeb075abbf26c52@git.kernel.org> <alpine.DEB.2.00.1212252222450.24528@chino.kir.corp.google.com> <1356511396.7010.13.camel@shinybook.infradead.org>
 <alpine.DEB.2.00.1212260228200.10166@chino.kir.corp.google.com> <1356525527.7010.34.camel@shinybook.infradead.org> <alpine.DEB.2.00.1212261343210.20193@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1050518996-1356561026=:23814"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1050518996-1356561026=:23814
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 26 Dec 2012, David Rientjes wrote:

> On Wed, 26 Dec 2012, David Woodhouse wrote:
> 
> > > I'm sure it's a 32-bit issue, nothing has changed recently in auto-latest 
> > > related to these subsystems and I'm sure it's just because my randconfig 
> > > builds were exposed to this combination solely because of this patch.
> > 
> > Hm, that's an unexpected benefit of this patch. I didn't think it would
> > noticeably improve 'make randconfig' coverage of configs without
> > CONFIG_64BIT, because I thought enough people were doing such tests
> > already. But evidently I was wrong.
> > 
> 
> I do quite a bit of automated config and boot tests to try out 
> combinations that others may not have tested when developing their code; 
> staging branches such as in tip are interesting to try because they 
> haven't yet reached Linus and it's helpful to catch breakages before it 
> reaches mainline.
> 
> > We introduced 'make randconfig' as a tool to generate meaningless
> > configs just to test various permutations — to ensure that we got our
> > dependencies right both in Kconfig and the code itself. It was
> > artificially limiting its test coverage and thus we were failing to
> > discover real bugs. Now I've fixed that problem, and 'make randconfig'
> > is actually random and is thus doing its job even better than before.
> > Yay!
> > 
> 
> Umm, you're saying that is legitimate for "make randconfig" done on a 
> 32-bit machine to generate 64-bit configurations?  The resulting kernel 
> cannot be booted.  In the past, "make randconfig" would always generate a 
> kernel that _should_ boot on that machine unless there was an underlying 
> bug that should be fixed.
> 
...

Why would you assume a bootable kernel from 'randconfig'? I don't and 
never have. If we stick to X86, then you may get a kernel config without 
x387/emulator support - try to boot boot that on a 486sx. You may also get 
a config that does not contain the filesystem(s) you use, or without the 
driver for your main HD. You may also be out of luck with graphics 
drivers or support for your mouse/keyboard combo. etc etc.

In my view, randconfig was never about building bootable kernels, but all 
about building possible kernel config combinations - that may or may not 
boot on any given system.  The point was only to test that some 
combination of options did in fact build (if it also boots then all the 
better, but that was never part of the goal; as I saw it).

I may be wrong, but that was/is my expectations for 'randconfig'.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-1050518996-1356561026=:23814--

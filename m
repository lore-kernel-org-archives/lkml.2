Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab2L1NHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 08:07:36 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60386 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536Ab2L1NHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 08:07:33 -0500
Date: Fri, 28 Dec 2012 14:07:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: anish singh <anish198519851985@gmail.com>,
        amit mehta <gmate.amit@gmail.com>,
        Henrique Rodrigues <henriquesilvar@gmail.com>,
        kishore kumar <kishoreopen@gmail.com>,
        Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        linux-kernel@vger.kernel.org, Kernelnewbies@kernelnewbies.org
Subject: Re: how to look for source code in kernel
Message-ID: <20121228130734.GB13224@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	anish singh <anish198519851985@gmail.com>,
	amit mehta <gmate.amit@gmail.com>,
	Henrique Rodrigues <henriquesilvar@gmail.com>,
	kishore kumar <kishoreopen@gmail.com>,
	Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
	linux-kernel@vger.kernel.org, Kernelnewbies@kernelnewbies.org
References: <CA+8YGd6UqfbzEHOb2NUL5p3EF4OECVq7yc2vRV3GViVT64CTbQ@mail.gmail.com>
 <20121227184034.GA2982@debian.debian>
 <CABuSbKbk5DdhvuwYUeLkm=eub1CsSaOB_oX7bkBZcAV_MNsSdg@mail.gmail.com>
 <CAK7N6vpvLrAb=sZitaEBQ6Fx4K5ehGg+LTU70hiVK=1RdE4WwQ@mail.gmail.com>
 <CAOUxTKNgs4N-M5RR6YHyGeXQqRrg0_CJpxgT2OmN_buEP+jbjQ@mail.gmail.com>
 <CAK7N6vqw+DVSVaCXqiQBVa_d2o-rg-oA5t8+6WNaZ9Mb_iQqdw@mail.gmail.com>
 <87a9syhbma.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87a9syhbma.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 11:36:13PM -0800, Eric W. Biederman wrote:
> git-ls-files | xargs fgrep 'struct f2fs_inode'
> 
> That returns instantly and tells me where to look.  If you can do an
> instant brute force search what is the point of an index?

Not if you're using a lame-ass laptop with a rotating disk:

$ time git ls-files | xargs grep -E 'struct mce\W*{'
arch/x86/include/uapi/asm/mce.h:struct mce {
arch/x86/kernel/cpu/mcheck/mce.c:               if (!final || memcmp(m, final, sizeof(struct mce))) {

real    2m48.415s
user    0m2.388s
sys     0m15.668s

What I've grown accustomed to is cscope with a prior find run on the
kernel source tree to create a custom cscope.files which cscope uses to
index and then using vim bindings in cscope so that if, for example, the
cursor is on a function call, executing a keyboard shortcut opens the
definition of that function in another vim tab. I.e., a thin IDE done
right.

> My experience with gui editors is that they always hide something I
> need to see, or my code is just strange enough (say having asm file,
> or supporting multiple architectures) that the tools get horribly
> confused.

That's true, then I tend to use another xterm with tabbed vim showing
additional files. Btw, git ls-files assumes a source file is tracked by
git and in the seldom case where you're adding new, yet untracked files,
that won't work.

So probably a mixed approach of cscope in one window and grep + editor
in another would cover all bases. For a newbie who wants to only browse
the code, cscope should be enough for starters, I'd say.

Thanks.

-- 
Regards/Gruss,
Boris.

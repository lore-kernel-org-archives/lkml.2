Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab2L1WXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 17:23:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51265 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab2L1WXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 17:23:49 -0500
Date: Fri, 28 Dec 2012 23:23:34 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Borislav Petkov <bp@alien8.de>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        anish singh <anish198519851985@gmail.com>,
        amit mehta <gmate.amit@gmail.com>,
        Henrique Rodrigues <henriquesilvar@gmail.com>,
        kishore kumar <kishoreopen@gmail.com>,
        Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        linux-kernel@vger.kernel.org, Kernelnewbies@kernelnewbies.org
Subject: Re: how to look for source code in kernel
In-Reply-To: <20121228130734.GB13224@x1.alien8.de>
Message-ID: <Pine.LNX.4.64.1212282321370.2539@axis700.grange>
References: <CA+8YGd6UqfbzEHOb2NUL5p3EF4OECVq7yc2vRV3GViVT64CTbQ@mail.gmail.com>
 <20121227184034.GA2982@debian.debian> <CABuSbKbk5DdhvuwYUeLkm=eub1CsSaOB_oX7bkBZcAV_MNsSdg@mail.gmail.com>
 <CAK7N6vpvLrAb=sZitaEBQ6Fx4K5ehGg+LTU70hiVK=1RdE4WwQ@mail.gmail.com>
 <CAOUxTKNgs4N-M5RR6YHyGeXQqRrg0_CJpxgT2OmN_buEP+jbjQ@mail.gmail.com>
 <CAK7N6vqw+DVSVaCXqiQBVa_d2o-rg-oA5t8+6WNaZ9Mb_iQqdw@mail.gmail.com>
 <87a9syhbma.fsf@xmission.com> <20121228130734.GB13224@x1.alien8.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:F7buP0NO8XX6AMkGbobja0ycV9J5BeodscCDfWTPlR5
 D5CdCs/U0PHOQoX23cvKYL1sX0BmINK2YUxlDPEHAqUAI1KUxq
 z+TfGCj77NURWkFc9wUBFjOqGolJrls+VnUCBdWQWaVRoae4o+
 dgCYfEkn8Y6Wp3pP6FDPMhSQ9qB23PxHhaupPmre4bFo/lzoMi
 1JKBdadG+GhC2bR6q/eAfMcXN6YL64Tp+dOVnEqT6C0g/6XCn7
 BShsT06DLDsboDwOrxBRNjKX+tQeV9/lBGqAHfOU1XVbrN7Y7W
 nLXFWOxYN0yvmyxhgs/CKDQHh3WZfHCB+jwRZJXTdsGUAzMum0
 2+BueEmkEolEm2jw2myF3bw1Kz8HX/fXgouwcdd1WQ9qjgeQd5
 seGxj3u/gDKiQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Dec 2012, Borislav Petkov wrote:

> On Thu, Dec 27, 2012 at 11:36:13PM -0800, Eric W. Biederman wrote:
> > git-ls-files | xargs fgrep 'struct f2fs_inode'
> > 
> > That returns instantly and tells me where to look.  If you can do an
> > instant brute force search what is the point of an index?
> 
> Not if you're using a lame-ass laptop with a rotating disk:
> 
> $ time git ls-files | xargs grep -E 'struct mce\W*{'
> arch/x86/include/uapi/asm/mce.h:struct mce {
> arch/x86/kernel/cpu/mcheck/mce.c:               if (!final || memcmp(m, final, sizeof(struct mce))) {
> 
> real    2m48.415s
> user    0m2.388s
> sys     0m15.668s
> 
> What I've grown accustomed to is cscope with a prior find run on the
> kernel source tree to create a custom cscope.files which cscope uses to
> index and then using vim bindings in cscope so that if, for example, the
> cursor is on a function call, executing a keyboard shortcut opens the
> definition of that function in another vim tab. I.e., a thin IDE done
> right.

...same works with TAGS under emacs, the only annoying problem with it 
since "recently" (about half a year or more) is that "make TAGS" is 
spewing out tons of

etags: Unmatched ( or \( while compiling pattern

oh well, looks like noone is using it / noone cares enough...

Thanks
Guennadi

> 
> > My experience with gui editors is that they always hide something I
> > need to see, or my code is just strange enough (say having asm file,
> > or supporting multiple architectures) that the tools get horribly
> > confused.
> 
> That's true, then I tend to use another xterm with tabbed vim showing
> additional files. Btw, git ls-files assumes a source file is tracked by
> git and in the seldom case where you're adding new, yet untracked files,
> that won't work.
> 
> So probably a mixed approach of cscope in one window and grep + editor
> in another would cover all bases. For a newbie who wants to only browse
> the code, cscope should be enough for starters, I'd say.
> 
> Thanks.
> 
> -- 
> Regards/Gruss,
> Boris.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

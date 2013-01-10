Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab3AJL7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 06:59:46 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60368 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab3AJL7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 06:59:44 -0500
Date: Thu, 10 Jan 2013 12:59:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7u1 20/31] x86, kexec: replace ident_mapping_init and
 init_level4_page
Message-ID: <20130110115942.GC23008@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-21-git-send-email-yinghai@kernel.org>
 <20130104210114.GA11611@x1.alien8.de>
 <CAE9FiQV+AF=Ltz7os-f+Ksvt14VXqMvCR4neO07J+_ubpkzVgw@mail.gmail.com>
 <20130105132447.GD4297@x1.alien8.de>
 <CAE9FiQUZcbysdtmdnbnrciqaYqfbX8EkS_-FX_w2zvEe=w33QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQUZcbysdtmdnbnrciqaYqfbX8EkS_-FX_w2zvEe=w33QQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 05:26:18PM -0800, Yinghai Lu wrote:
> I should say:
> 
> that *is* initialized to false by default.
> 
> please check
> 
> http://stackoverflow.com/questions/10828294/c-and-c-partial-initialization-of-automatic-structure

Ok, I didn't know that, thanks for pointing it out.

And yet, this is not the point - the point is that this code is
complicated enough as it is so why not make the easy things trivial so
that people looking at it months or even years from now can still try to
understand it.

So what it is defined by the standard?! Just add that line anyway! Then
there's no need to go check what was meant. This way it is *there*,
*explicit* and everyone *knows* what is meant - even people who don't
sleep with C99std under their pillow.

It is not like we're saving code since the mov $0 gets issued by the
compiler anyway when it is on the stack:

	movq	$0, -48(%rbp)	#, info
	movq	$0, -40(%rbp)	#, info
	movq	$0, -32(%rbp)	#, info
	movq	$0, -24(%rbp)	#, info

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

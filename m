Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279Ab2J0UR1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 16:17:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933171Ab2J0UR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 16:17:26 -0400
Date: Sun, 28 Oct 2012 01:46:50 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: Kees Cook <keescook@chromium.org>
cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-fsdevel@vger.kernel.org, halfdog <me@halfdog.net>
Subject: Re: [PATCH] exec: do not leave bprm->interp on stack
In-Reply-To: <CAGXu5j+JdbehZK1KXHMZGJ8_d10Z25oDQ7V=J3OGXKmF-=wg6Q@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1210272337550.22424@wniryva.cad.erqung.pbz>
References: <20121024232032.GA31129@www.outflux.net> <20121025041620.GH2616@ZenIV.linux.org.uk> <CAGXu5jLwvcpyMp8RcF8aFySKkkj+17ovNOvC_r88+D0fQW7CsQ@mail.gmail.com> <alpine.LFD.2.02.1210251636480.23155@wniryva.cad.erqung.pbz> <20121025120952.GI2616@ZenIV.linux.org.uk>
 <20121025123843.GJ2616@ZenIV.linux.org.uk> <alpine.LFD.2.02.1210262242310.6224@wniryva.cad.erqung.pbz> <20121026183601.GR2616@ZenIV.linux.org.uk> <alpine.LFD.2.02.1210271450570.15637@wniryva.cad.erqung.pbz>
 <CAGXu5j+JdbehZK1KXHMZGJ8_d10Z25oDQ7V=J3OGXKmF-=wg6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+-- On Sat, 27 Oct 2012, Kees Cook wrote --+
| Al showed a list of them earlier in the thread.

  Yeah, the list Al showed and I came across mostly has - binfmt_aout - entry. 
Do people still use - a.out - format? (considering ELF has been the default 
standard for so many years)

| I don't have any on the various distros I checked.

  Same here, my F17 machine has no entries for binfmt-xxxx modules, in fact I 
don't even have the /etc/modprobe.d/aliases.conf file.

Documentation/binfmt_misc.txt talks about executing Java, Python, DOSEMU and 
Windows programs which could be supported by loadable modules.

| The problem I see here is that we only want to do module loading in the "no 
| match" case. But that means that either we need to restart with the original 
| bprm, or we need to keep bprm changes off the stack. Leading with a module 
| load is going to wreck performance.  

  I beg to *slightly* differ here. I agree we currently have a small overhead 
of find_module() -> request_module() only when binfmt_xxxx module is already 
loaded, partly because find_module can not resolve aliases.

I guess this small overhead is worth it if it helps to make things less 
confusing and easy to follow. Besides this overhead does not exist for regular 
executables ELFs and scripts alike.

If the required module is missing, a call to request_module() will anyway 
happen and its cost remains the same whether it happens before or after the 
"match".

Thank you.
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B

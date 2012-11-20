Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab2KTHEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:04:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab2KTHEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:04:51 -0500
Date: Tue, 20 Nov 2012 12:34:30 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@javelin.pnq.redhat.com
To: Kees Cook <keescook@chromium.org>
cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-fsdevel@vger.kernel.org, halfdog <me@halfdog.net>
Subject: Re: [PATCH] exec: do not leave bprm->interp on stack
In-Reply-To: <CAGXu5jKY90dsnUjLcjC43Djoe53HEAffugtaEfsBphtp7j_A7g@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1211201200390.5842@wniryva.cad.erqung.pbz>
References: <20121024232032.GA31129@www.outflux.net> <20121025123843.GJ2616@ZenIV.linux.org.uk> <alpine.LFD.2.02.1210262242310.6224@wniryva.cad.erqung.pbz> <20121026183601.GR2616@ZenIV.linux.org.uk> <alpine.LFD.2.02.1210271450570.15637@wniryva.cad.erqung.pbz>
 <CAGXu5j+JdbehZK1KXHMZGJ8_d10Z25oDQ7V=J3OGXKmF-=wg6Q@mail.gmail.com> <alpine.LFD.2.02.1210272337550.22424@wniryva.cad.erqung.pbz> <CAGXu5jJNZH4fQ6U197+A0nJeawHk+8yNnQj+mKft65L9o6_z7A@mail.gmail.com> <alpine.LFD.2.02.1211061332470.18031@wniryva.cad.erqung.pbz>
 <CAGXu5j+ObQAPBruUGpM2Vu_Fr91dNwdmy=ryJ2bOmm18qJEWnQ@mail.gmail.com> <alpine.LFD.2.02.1211161804520.16891@wniryva.cad.erqung.pbz> <CAGXu5jLQxmTvpELQQNX7C4-N8c73p99uYkx5GHvnuOgMhMph0Q@mail.gmail.com> <alpine.LFD.2.02.1211182211350.5012@wniryva.cad.erqung.pbz>
 <CAGXu5jJ4ZuviFMQcFocLWfcMreZSt4kCHFNm-PNW+yuy+v+FiQ@mail.gmail.com> <alpine.LFD.2.02.1211191158550.5042@wniryva.cad.erqung.pbz> <CAGXu5jKY90dsnUjLcjC43Djoe53HEAffugtaEfsBphtp7j_A7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+-- On Mon, 19 Nov 2012, Kees Cook wrote --+
| I don't think you're being rude at all. You're defending your solution. :)

  Thank you Kees, really appreciate it.
 
| However, it also changes the conditions for when a module is loaded
| (i.e. 0x7f no longer triggers a module_load, so anything needing that
| would break -- I'm not sure if this really qualifies for ABI breakage,
| I don't use any obscure binfmt modules so I can't say).

   Ah right.
 
| And, most importantly, it triggers request_module for any binary with
| unprintables that binfmt_misc may already handle (for example, the
| very common case of handling DOS MZ files, which only define 2 bytes
| as magic (MZ) and exampes I find show things like "@\x00" trailing it,
| or JAR files which are PK\x03\x04). Which means each exec of these
| kinds of files would trigger a needless request_module() call on every
| exec.

   Hmmn...true.
 
| Both the interp-on-heap patch and this proposed ELOOP patch are needed
| to handle the case of binfmt_script and/or binfmt_misc being modules
| (first binfmt walk fails with -ENOEXEC, loads binfmt_script, retries
| loop, hits binfmt_script rewriting interp to a PE file, recurses,
| fails with -ENOEXEC, loads binfmt_misc via a modalias for PE files,
| retries loop, hits binfmt_misc rewriting interp to an ELF, recurses,
| loads ELF, happiness). Without the heap patch, we could be pointing
| into old stack (rewritten e.g. during module load or taking an
| interrupt, etc) on the loop retries. Without the ELOOP patch, the
| recursion could explode with an abusive script chain.

  I see! Thanks so much for explaining Kees, I appreciate it.

Thank you.
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B

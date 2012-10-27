Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353Ab2J0RFL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 13:05:11 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56015 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2J0RFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 13:05:04 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1210271450570.15637@wniryva.cad.erqung.pbz>
References: <20121024232032.GA31129@www.outflux.net>
	<20121025041620.GH2616@ZenIV.linux.org.uk>
	<CAGXu5jLwvcpyMp8RcF8aFySKkkj+17ovNOvC_r88+D0fQW7CsQ@mail.gmail.com>
	<alpine.LFD.2.02.1210251636480.23155@wniryva.cad.erqung.pbz>
	<20121025120952.GI2616@ZenIV.linux.org.uk>
	<20121025123843.GJ2616@ZenIV.linux.org.uk>
	<alpine.LFD.2.02.1210262242310.6224@wniryva.cad.erqung.pbz>
	<20121026183601.GR2616@ZenIV.linux.org.uk>
	<alpine.LFD.2.02.1210271450570.15637@wniryva.cad.erqung.pbz>
Date: Sat, 27 Oct 2012 10:05:03 -0700
X-Google-Sender-Auth: 1zSC-WndOKqVO9xaBso5ylSeG0k
Message-ID: <CAGXu5j+JdbehZK1KXHMZGJ8_d10Z25oDQ7V=J3OGXKmF-=wg6Q@mail.gmail.com>
Subject: Re: [PATCH] exec: do not leave bprm->interp on stack
From: Kees Cook <keescook@chromium.org>
To: P J P <ppandit@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-fsdevel@vger.kernel.org, halfdog <me@halfdog.net>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2012 at 3:47 AM, P J P <ppandit@redhat.com> wrote:
> +-- On Fri, 26 Oct 2012, Al Viro wrote --+
> | > not. Module alias could dodge this though, I guess.
> | "Could"?  Can you show a single module that would have name matching
> | binfmt-[0-9a-f]*?  In other words, are they ever loaded _not_ via an
> | alias?
>
>   I understand. I was wondering if alias information is accessible in the
> kernel via any routine, alike find_module().
>
> Just to get perspective about how many times request_module() would be called
> with the latest patch, in general installations(or distributions), how
> prevalent(in use) are binfmt-xxxx loadable modules?

Al showed a list of them earlier in the thread. I don't have any on
the various distros I checked.

The problem I see here is that we only want to do module loading in
the "no match" case. But that means that either we need to restart
with the original bprm, or we need to keep bprm changes off the stack.
Leading with a module load is going to wreck performance.

-Kees

-- 
Kees Cook
Chrome OS Security

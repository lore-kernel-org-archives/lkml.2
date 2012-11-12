Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab2KLWKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 17:10:53 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40879 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2KLWKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 17:10:51 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1211061332470.18031@wniryva.cad.erqung.pbz>
References: <20121024232032.GA31129@www.outflux.net>
	<20121025041620.GH2616@ZenIV.linux.org.uk>
	<CAGXu5jLwvcpyMp8RcF8aFySKkkj+17ovNOvC_r88+D0fQW7CsQ@mail.gmail.com>
	<alpine.LFD.2.02.1210251636480.23155@wniryva.cad.erqung.pbz>
	<20121025120952.GI2616@ZenIV.linux.org.uk>
	<20121025123843.GJ2616@ZenIV.linux.org.uk>
	<alpine.LFD.2.02.1210262242310.6224@wniryva.cad.erqung.pbz>
	<20121026183601.GR2616@ZenIV.linux.org.uk>
	<alpine.LFD.2.02.1210271450570.15637@wniryva.cad.erqung.pbz>
	<CAGXu5j+JdbehZK1KXHMZGJ8_d10Z25oDQ7V=J3OGXKmF-=wg6Q@mail.gmail.com>
	<alpine.LFD.2.02.1210272337550.22424@wniryva.cad.erqung.pbz>
	<CAGXu5jJNZH4fQ6U197+A0nJeawHk+8yNnQj+mKft65L9o6_z7A@mail.gmail.com>
	<alpine.LFD.2.02.1211061332470.18031@wniryva.cad.erqung.pbz>
Date: Mon, 12 Nov 2012 14:10:50 -0800
X-Google-Sender-Auth: pgf4b3P4XSUS45EI47abPBnkVWE
Message-ID: <CAGXu5j+ObQAPBruUGpM2Vu_Fr91dNwdmy=ryJ2bOmm18qJEWnQ@mail.gmail.com>
Subject: Re: [PATCH] exec: do not leave bprm->interp on stack
From: Kees Cook <keescook@chromium.org>
To: P J P <ppandit@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-fsdevel@vger.kernel.org, halfdog <me@halfdog.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 12:10 AM, P J P <ppandit@redhat.com> wrote:
>
>   Hello Kees, Al,
>
> +-- On Sat, 27 Oct 2012, Kees Cook wrote --+
> | If we change binfmt_script to not make a recursive call, then we still
> | need to keep the interp change somewhere off the stack. I still think
> | my patchset is the least bad.
> |
> | Al, do you have something else in mind?
>
>   Guys, are there any updates further?
>
>   Al, what's your take on the *rare* extra call to request_module?

Without any other feedback, I'd like to use my minimal allocation
patch, since it fixes the problem and doesn't change any of the
semantics of how/when loading happens.

-Kees

-- 
Kees Cook
Chrome OS Security

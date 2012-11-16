Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab2KPSAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:00:38 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:41620 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab2KPSAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:00:36 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1211161804520.16891@wniryva.cad.erqung.pbz>
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
	<CAGXu5j+ObQAPBruUGpM2Vu_Fr91dNwdmy=ryJ2bOmm18qJEWnQ@mail.gmail.com>
	<alpine.LFD.2.02.1211161804520.16891@wniryva.cad.erqung.pbz>
Date: Fri, 16 Nov 2012 10:00:35 -0800
X-Google-Sender-Auth: tzLIYYkJIQMckPQs6tH2JRobrCk
Message-ID: <CAGXu5jLQxmTvpELQQNX7C4-N8c73p99uYkx5GHvnuOgMhMph0Q@mail.gmail.com>
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

On Fri, Nov 16, 2012 at 4:50 AM, P J P <ppandit@redhat.com> wrote:
>
>   Hello folks,
>
> +-- On Mon, 12 Nov 2012, Kees Cook wrote --+
> | >   Al, what's your take on the *rare* extra call to request_module?
> |
> | Without any other feedback, I'd like to use my minimal allocation
> | patch, since it fixes the problem and doesn't change any of the
> | semantics of how/when loading happens.
>
>   I did apply and test this patch with kernel-3.5.3 on my machine. Now it
> seems to disclose dynamically allocated(kstrdup) bytes, instead of the call
> stack bytes. Recursions still dodge and exceed the limit of
> BINPRM_MAX_RECURSION(4).
>
> Please pardon my asking, but - how is this a fix?

Hrm? It should be showing only the live heap-allocated interp -- are
you seeing uninitialized contents?

-Kees

-- 
Kees Cook
Chrome OS Security

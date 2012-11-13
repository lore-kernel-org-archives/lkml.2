Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab2KMGy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 01:54:26 -0500
Received: from ext190.halfdog.net ([88.116.147.190]:53290 "EHLO
	mail.halfdog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab2KMGyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 01:54:24 -0500
Message-ID: <50A1EDA3.7000704@halfdog.net>
Date: Tue, 13 Nov 2012 06:50:11 +0000
From: halfdog <me@halfdog.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:19.0) Gecko/19.0 Firefox/19.0 SeaMonkey/2.16a1
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: P J P <ppandit@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] exec: do not leave bprm->interp on stack
References: <20121024232032.GA31129@www.outflux.net> <20121025041620.GH2616@ZenIV.linux.org.uk> <CAGXu5jLwvcpyMp8RcF8aFySKkkj+17ovNOvC_r88+D0fQW7CsQ@mail.gmail.com> <alpine.LFD.2.02.1210251636480.23155@wniryva.cad.erqung.pbz> <20121025120952.GI2616@ZenIV.linux.org.uk> <20121025123843.GJ2616@ZenIV.linux.org.uk> <alpine.LFD.2.02.1210262242310.6224@wniryva.cad.erqung.pbz> <20121026183601.GR2616@ZenIV.linux.org.uk> <alpine.LFD.2.02.1210271450570.15637@wniryva.cad.erqung.pbz> <CAGXu5j+JdbehZK1KXHMZGJ8_d10Z25oDQ7V=J3OGXKmF-=wg6Q@mail.gmail.com> <alpine.LFD.2.02.1210272337550.22424@wniryva.cad.erqung.pbz> <CAGXu5jJNZH4fQ6U197+A0nJeawHk+8yNnQj+mKft65L9o6_z7A@mail.gmail.com> <alpine.LFD.2.02.1211061332470.18031@wniryva.cad.erqung.pbz> <CAGXu5j+ObQAPBruUGpM2Vu_Fr91dNwdmy=ryJ2bOmm18qJEWnQ@mail.gmail.com>
In-Reply-To: <CAGXu5j+ObQAPBruUGpM2Vu_Fr91dNwdmy=ryJ2bOmm18qJEWnQ@mail.gmail.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Kees Cook wrote:
> On Tue, Nov 6, 2012 at 12:10 AM, P J P <ppandit@redhat.com> wrote:
>> 
>> Hello Kees, Al,
>> 
>> +-- On Sat, 27 Oct 2012, Kees Cook wrote --+ | If we change
>> binfmt_script to not make a recursive call, then we still | need
>> to keep the interp change somewhere off the stack. I still think 
>> | my patchset is the least bad. | | Al, do you have something
>> else in mind?
>> 
>> Guys, are there any updates further?
>> 
>> Al, what's your take on the *rare* extra call to request_module?
> 
> Without any other feedback, I'd like to use my minimal allocation 
> patch, since it fixes the problem and doesn't change any of the 
> semantics of how/when loading happens.

As a first step, I think that we can go with the Keess'
(nice/small/simple) patch. On the long run, exec should be reworked. Not
only interp is modified, also credentials are set, e.g. when using
"ping" as interpreter. With intransparent error handling and
retry-logic, this might be a future local-root-exploit in the beginning
(I tried to, but did not manage yet).


Also a remark from Prasad Pandit did not make it to the list (or at
least I missed the replies).

> Yesterday, while testing Keess' patch I was reading through
> execve(2) manual which says: path name must be a valid executable
> which is NOT a script.
> 
> $ man execve ... Interpreter scripts An interpreter script is a
> text file that has execute permission enabled and whose first line
> is of the form:
> 
> #! interpreter [optional-arg]
> 
> The interpreter must be a valid path name for an executable which
> is not itself a script.

Does someone know what POSIX says about that? I guess that interp
recursion might have some usecases: Script uses interp, but interp was
wrapped by admin or distribution folks into another script to fix
something, e.g. to pass an additional arg.

hd

- -- 
http://www.halfdog.net/
PGP: 156A AE98 B91F 0114 FE88  2BD8 C459 9386 feed a bee
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlCh7ZEACgkQxFmThv7tq+4X/QCeLN+0qUtP6Hhag1d4iwZ4PZbL
evEAn2iPQH9mJ0zTHMs3qOsaWLRs9UWW
=Ow3u
-----END PGP SIGNATURE-----

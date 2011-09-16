Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab1IPQyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 12:54:16 -0400
Received: from ext190.halfdog.net ([88.116.147.190]:60531 "EHLO
	mail.halfdog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359Ab1IPQyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 12:54:13 -0400
X-Greylist: delayed 998 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Sep 2011 12:54:13 EDT
Message-ID: <4E737B16.2090104@halfdog.net>
Date: Fri, 16 Sep 2011 16:36:38 +0000
From: halfdog <me@halfdog.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110904 Firefox/7.0 SeaMonkey/2.4
MIME-Version: 1.0
To: Ryan Mallon <rmallon@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Mark Salter <msalter@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Pass correct length to strnlen_user in fs/exec.c
References: <4E680EBC.4000804@gmail.com> <20110908165213.6ebd844f.akpm@linux-foundation.org> <4E695784.7020303@gmail.com>
In-Reply-To: <4E695784.7020303@gmail.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ryan Mallon wrote:

>> ...
> That's fine. I originally went looking after a discussion with
> Mark about the weird strnlen_user semantics  and this usage looked
> incorrect to me because it wasn't obviously checking >=
> MAX_ARG_STRLEN.
> 
> The rework I think makes it a bit more clear and passes the correct
> max length to strnlen_user. Its a bit odd to pass MAX_ARG_STRLEN
> and then check if it is longer than bprm->len, and I guess assumes
> that bprm->len is less than MAX_ARG_STRLEN.
> 
> Feel free to drop the patch if you think it is just churn.

As you are already busy with fs/exec.c and strnlen_user, could you
please check, if the timerace (argv/envp corruption) using
strnlen_user could also be fixed within the same patch (if bug still
in kernel). See

https://bugzilla.kernel.org/show_bug.cgi?id=39222

The race occurs when one thread issues exec while another one with
shared memory pages is flipping char/0-bytes of the args or envptrs,
causing random split (number greater maxargs - no problem, silently
droped)/fusion (greater MAX_ARG_STRLEN - might harm dumb programs) or
removal of all args including program name on top of new stack when
calling via binfmt handlers (might have influenced old ldlinux/libc
pre 2009?? when handling suid binaries)

Kind Regards,
Roman

- -- 
http://www.halfdog.net/
PGP: 156A AE98 B91F 0114 FE88  2BD8 C459 9386 feed a bee
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFOc3tJxFmThv7tq+4RAibwAJ9CmDTlODxFuNR4KrSh9PGjgyXxQwCfeIgo
ARy24fJ6DxuKmcPNla6f0lE=
=h1TA
-----END PGP SIGNATURE-----

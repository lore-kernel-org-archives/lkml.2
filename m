Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab3ACBRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 20:17:04 -0500
Received: from ozlabs.org ([203.10.76.45]:38564 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab3ACBQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 20:16:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        jonathon@jonmasters.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-man@vger.kernel.org
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
In-Reply-To: <CAHO5Pa29_=3HNLG-qtULZ2fmkgPJ6JCZ0LTv9m=UowfvFufhMw@mail.gmail.com>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org> <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com> <50749DE8.7010703@zytor.com> <CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com> <5074A0AB.8040207@zytor.com> <87d30o7iy6.fsf@rustcorp.com.au> <CAKgNAkh=99=x1=8Y=3odem-fXc9zEEbLvCc0WQku5Kyso4qHuQ@mail.gmail.com> <87ipa8o4mn.fsf@rustcorp.com.au> <CAKgNAkiVxUiqJ1pYNq3wW_yQxcyhqntUzcEWscFOhJ3GaVn1aQ@mail.gmail.com> <87sj97hs5e.fsf@rustcorp.com.au> <CAHO5Pa29_=3HNLG-qtULZ2fmkgPJ6JCZ0LTv9m=UowfvFufhMw@mail.gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 03 Jan 2013 10:42:24 +1030
Message-ID: <87fw2j5dlj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk <mtk.manpages@gmail.com> writes:
> Hi Rusty,

Hi Michael,

> The description here is rather thin. Could you supply a sentence or
> two for each of MODULE_INIT_IGNORE_MODVERSIONS and
> MODULE_INIT_IGNORE_VERMAGIC that would be suitable for the manual
> page?
>
> Thanks,

There are one or two safety checks built into a module, which are
checked to match the kernel on module load.  The first is a "vermagic"
string containing the kernel version number and prominent features (such
as CPU type).  If the module was built with CONFIG_MODVERSIONS set, a
version hash is recorded for each symbol the module uses based on the
types it refers to: in this case, the kernel version number within the
"vermagic" string is ignored, as the symbol version hashes are assumed
to be sufficiently reliable.

Using the MODULE_INIT_IGNORE_VERMAGIC flag indicates that the vermagic
is to be ignored, and the MODULE_INIT_IGNORE_MODVERSIONS flag indicates
that the version hashes are to be ignored.  If the kernel is built to
permit such forced loading (ie. CONFIG_MODULE_FORCE_LOAD is set) then
loading will continue, otherwise it will fail with ENOEXEC as expected
for malformed modules.

Hope that is more usable?

Thanks,
Rusty,

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab2JNUx7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 16:53:59 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44114 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab2JNUx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 16:53:57 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyGuy8P4Uaanmv7DncjsN6cvQxvWrrMKKnF=67J+BkshQ@mail.gmail.com>
References: <87fw5m7ipz.fsf@rustcorp.com.au> <CA+55aFyGuy8P4Uaanmv7DncjsN6cvQxvWrrMKKnF=67J+BkshQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 14 Oct 2012 13:53:36 -0700
X-Google-Sender-Auth: uLCtLU52ao8D2EKYPbSRfh4m-PA
Message-ID: <CA+55aFyVcTT4tKTVvhzXz3t4uw=MDLU00NAAOacWt6i3xovERg@mail.gmail.com>
Subject: Re: [PULL] modules
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Alex Lyashkov <umka@cloudlinux.com>,
        Arnd Bergmann <arnd@arndb.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Josh Boyer <jwboyer@redhat.com>, linux-crypto@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Milan Broz <mbroz@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 1:11 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I've pulled and resolved the branch, and I'm going through it now, but
> I'd like this verified before I push out if it all looks fine..

Hmm. So this thing makes me wonder:

        /* Not having a signature is only an error if we're strict. */
        if (err < 0 && fips_enabled)
                panic("Module verification failed with error %d in FIPS mode\n",
                      err);

do we really want to panic (even in fips_enabled mode)?

Sounds like it will just kill the machine if we ever end up having an
unsigned module by mistake anywhere.

I realize that fips_enabled is only for crazy people, but it's exactly
code like this that limits it to only crazy people. Is there some
*reason* for this?

                 Linus

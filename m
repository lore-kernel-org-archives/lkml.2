Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab2JOHvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 03:51:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab2JOHvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 03:51:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+55aFyVcTT4tKTVvhzXz3t4uw=MDLU00NAAOacWt6i3xovERg@mail.gmail.com>
References: <CA+55aFyVcTT4tKTVvhzXz3t4uw=MDLU00NAAOacWt6i3xovERg@mail.gmail.com> <87fw5m7ipz.fsf@rustcorp.com.au> <CA+55aFyGuy8P4Uaanmv7DncjsN6cvQxvWrrMKKnF=67J+BkshQ@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephan Mueller <stephan.mueller@atsec.com>
Cc: dhowells@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Alex Lyashkov <umka@cloudlinux.com>, Arnd Bergmann <arnd@arndb.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Josh Boyer <jwboyer@redhat.com>, linux-crypto@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Milan Broz <mbroz@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: FIPS-mode panic? (was Re: [PULL] modules)
Date: Mon, 15 Oct 2012 08:50:54 +0100
Message-ID: <15269.1350287454@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Hmm. So this thing makes me wonder:
> 
>         /* Not having a signature is only an error if we're strict. */
>         if (err < 0 && fips_enabled)
>                 panic("Module verification failed with error %d in FIPS mode\n",
>                       err);
> 
> do we really want to panic (even in fips_enabled mode)?

That's what the FIPS people want.  As I understand it, if there's some
indication that the crypto stuff is compromised, the box should be shut down
immediately.

I've added Stephan Mueller to see if he can illuminate further.

David

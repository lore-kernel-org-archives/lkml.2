Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab2JSAjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 20:39:10 -0400
Received: from ozlabs.org ([203.10.76.45]:60016 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809Ab2JSAjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 20:39:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>
Cc: David Howells <dhowells@redhat.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        pjones@redhat.com
Subject: Re: RFC: sign the modules at install time
In-Reply-To: <CA+55aFy677k6zvkc9n_2e6OEmOx-S1AYbOumkUOSkrE8Q+aUKw@mail.gmail.com>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com> <3179.1350512382@warthog.procyon.org.uk> <CA+55aFzEH1jguw8NB90si2uxvyO63FuKPOc8wiEPRCYwruSzRg@mail.gmail.com> <87a9vko0z7.fsf@rustcorp.com.au> <20121018121154.GE2934@hansolo.jdub.homelinux.org> <CA+55aFy677k6zvkc9n_2e6OEmOx-S1AYbOumkUOSkrE8Q+aUKw@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 19 Oct 2012 10:50:30 +1030
Message-ID: <87txtrpb1t.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
> So signing is the nice flexible option, and technically the right
> thing to do.

Meh.... It's 52k of extra text to get that 'nice flexible'; 1% of my
kernel image.  That's a lot of bug free code.

> (Side note: I hope people realize that the random key is generated
> with a 100-year lifespan. So if you build a kernel today, you do
> potentially have a "year-2112 problem". I'm not horribly worried, but
> I *am* a bit worried about 32-bit time_t overflow and I hope 32-bit
> openssl doesn't do anything odd)

Yep, David's original patch had that problem; he fixed the kernel's x509
handling to use struct tm, not time_t, and now it Just Works.

Cheers,
Rusty.

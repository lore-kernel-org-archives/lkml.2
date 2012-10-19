Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758513Ab2JSLWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 07:22:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab2JSLWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 07:22:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <87txtrpb1t.fsf@rustcorp.com.au>
References: <87txtrpb1t.fsf@rustcorp.com.au> <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com> <3179.1350512382@warthog.procyon.org.uk> <CA+55aFzEH1jguw8NB90si2uxvyO63FuKPOc8wiEPRCYwruSzRg@mail.gmail.com> <87a9vko0z7.fsf@rustcorp.com.au> <20121018121154.GE2934@hansolo.jdub.homelinux.org> <CA+55aFy677k6zvkc9n_2e6OEmOx-S1AYbOumkUOSkrE8Q+aUKw@mail.gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        pjones@redhat.com
Subject: Re: RFC: sign the modules at install time
Date: Fri, 19 Oct 2012 12:21:46 +0100
Message-ID: <2140.1350645706@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> wrote:

> > (Side note: I hope people realize that the random key is generated
> > with a 100-year lifespan. So if you build a kernel today, you do
> > potentially have a "year-2112 problem". I'm not horribly worried, but
> > I *am* a bit worried about 32-bit time_t overflow and I hope 32-bit
> > openssl doesn't do anything odd)
> 
> Yep, David's original patch had that problem; he fixed the kernel's x509
> handling to use struct tm, not time_t, and now it Just Works.

That's assuming that 32-bit *openssl* gets it right when generating the key.
Trying it on my 32-bit laptop, I see:

  154:d=3  hl=2 l=  15 prim: GENERALIZEDTIME   :21120925112014Z

so I guess it does.

David

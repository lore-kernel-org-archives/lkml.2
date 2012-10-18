Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab2JRMMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 08:12:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab2JRMMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 08:12:03 -0400
Date: Thu, 18 Oct 2012 08:11:54 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        pjones@redhat.com
Subject: Re: RFC: sign the modules at install time
Message-ID: <20121018121154.GE2934@hansolo.jdub.homelinux.org>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
 <3179.1350512382@warthog.procyon.org.uk>
 <CA+55aFzEH1jguw8NB90si2uxvyO63FuKPOc8wiEPRCYwruSzRg@mail.gmail.com>
 <87a9vko0z7.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9vko0z7.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 03:01:08PM +1030, Rusty Russell wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> > On Wed, Oct 17, 2012 at 3:19 PM, David Howells <dhowells@redhat.com> wrote:
> >>
> >> It's probably even better to just get rid of all the automatic module signing
> >> stuff completely and leave the sign-file script for the builder to use
> >> manually.  The module verification code will still be present.
> >
> > That's just disgusting crazy talk.
> >
> > Christ, David, get a grip on yourself. You seem to dismiss the "people
> > want to build their own kernel" people entirely.
> >
> > One of the main sane use-cases for module signing is:
> >
> >  - CONFIG_CHECK_SIGNATURE=y
> >  - randomly generated one-time key
> >  - "make modules_install; make install"
> >  - "make clean" to get rid of the keys.
> >  - reboot.
> >
> > and now you have a custom kernel that has the convenience of modules,
> > yet is basically as safe as a non-modular build. The above makes it
> > much harder for any kind of root-kit module to be loaded, and
> > basically entirely avoids one fundamental security scare of modules.
> 
> If you only want this, we could SHA all the built modules, put that in
> the kernel, and verify the module being loaded matches one of them.
> 
> Sure, it means a bit of trickery to get the module sums into the
> bzImage, but the rest is trivial.

It also excludes out-of-tree drivers.  I wouldn't personally shed a tear
for them, but it eliminates a use-case that people could have if we just
stuck to the signed module approach.

I'd prefer if we just cleaned up what we already have.

josh

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab2JRAyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 20:54:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62515 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab2JRAyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 20:54:36 -0400
Date: Wed, 17 Oct 2012 17:54:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jwboyer@redhat.com, pjones@redhat.com
Subject: Re: RFC: sign the modules at install time
Message-ID: <20121018005432.GA20163@kroah.com>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
 <3179.1350512382@warthog.procyon.org.uk>
 <CA+55aFzEH1jguw8NB90si2uxvyO63FuKPOc8wiEPRCYwruSzRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzEH1jguw8NB90si2uxvyO63FuKPOc8wiEPRCYwruSzRg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 03:44:28PM -0700, Linus Torvalds wrote:
> On Wed, Oct 17, 2012 at 3:19 PM, David Howells <dhowells@redhat.com> wrote:
> >
> > It's probably even better to just get rid of all the automatic module signing
> > stuff completely and leave the sign-file script for the builder to use
> > manually.  The module verification code will still be present.
> 
> That's just disgusting crazy talk.
> 
> Christ, David, get a grip on yourself. You seem to dismiss the "people
> want to build their own kernel" people entirely.
> 
> One of the main sane use-cases for module signing is:
> 
>  - CONFIG_CHECK_SIGNATURE=y
>  - randomly generated one-time key
>  - "make modules_install; make install"
>  - "make clean" to get rid of the keys.
>  - reboot.

I want that too, but right now 'make clean' leaves the keys around,
which seems a bit dangerous to me.

David, why aren't the keys cleaned up as well?  Was that on purpose or
just an oversight?

thanks,

greg k-h

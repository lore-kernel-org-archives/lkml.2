Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab2JRRQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:16:39 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33009 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336Ab2JRRQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:16:38 -0400
Date: Thu, 18 Oct 2012 10:16:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jwboyer@redhat.com, pjones@redhat.com
Subject: Re: RFC: sign the modules at install time
Message-ID: <20121018171628.GD23278@kroah.com>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
 <3179.1350512382@warthog.procyon.org.uk>
 <CA+55aFzEH1jguw8NB90si2uxvyO63FuKPOc8wiEPRCYwruSzRg@mail.gmail.com>
 <20121018005432.GA20163@kroah.com>
 <CA+55aFxo-b3nUAWhG0N7hJkH1goStvBBTCT7XWGD+RJLG0=fsQ@mail.gmail.com>
 <877gqoo0tp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gqoo0tp.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 03:04:26PM +1030, Rusty Russell wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> > On Wed, Oct 17, 2012 at 5:54 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >>>
> >>> One of the main sane use-cases for module signing is:
> >>>
> >>>  - CONFIG_CHECK_SIGNATURE=y
> >>>  - randomly generated one-time key
> >>>  - "make modules_install; make install"
> >>>  - "make clean" to get rid of the keys.
> >>>  - reboot.
> >>
> >> I want that too, but right now 'make clean' leaves the keys around,
> >> which seems a bit dangerous to me.
> >
> > Oh, yes, we should make sure the key file gets cleaned up at "make clean".
> 
> I left it at distclean, figuring the temporary key is a bit like the
> .config.  But it's trivial to change if people think that's unnatural.

.config is user-generated, while the key is build-generated.  I assumed
that 'make clean' would clean up anything the build created, but as
Linus points out, the docs say that we will have enough stuff around to
build a module, so I guess it makes sense in that case.

Oh, along those lines, should the keys really end up in the root of the
kernel source tree?  keys/ perhaps?  But this is really just
bikesheding, that's up to you and David, it's not my code to maintain :)

thanks,

greg k-h

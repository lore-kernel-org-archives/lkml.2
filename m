Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525Ab2AIWyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:54:52 -0500
Received: from ozlabs.org ([203.10.76.45]:47272 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933412Ab2AIWyv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:54:51 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Jon Masters <jcm@redhat.com>, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: [PATCH] modules: sysfs - export: taint, address, size
In-Reply-To: <CAPXgP12rUUYfRy6QB5Z4Rwdday3hNHubCsSRY4gMDYuQGs3oJg@mail.gmail.com>
References: <1325951076.860.2.camel@mop> <871ur99vzf.fsf@rustcorp.com.au> <CAPXgP12rUUYfRy6QB5Z4Rwdday3hNHubCsSRY4gMDYuQGs3oJg@mail.gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 10 Jan 2012 09:14:14 +1030
Message-ID: <87zkdw7ayp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jan 2012 13:44:52 +0100, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Mon, Jan 9, 2012 at 08:27, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > The else here is weird.  Shouldn't we leave the exclusion elsewhere?
> 
> You mean the 'else if ... TAINT_OOT_MODULE'?  It's a one-to-one copy
> of the current code, which just moved up a bit.
> 
> Disconnect the two flags form each other?

Yes, I think so.

> > This copies a past mistake, and is definitely wrong.  Either expose both
> > pointers and sizes, or don't include init_size here.  Sure, it'll
> > normally be 0, but if not it's confusing...
> 
> Ah, good to know, mod->init_size is 0 for all modules here, so we
> should just drop mod->init_size and maybe name the 'size' attribute to
> 'coresize'?

If a module is still initializing, mod->init_size may well be non-zero.
Let's rename it to coresize, and add initsize.

> > But the bigger question is: Why are we exposing these sizes?
> > /proc/modules did since 2.2, or before, but that doesn't make it the
> > best option...
> 
> Good question, I doubt it is too useful, it's just that 'lsmod' shows
> it, so we wanted to show too.

And breaking lsmod output might kill some scripts.  So it stays.

Let's drop the address stuff though.

We can actually do something more radical: we could change the kernel to
call modprobe to resolve unresolved symbols.  We already support
symbol:<symbol> for symbol_request().

This means that modprobe still needs to maintain a sym->mod mapping
(though I would argue depmod should be moved into the kernel source),
but not any dependency mapping.

Thanks,
Rusty.

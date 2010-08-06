Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935271Ab0HFC16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 22:27:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935257Ab0HFC1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 22:27:55 -0400
MIME-Version: 1.0
In-Reply-To: <11274.1281061410@redhat.com>
References: <23662.1281056463@redhat.com> <20100806011706.GA21657@gondor.apana.org.au> 
	<20100806014057.GA22395@gondor.apana.org.au> <AANLkTi=+-Y2GOZYAZHeaX+op3XB9AY5S85rfJD3jSDvz@mail.gmail.com> 
	<11274.1281061410@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Aug 2010 19:27:33 -0700
Message-ID: <AANLkTi=SzuEtnbZNk1KuOdXqp+e6rQ3C7R-9=J00LNrE@mail.gmail.com>
Subject: Re: Initcall ordering problem (TTY vs modprobe vs MD5) and cryptomgr 
	problem
To: David Howells <dhowells@redhat.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 7:23 PM, David Howells <dhowells@redhat.com> wrote:
>
> I wonder if tty_init() should be moved up, perhaps to immediately after
> chrdev_init().

I do think that sounds sane. The tty layer is kind of special.

I wouldn't call it _after_ chrdev_init(), though, I'd call it _from_
chrdev_init(). Doesn't that make more sense (and keep it out of
fs/dcache.c, which is an odd place to have some tty init).

But maybe there's some reason why it's an initcall. Unlikely.

             Linus

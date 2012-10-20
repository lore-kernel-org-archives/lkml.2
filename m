Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2JTQsI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 12:48:08 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35533 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab2JTQsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 12:48:06 -0400
MIME-Version: 1.0
In-Reply-To: <874nlpksdr.fsf@silenus.orebokech.com>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
 <3179.1350512382@warthog.procyon.org.uk> <CA+55aFzEH1jguw8NB90si2uxvyO63FuKPOc8wiEPRCYwruSzRg@mail.gmail.com>
 <87a9vko0z7.fsf@rustcorp.com.au> <20121018121154.GE2934@hansolo.jdub.homelinux.org>
 <CA+55aFy677k6zvkc9n_2e6OEmOx-S1AYbOumkUOSkrE8Q+aUKw@mail.gmail.com> <874nlpksdr.fsf@silenus.orebokech.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 20 Oct 2012 09:47:43 -0700
X-Google-Sender-Auth: 89UXH6YGGopdnDtWUGcTqVbEzXI
Message-ID: <CA+55aFz=N4K3vLmfZ_p6hiNti8C04q5nCUo=4SPtk=9GwT+=Tg@mail.gmail.com>
Subject: Re: RFC: sign the modules at install time
To: Romain Francoise <romain@orebokech.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        pjones@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2012 at 9:41 AM, Romain Francoise <romain@orebokech.com> wrote:
>
> Yes, however the key generation itself is horribly verbose and doesn't mix
> very well with the output of a parallel build. Now that the modules are
> signed at install time, presumably the key should be generated then as
> well, and the output cleaned up to look like normal Kbuild messages (with
> support for V=1 for the curious).

No, the key needs to be built before the kernel is built, since the
public part (for verification) needs to be built into the kernel (and
we don't want to make "make install" complicated).

Making it less verbose is clearly an option, though. Right now I like
seeing it just to see when the key gets recreated and so people are
aware of it, but the excitement of that will certainly pall quickly
enough ;)

               Linus

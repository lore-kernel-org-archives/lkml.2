Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab2JQXpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 19:45:18 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46996 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab2JQXpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 19:45:16 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyO=GUQjY2vik=t2ntPJ4AQNYFFAhPuYyHbrZwFrwoQig@mail.gmail.com>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
 <CA+5PVA7nio3D2sivVV6h7_gHEsehhMb5_Y=GTwsov3dEmkhtUQ@mail.gmail.com>
 <CA+55aFw0q-QMPJj2KZrawUZa9ikR85SiB2nUFmBKcWQtfeLbSA@mail.gmail.com>
 <CA+5PVA5TRAo7zu--_jd7yAqsSVHH9pdxkPh4v=rtfXTZVub0Zg@mail.gmail.com> <CA+55aFyO=GUQjY2vik=t2ntPJ4AQNYFFAhPuYyHbrZwFrwoQig@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 17 Oct 2012 16:44:54 -0700
X-Google-Sender-Auth: lXiw_ka9-K9K6APVcX1vFohN0eU
Message-ID: <CA+55aFzv=Kaa7e2jReyuJq-X7BTpSjS8V2D02y5exc_r2ZM_3w@mail.gmail.com>
Subject: Re: RFC: sign the modules at install time
To: Josh Boyer <jwboyer@gmail.com>
Cc: David Miller <davem@davemloft.net>, Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 4:25 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> It really should work fine with the much simplified module-signing
> rules too.

Actually, my "much simplified modules-install" is a bit broken.

It worked for me last time (I'm running that kernel and modules now),
but I  just triggered a

  INSTALL Documentation/connector/cn_test.ko
  Can't read Signer name

error.

My patch is broken, and I simplified a bit *too* much. In particular
the .signer and .keyid logic got thrown out with the bathwater.

I just hadn't noticed until I did a "git clean", because the old
signer/keyid files had stayed around, hiding the breakage.

I'll send out a fixed patch asap,

            Linus

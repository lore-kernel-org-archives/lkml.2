Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab2JQXZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 19:25:44 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43767 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab2JQXZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 19:25:43 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA5TRAo7zu--_jd7yAqsSVHH9pdxkPh4v=rtfXTZVub0Zg@mail.gmail.com>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
 <CA+5PVA7nio3D2sivVV6h7_gHEsehhMb5_Y=GTwsov3dEmkhtUQ@mail.gmail.com>
 <CA+55aFw0q-QMPJj2KZrawUZa9ikR85SiB2nUFmBKcWQtfeLbSA@mail.gmail.com> <CA+5PVA5TRAo7zu--_jd7yAqsSVHH9pdxkPh4v=rtfXTZVub0Zg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 17 Oct 2012 16:25:21 -0700
X-Google-Sender-Auth: vNt20RXL5JshZMXBGLA4SFkVDtA
Message-ID: <CA+55aFyO=GUQjY2vik=t2ntPJ4AQNYFFAhPuYyHbrZwFrwoQig@mail.gmail.com>
Subject: Re: RFC: sign the modules at install time
To: Josh Boyer <jwboyer@gmail.com>
Cc: David Miller <davem@davemloft.net>, Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 4:20 PM, Josh Boyer <jwboyer@gmail.com> wrote:
>
> Debuginfo is run on the installed tree ($RPM_BUILD_ROOT), not the
> object tree.  It's how RPM works.  It kind of has to because it should
> only create debuginfo files for files that are actually installed by
> the RPM.

Yeah, I just read your blog post, and sent a suggested "here's how it works".

It really should work fine with the much simplified module-signing
rules too. Yes, you may want to add a "make module-sign" target to
*re*-sign modules after you've mucked with them, but you don't really
even need that. You could just as easily just do the re-signing
directly.

The point being that I'm pretty sure you really don't need that odd
dance at modpost time. And having "make modules_install" sign the
modules it installs (unstripped, for your use case) actually works for
the rpm package too.

                                Linus

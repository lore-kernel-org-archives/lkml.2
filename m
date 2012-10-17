Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab2JQXH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 19:07:59 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64310 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab2JQXH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 19:07:58 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA7nio3D2sivVV6h7_gHEsehhMb5_Y=GTwsov3dEmkhtUQ@mail.gmail.com>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
 <CA+5PVA7nio3D2sivVV6h7_gHEsehhMb5_Y=GTwsov3dEmkhtUQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 17 Oct 2012 16:07:36 -0700
X-Google-Sender-Auth: 6W97hk5tJU4Z8NduRsH_V2ErOW8
Message-ID: <CA+55aFw0q-QMPJj2KZrawUZa9ikR85SiB2nUFmBKcWQtfeLbSA@mail.gmail.com>
Subject: Re: RFC: sign the modules at install time
To: Josh Boyer <jwboyer@gmail.com>
Cc: David Miller <davem@davemloft.net>, Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 3:26 PM, Josh Boyer <jwboyer@gmail.com> wrote:
>
> The downside is that it won't work for distros.  Or at least the distros
> using RPM's debuginfo subpackage mechanism.

Hmm. It *should* work for them too, because the debuginfo modules stay
around in the object tree, and never get stripped there. None of this
is different from what we used to do before: we stripped the modules
as we copied them to /lib/modules (where the RPM build obviously would
have that $RPM_BUILD_ROOT prefix on the module install path).

Anyway, I seriously think that the kernel build should worry about
*users*, not about the distro building their binaries. And I do think
the current mess is unacceptable (following the insane
"stripped->extra stripping->signed->potentially stripped *again* at
install time" code was just insane). I may not have reacted as much as
David to the actual build having slowed down, but having looked at the
makefiles, there really is no excuse for that mess.

                      Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab2JREmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 00:42:07 -0400
Received: from ozlabs.org ([203.10.76.45]:38521 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab2JREmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 00:42:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@gmail.com>
Cc: David Miller <davem@davemloft.net>, David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RFC: sign the modules at install time
In-Reply-To: <CA+55aFyxuHTbqFHKoZ4Pqy28ivfginONowvfF0P9ctdiLmVqng@mail.gmail.com>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com> <CA+5PVA7nio3D2sivVV6h7_gHEsehhMb5_Y=GTwsov3dEmkhtUQ@mail.gmail.com> <CA+55aFw0q-QMPJj2KZrawUZa9ikR85SiB2nUFmBKcWQtfeLbSA@mail.gmail.com> <CA+55aFyxuHTbqFHKoZ4Pqy28ivfginONowvfF0P9ctdiLmVqng@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 18 Oct 2012 15:11:04 +1030
Message-ID: <874nlso0in.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
>    Ta-daa, you have your debuginfo modules installed, and they are
> signed. Create the debuginfo rpm.
>
>  - now, strip the modules. This obviously destroys the signatures

Note this doesn't remove them.  You'll need something like:

 dd if=$k of=$k.nosig bs=$(grep -cba $k '~Module signature appended~' | cut -d: -f1) count=1 && mv $k.nosig $k

Cheers,
Rusty.

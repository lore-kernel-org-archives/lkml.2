Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab2DERxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 13:53:55 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50676 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab2DERxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 13:53:54 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyMO=xx0xNvggR-1fs-jKi_zaayNfgCa3HCNkvH0yA16g@mail.gmail.com>
References: <1333569554.864.3.camel@mop> <CA+55aFyMO=xx0xNvggR-1fs-jKi_zaayNfgCa3HCNkvH0yA16g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Apr 2012 10:53:27 -0700
X-Google-Sender-Auth: YBHhRn9406Wx7eJzv03jbIAt6Q0
Message-ID: <CA+55aFxdvzhGOyA6SN-TcSvuKGyTAUWuDXEiVkpGPEBAZ7uHsg@mail.gmail.com>
Subject: Re: [PATCH] printk: support structured and multi-facility log messages
To: Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 5, 2012 at 10:09 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> If you want to escape something, you escape NUL and special characters
> using the standard *text* escaping mechanisms, not using some random
> hodge-podge that you just made up.

Btw, we could certainly add more support for escaping into vsnprintf() itself.

For example, we already do all those nice helpers for converting
different forms of common binary data into ascii: "%pU" for uuid's,
'%pS' for symbol addresses etc.

If there really are cases where people want small blobs of data and it
would make sense, we could easily do "%.*pQ" for "quoted blob" or
whatever, where the precision is obviously the size of the blob (so
"%.4pQ" would be a quoted four-byte entity.

We could also extend on the current '%pm', which was really designed
for mac-addresses, but the format is actually just a hex sequence. We
could extend that too to just take the precision into account, and
just default to a six-byte mac address. But we could trivially make
"%.16pm" print out a 16-byte hex string instead.

I would also be very open to having some auto-quoting support for
'%s': it might even be something we could enable by default. So that
if you print out strings that contain special characters (including
'\n' etc), we could make sure that vsnprintf() actually quotes them.
We don't have to follow the POSIX rules for things, after all.

So I'm very open to making it easier to use ASCII.

I'm *very* closed to making any kernel logging facility use binary
data. If you want binary data, go somewhere else. Seriously.

                  Linus

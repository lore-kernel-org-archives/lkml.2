Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab2BVDsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 22:48:00 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:61744 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab2BVDr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 22:47:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.24.202 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com>
References: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com>
 <20120221.221609.218135609185671883.davem@davemloft.net> <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Feb 2012 19:47:38 -0800
X-Google-Sender-Auth: 8Aan4MtQvDhAfOkxtERKwSOwbJg
Message-ID: <CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com>
Subject: Re: compat: autofs v5 packet size ambiguity - update
To: David Miller <davem@davemloft.net>, Ian Kent <raven@themaw.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, autofs@linux.kernel.org,
        thomas@m3y3r.de, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 7:33 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> But I'm sure that the autofs daemon does something simple that we can
> depend on in practice.

I didn't find the most recent source code, but the first thing that
automount.c does after calling "mount" (which is a for+exec, so we
cannot take the mounting is_compat_task() into account is to open the
new root for the ioctlfd, and then it does a stat.

And then it does a AUTOFS_IOC_PROTOVER ioctl to see what the protocol
version is.

So we could just decide that

 (a) we add a mount option for the packet size (or just "v6" - which
would be "v5 with a fixed packet size")

 (b) in the absence of an explicit mount option, we look at
is_compat_task() for the first AUTOFS_IOC_PROTOVER ioctl we get.

That looks fairly straightforward and safe. Hmm?

Where are the automount sources supposed to be, anyway? kernel.org has
a v5 directory, but it's empty.

                Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab2BVDds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 22:33:48 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63120 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab2BVDdr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 22:33:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.109.225 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120221.221609.218135609185671883.davem@davemloft.net>
References: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com>
 <20120221.221609.218135609185671883.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Feb 2012 19:33:26 -0800
X-Google-Sender-Auth: rCOW3zW4X597mDdkv22VfUzD-48
Message-ID: <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com>
Subject: Re: compat: autofs v5 packet size ambiguity - update
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, autofs@linux.kernel.org,
        thomas@m3y3r.de, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 7:16 PM, David Miller <davem@davemloft.net> wrote:
>
> It's just a real fd, and there is no way to tell the compat'ness for
> that.  The mount operation literally passes in an integer attribute as
> the pipefd mount option, and that's what it seems to use to send these
> events.

Sure.

But I'm sure that the autofs daemon does something simple that we can
depend on in practice. It's fine if we default to the current "native
size" but then just have some heuristic that notices "oh, but we seem
to be running a compat daemon". After all, this is very much a special
case, I don't think we need to worry about people doing crazy things
in *general*, the only thing we need to worry about is a legacy x86-32
install that has been updated with a 64-bit kernel.

Where is that autofs daemon source code so that I can see what it does?

> The only way to fix this cess pool completely is to override the
> read() fop on that pipe, and translate the event stream in-situ.
>
> What we could do is just manage the autofs messages as a linked list
> of events, f.e. the packets in native format, then in the overridden
> read() handler we either pass it along as is (for non-compat tasks) or
> translate to compat format and copy that to userspace instead.

Sure. But I just don't think we need to fix the general case.

                  Linus

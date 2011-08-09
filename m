Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab1HIXig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 19:38:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55729 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab1HIXif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 19:38:35 -0400
Date: Wed, 10 Aug 2011 00:38:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Arnaud Lacombe <lacombar@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/5] um: Use __i386__ in ifdef for vsyscall exports, not
 SUBARCH_i386
Message-ID: <20110809233817.GL2203@ZenIV.linux.org.uk>
References: <1312066693.22074.50.camel@i7.infradead.org>
 <1312066923.22074.53.camel@i7.infradead.org>
 <CAFLxGvy0QqoySDFwZpygHeXvQ7hG-B7z5iZq8qx3GUkFX8w2RQ@mail.gmail.com>
 <1312151063.18010.25.camel@i7.infradead.org>
 <20110731224834.GC2203@ZenIV.linux.org.uk>
 <20110731225801.GD2203@ZenIV.linux.org.uk>
 <1312153988.18010.39.camel@i7.infradead.org>
 <CAFLxGvyewG70ZgU41Kmu_eOYpjZ0TVXYwYq1AfS1sXONAM6G_w@mail.gmail.com>
 <20110801043207.GE2203@ZenIV.linux.org.uk>
 <CAFLxGvwxQ2VeqkDpkiVks35DHxZFvAP5nKUtD7i4Z32291otOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvwxQ2VeqkDpkiVks35DHxZFvAP5nKUtD7i4Z32291otOg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 07:52:35PM +0200, richard -rw- weinberger wrote:

> Ok, will look at it in the next few days.
> "sys-{i386,x86_64} merged" sounds great!

	Update pushed; x86-specific stuff moved to arch/x86/um, more things
merged/cleaned up.  Works here, both for 32bit and 64bit builds...  At least
as well as the mainline one does, that is - there still are two very annoying
issues, shared with mainline at least as far back as 2.6.36:
	* dancing close to OOM sometimes ends up with reserved pages showing
up in pagetables.  Code in mm/* is Not Happy(tm)...
	* tty-on-xterm sometimes crashes on the first keysyms reaching it;
as far as I can tell, it's something related to SIGWINCH handling - whether
it happens or not depends on the way xterm windows are laid out and flipping
between them first seems to prevent that shit.  If it hasn't happened at once,
it won't happen at all...  Something in drivers/chan or drivers/line, most
likely...

	I can post the damn thing as patch series, but it's about 380Mb
even with git format-patch -M and 78-posting mailbomb is a bit over the top
anyway...

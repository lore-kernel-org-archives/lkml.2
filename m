Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab2BUS6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:58:43 -0500
Received: from www17.your-server.de ([213.133.104.17]:52676 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab2BUS6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:58:41 -0500
Message-ID: <1329850714.1419.2.camel@localhost.localdomain>
Subject: Re: Linux 3.3-rc4
From: Thomas Meyer <thomas@m3y3r.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ian Kent <raven@themaw.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 21 Feb 2012 19:58:34 +0100
In-Reply-To: <CA+55aFzUWDEuj85sOKjwk8ufy+1rbS7hgstw0cCWpjTgu=7B4A@mail.gmail.com>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
	 <FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de>
	 <CA+55aFzUWDEuj85sOKjwk8ufy+1rbS7hgstw0cCWpjTgu=7B4A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 19.02.2012, 10:45 -0800 schrieb Linus Torvalds:
> On Sun, Feb 19, 2012 at 5:42 AM, Thomas Meyer <thomas@m3y3r.de> wrote:
> >
> > 1.) autofs4 interface is broken between x86 and x86_64. as systemd uses autofs, this bug hangs the boot process as e.g. binfmt is mounted via autofs. see also http://lists.freedesktop.org/archives/systemd-devel/2011-September/003396.html
> 
> Duh.
> 
> That is just broken.
> 
> The code even *talks* about how the packet layout is the same on
> 32-bit and 64-bit architectures, and that's largely true.
> 
> However, while true, x86-64 has 8-byte alignment for 'long', and
> x86-32 has 4-byte alignment. Which means that even though the
> structure layout is exactly the same, on x86-64 the *alignment* issue
> will push it out to 304 bytes.
> 
> That's just stupid. We've had that problem before. It's easy to
> overlook, but that packet is just mis-designed.
> 
> The attached patch isn't pretty, but this is definitely a kernel bug.
> Binary compatibility is *important*, dammit.
> 
> Does this fix it?

yes, it does!

thanks.




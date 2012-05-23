Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab2EWQxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:53:20 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39558 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150Ab2EWQxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:53:10 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8MBbJ00Kgycu-7v6vofQYst_Cujoiu78_Ke5RqM6Bx=-+F1g@mail.gmail.com>
References: <20120521170539.GA13635@google.com> <CA+55aFyyEhYcoh2gugVJELfW+dGrLbrow=ZoXsPs3kxft7Tu4g@mail.gmail.com>
 <CA+8MBbJ00Kgycu-7v6vofQYst_Cujoiu78_Ke5RqM6Bx=-+F1g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 May 2012 09:52:48 -0700
X-Google-Sender-Auth: cRk7o4s14SebXN23_9NcffWJ4pE
Message-ID: <CA+55aFzgMPobmuCM86Z2obEnEB=uTA4n8VQQJUZoQsW8oTS7gA@mail.gmail.com>
Subject: Re: [GIT PULL] PCI updates for 3.5 merge window
To: Tony Luck <tony.luck@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 9:41 AM, Tony Luck <tony.luck@gmail.com> wrote:
>
> Or is "smarter" already in a newer version of git - I have:
>
> $ git --version
> git version 1.7.9.5

I think you want 1.7.10 for anything to do with tagged messages.

You can do everything with 1.7.9 (it can still handle the tags
correctly), but it doesn't DTRT by default: you have to explicitly
mention the "tag" part (ie you need to use "tags/xyz" instead of just
"xyz"), and git pull-request doesn't realize that pulling a signed tag
does more than just pulling the commit it points to etc etc. So with
1.7.9 you can make things work, but you would end up to work around
the fact that the whole signed tag pulling wasn't really a real
feature before that.

So 1.7.10 is when pulling a signed tag was really introduced: it's
just that earlier versions can still *create* those tags (so the only
one who *had* to have 1.7.10 was the person doing the pull).

I would strongly recommend just doing

   git clone git://github.com/gitster/git
   cd git
   make
   make install

as just a normal user (*NOT* as root), which will install git in your
~/bin directory. Then, just make sure that you have ~/bin in your PATH
before /usr/bin, and you're all set. No need to mess with or worry
about distro git binaries - leave them alone, but get the best and the
brightest for your own use.

                     Linus

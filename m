Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab2GTK0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 06:26:49 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:63197 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2GTK0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 06:26:47 -0400
Date: Fri, 20 Jul 2012 12:26:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
Message-ID: <20120720102644.GA23636@merkur.ravnborg.org>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com> <alpine.LRH.2.00.1207201145310.16218@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1207201145310.16218@twin.jikos.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> But we'll first have to make 'select' to actually work, right? It 
> currently doesn't resolve the dependencies of the selected configs, so it 
> will just produce some very broken config.

We could restrict "select" to only select symbols with no dependencies,
or *exactly* the same dependencies as the symbol containing the select.

So we could have something like:

config FEDORA
	select WANT_TMPFS


config WANT_TMPFS
	bool

config TMPFS
	defbool y if WANT_TMPFS


This is a pattern used today in many places.
But fixing up all the current select XXX would not be trivial...
I have no idea how many of the select we have today that would fail
the above semantic restrictions - but I guess it is a lot.

We could also come up with something new like:

config FEDORA
	require TMPFS
	require EXT4 = m
	require EXT3 = y

This would set TMPS to y if TMPFS dependencies are met.
And EXT3 to y and EXT4 to m if their dependencies are met.

This should be more or less the same as setting the value to y/m
in the user interface, which is only possible if the value is visible.

	Sam

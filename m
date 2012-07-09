Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab2GIUji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:39:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54428 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab2GIUjf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:39:35 -0400
Date: Mon, 9 Jul 2012 15:39:29 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: martin-eric.racine@iki.fi
Cc: Hans de Goede <hdegoede@redhat.com>, 677533@bugs.debian.org,
        =?utf-8?Q?Jean-Fran=C3=A7ois?= Moine <moinejf@free.fr>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: video: USB webcam fails since kernel 3.2
Message-ID: <20120709203929.GC17301@burratino>
References: <20120614162609.4613.22122.reportbug@henna.lan>
 <20120614215359.GF3537@burratino>
 <CAPZXPQd9gNCxn7xGyqj_xymPaF5OxvRtxRFkt+SsLs942te4og@mail.gmail.com>
 <20120616044137.GB4076@burratino>
 <1339932233.20497.14.camel@henna.lan>
 <CAPZXPQegp7RA5M0H9Ofq4rJ9aj-rEdg=Ly9_1c6vAKi3COw50g@mail.gmail.com>
 <4FF9CA30.9050105@redhat.com>
 <CAPZXPQd026xfKrAU0D7CLQGbdAs8U01u5vsHp+5-wbVofAwdqQ@mail.gmail.com>
 <4FFAD8D9.8070203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4FFAD8D9.8070203@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin-Éric,

Hans de Goede wrote:

> Erm, that is quite a bit of work from my side for something which you
> can easily do yourself, edit gspca.c, search for which_bandwidth
> and then under the following lines:
>         u32 bandwidth;
>         int i;
>
> Add a line like this:
> 	return 2000 * 2000 * 120;

In case it helps, here are some more complete instructions.

 0. Prerequisites:

	apt-get install git build-essential

 1. Get the kernel history, if you don't already have it:

	git clone \
	  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

 2. Try linus's master:

	cd linux
	git fetch origin
	git reset --hard origin/master
	cp /boot/config-$(uname -r) .config; # current configuration
	scripts/config --disable DEBUG_INFO
	make localmodconfig; # optional: minimize configuration
	make deb-pkg; # optionally with -j<num> for parallel build
	dpkg -i ../<name of package>; # as root
	reboot
	... test test test ...

    Hopefully it reproduces the bug.

 3. Try Hans's first suggested change, as described in the quoted text
    above:

	cd linux
	vi drivers/media/video/gspca/gspca.c
	... make the suggested edits ...
	make deb-pkg; # maybe with -j4
	dpkg -i ../<name of package>; # as root
	reboot
	... test test test ...

 4. Try Hans's second suggested change, as described in a previous
    message:

	cd linux
	vi drivers/media/video/gspca/gspca.c
	... make the suggested edits ...
	make deb-pkg; # maybe with -j4
	dpkg -i ../<name of package>; # as root
	reboot
	... test test test ...

No doubt Jean-François will notice that it is easier to test the
standalone driver because the first build does not have to compile the
whole kernel.  That's fine, too.  The instructions above describe how
to test the in-kernel driver because it's what I'm used to (and
because it means you test the driver against the same version of the
rest of the kernel as would get the fix).

Hope that helps,
Jonathan

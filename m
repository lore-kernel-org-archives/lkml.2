Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab2FQRLq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 13:11:46 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:48283 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757343Ab2FQRLo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 13:11:44 -0400
Date: Sun, 17 Jun 2012 12:11:38 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: =?utf-8?Q?Martin-=C3=89ric?= Racine <martin-eric.racine@iki.fi>
Cc: =?utf-8?Q?Jean-Fran=C3=A7ois?= Moine <moinejf@free.fr>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: video: USB webcam fails since kernel 3.2
Message-ID: <20120617171138.GK12429@burratino>
References: <20120614162609.4613.22122.reportbug@henna.lan>
 <20120614215359.GF3537@burratino>
 <CAPZXPQd9gNCxn7xGyqj_xymPaF5OxvRtxRFkt+SsLs942te4og@mail.gmail.com>
 <20120616044137.GB4076@burratino>
 <1339932233.20497.14.camel@henna.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1339932233.20497.14.camel@henna.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc-ing Hans de Goede, the new gspca maintainer.  Sorry I missed that before.)

>> Martin-Éric Racine wrote:
>>> usb 1-7: new high-speed USB device number 3 using ehci_hcd
[...]
>>> usb 1-7: Product: USB2.0 Web Camera
>>> usb 1-7: Manufacturer: Vimicro Corp.
[...]
>>> gspca_main: v2.14.0 registered
>>> gspca_main: vc032x-2.14.0 probing 0ac8:0321
[...]
>>> gspca_main: ISOC data error: [36] len=0, status=-71
>>> gspca_main: ISOC data error: [65] len=0, status=-71
[...]
>>> gspca_main: ISOC data error: [48] len=0, status=-71
>>> video_source:sr[3246]: segfault at 0 ip   (null) sp ab36de1c error 14 in cheese[8048000+21000]
>>> gspca_main: ISOC data error: [17] len=0, status=-71

Thanks again.

If you get a chance to test Hans's media-for_v3.5 branch, that would
be interesting.  It works like so:

 0. prerequisites:

	apt-get install git build-essential

 1. get the kernel history, if you don't already have it:

	git clone \
	  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

 2. fetch gspca updates:

	cd linux
	git remote add gspca \
	  git://linuxtv.org/hgoede/gspca.git
	git fetch gspca

 3. configure, build, test:

	git checkout gspca/media-for_v3.5
	cp /boot/config-$(uname -r) .config; # current configuration
	scripts/config --disable DEBUG_INFO
	make localmodconfig; # optional: minimize configuration
	make deb-pkg; # optionally with -j<num> for parallel build
	dpkg -i ../<name of package>; # as root
	reboot
	... test test test ...

I ask because there have been some gspca core fixes cooking that are
not part of the 3.4.y tree, though none of them looks especially
relevant.

Hope that helps,
Jonathan

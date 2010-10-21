Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab0JUPXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 11:23:37 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:43177 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757706Ab0JUPXd (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:23:33 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        clemens@ladisch.de, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org
Subject: Re: HDA: no sound [was: mmotm 2010-10-20-15-01 uploaded]
In-Reply-To: Your message of "Thu, 21 Oct 2010 09:57:16 +0200."
             <4CBFF25C.2080908@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org> <4CBFEE94.7020103@gmail.com> <s5hlj5sc7do.wl%tiwai@suse.de>
            <4CBFF25C.2080908@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1287674569_10867P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 21 Oct 2010 11:22:49 -0400
Message-ID: <13987.1287674569@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1287674569_10867P
Content-Type: text/plain; charset=us-ascii

On Thu, 21 Oct 2010 09:57:16 +0200, Jiri Slaby said:
> On 10/21/2010 09:49 AM, Takashi Iwai wrote:
> > At Thu, 21 Oct 2010 09:41:08 +0200,
> > Jiri Slaby wrote:
> >> alsa-info:
> >> http://www.alsa-project.org/db/?f=a7a09703bcc8c43386c87a984e513ce35fc91ca4
> > 
> > I see the Front volume is set to zero.  Try to raise it.
> 
> I set all the values to ~ 70 and then tried with pure alsa. It basically
> works.
> 
> BUT, when I run pulse and it suspends the device (or whatever), all the
> levels get down to 0 back again. When I raise it and run mplayer, it
> gets to 0 immediately. If I raise it gets to 0 when mplayer finishes and
> pulse writes 'protocol-native.c: Connection died.'. It never raises
> automatically. And if I raise it during playback, nothing plays at all.

Seeing the same thing on a Dell Latitude E6500, so Jiri isn't hallucinating.

Didn't we have some flustercluck a while back that gave pulseaudio
similar indigestion?  Oh, here it is, it was an fsnotify botch, of all things.

commit 2069601b3f0ea38170d4b509b89f3ca0a373bdc1
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Aug 12 14:23:04 2010 -0700

    Revert "fsnotify: store struct file not struct path"
    
    This reverts commit 3bcf3860a4ff9bbc522820b4b765e65e4deceb3e (and the
    accompanying commit c1e5c954020e "vfs/fsnotify: fsnotify_close can delay
    the final work in fput" that was a horribly ugly hack to make it work at
    all).


Did we manage to revert the revert, or re-break this code? I haven't looked at
this at all in detail.

--==_Exmh_1287674569_10867P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMwFrJcC3lWbTT17ARAod6AKDdnOPUFFu7YO13PEH3QG6sI6SptQCdElzQ
pUkLCMhqAACJywfXHKKx3wk=
=i9Xc
-----END PGP SIGNATURE-----

--==_Exmh_1287674569_10867P--

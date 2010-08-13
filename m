Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761277Ab0HMCON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 22:14:13 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:50122 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab0HMCOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 22:14:12 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: mmotm 2010-08-11 - audio volume issues
In-Reply-To: Your message of "Thu, 12 Aug 2010 23:11:42 +0200."
             <s5hd3tntu29.wl%tiwai@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <201008112340.o7BNenDe021017@imap1.linux-foundation.org> <5043.1281639572@localhost> <4C64624E.7040002@gmail.com>
            <s5hd3tntu29.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1281665605_4567P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 12 Aug 2010 22:13:25 -0400
Message-ID: <4695.1281665605@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020208.4C64AA46.0105,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1281665605_4567P
Content-Type: text/plain; charset=us-ascii

On Thu, 12 Aug 2010 23:11:42 +0200, Takashi Iwai said:
> At Thu, 12 Aug 2010 23:06:22 +0200,
> Jiri Slaby wrote:
> > 
> > On 08/12/2010 08:59 PM, Valdis.Kletnieks@vt.edu wrote:
> > > On Wed, 11 Aug 2010 16:10:49 PDT, akpm@linux-foundation.org said:
> > >> The mm-of-the-moment snapshot 2010-08-11-16-10 has been uploaded to
> > >>
> > >>    http://userweb.kernel.org/~akpm/mmotm/
> > > 
> > > Something appears to be borked in the ALSA arena.  There's no actual volume coming
> > > out of the system, and 'alsamixer' is insisting that the volume slider only goes from 0
> > > to 10% or so, no further.  However, experimentation shows that the volume slider
> > > in 'xine' *does* affect the 'Amp-Out vals' lines, and alsamixer has *no* effect on
> > > what 'Amp-Out vals' lists.
> > > 
> > > A diff of alsa-info.sh for the two kernels shows them being identical, so I'm only
> > > attaching one copy.
> > > 
> > > It may be the weekend before I find time to do a bisection of this.
> > 
> > Didn't you (like some other people) get into the state where pulseaudio
> > doesn't work? It chooses as an output a dummy driver automatically, then
> > you can change volume, play sound, but actually it all goes to /dev/null.
> > 
> > It took me a while before I figured out that it's a "dummy" driver I
> > have in pulseaudio.
> 
> Looks like there is a breakage regarding open/close due to fs/notify/*
> changes.  I guess you can hear still sounds like:
> 
> 	% aplay -Dplughw foo.wav

Confirming that Linus's patch fixes it for me:

commit 2069601b3f0ea38170d4b509b89f3ca0a373bdc1
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Aug 12 14:23:04 2010 -0700

    Revert "fsnotify: store struct file not struct path"
    
    This reverts commit 3bcf3860a4ff9bbc522820b4b765e65e4deceb3e (and the
    accompanying commit c1e5c954020e "vfs/fsnotify: fsnotify_close can delay
    the final work in fput" that was a horribly ugly hack to make it work at
    all).



--==_Exmh_1281665605_4567P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMZKpFcC3lWbTT17ARAufmAJ9goOndYraZ66zllcjiuyc/Ns5wKgCZAWp1
LomGTJVERVbUPSSBCZBaz/w=
=f7M+
-----END PGP SIGNATURE-----

--==_Exmh_1281665605_4567P--


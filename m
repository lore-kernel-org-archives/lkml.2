Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab1LVBUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 20:20:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab1LVBUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 20:20:45 -0500
Date: Thu, 22 Dec 2011 12:20:26 +1100
From: NeilBrown <neilb@suse.de>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Greg KH <gregkh@suse.de>, linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: RFC: android logger feedback request
Message-ID: <20111222122026.3a0fae36@notabene.brown>
In-Reply-To: <4EF27B85.9080801@am.sony.com>
References: <4EF264C3.6000104@am.sony.com>
	<20111221231956.GB23859@suse.de>
	<4EF27B85.9080801@am.sony.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/DnZpY_OObHsv6b_bQnECVqR"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/DnZpY_OObHsv6b_bQnECVqR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Dec 2011 16:36:21 -0800 Tim Bird <tim.bird@am.sony.com> wrote:

> On 12/21/2011 03:19 PM, Greg KH wrote:
> > That all describes the current code, but you haven't described what's
> > wrong with the existing syslog interface that requires this new driver
> > to be written.  And why can't the existing interface be fixed to address
> > these (potential) shortcomings?
>=20
>=20
> >> One specific question I have is where is the most appropriate
> >> place for this code to live, in the kernel source tree?
> >> Other embedded systems might want to use this system (it
> >> is simpler than syslog, and superior in some ways), so I don't
> >> think it should remain in an android-specific directory.
> >=20
> > What way is it superior?
>=20
> Here are some ways that this code is superior to syslog:

It is certainly nice and simple.  It really looks more like a filesystem th=
an
a char device though...  though they aren't really files so much as lossy
pipes.  I don't think that's a problem though, lots of things in filesystems
don't behave exactly like files.

If you created a 'logbuf' filesystem that used libfs to provide a single
directory in which privileged processes could create files then you wouldn't
need the kernel to "know" the allowed logs: radio, events, main, system.
The size could be set by ftruncate() (by privileged used again) rather than
being hardcoded.

You would defined 'read' and 'write' much like you currently do to create a=
 list of
datagrams in a circular buffer and replace the ioctls by more standard
interfaces:

LOGGER_GET_LOG_BUG_SIZE would use 'stat' and the st_blocks field
LOGGER_GET_LOG_LEN would use 'stat' and the st_size field
LOGGER_GET_NEXT_ENTRY_LEN could use the FIONREAD ioctl
LOGGER_FLUSH_LOG could use ftruncate

The result would be much the same amount of code, but an interface which has
fewer details hard-coded and is generally more versatile and accessible.

NeilBrown


--Sig_/DnZpY_OObHsv6b_bQnECVqR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTvKF2jnsnt1WYoG5AQKT6RAAq4+T3Wnaw+mQW/hJcBwjATRzhRbfh238
lm7RYzpnAybVuDsF8Poy9v3tziCsjWxL22gC6QMsgAP3oOQgi4NJIaXKFXX5YwsM
IoOYVTzjDsAjp0+9OW8UJrQhrI//toI8Mf82bazp2DU1Xvargz2yP/+xp6XWX3q9
plVAazwYosGXY2EP+dj46ojnrwt9q3fsyq6bkIPuHC1oV3zrnirCexkJYmJP/n6j
/z1Tl2nWNZocaUSQW4oMlq2MjNt8deSZmCS/5Ou/6sK7JSooEIhXuW1I9Nqkke92
fQJVECD+SRB5AOeiZEXo0RjadV9TsMLFesB5aZpqHrGJzIQhfghnB3fLVaEGVzbZ
P/273sNWcKASQmgPx0OxGiqGoocJBTX5ccHbk8L6gpVlwsUhD9QNoEulZ3J/qEKh
Qyg5fB1x8MbDJkBXd9LpoHvYSZS3Mb78D3hnsu5JzCAR+qL96FAONA7mLtcQrHNu
u2QKwdRRbJyxVd+d82SxYfktJUlEqFGHW8i6L0sWqcZf1pRNVYbn39COKxzCndQb
tJ6NJck2s/65XCpqV+BoGbPDknIKO8EZQ5uUGcdAZ7tAaDe39zANRNnEfeIoFzZv
txJCiIYdKQ+yoKIt6hX58dof7VuHNtYUBuMWfYduluOLPfs2Gau6jqY1yW3Pv4ar
t1g88+lCsfg=
=sE2h
-----END PGP SIGNATURE-----

--Sig_/DnZpY_OObHsv6b_bQnECVqR--

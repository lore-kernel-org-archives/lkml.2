Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab2KTApV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 19:45:21 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:45350 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab2KTApU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 19:45:20 -0500
X-Greylist: delayed 2975 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Nov 2012 19:45:19 EST
X-manitu-Original-Sender-IP: 127.0.0.1
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Tue, 20 Nov 2012 00:55:40 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: Kees Cook <keescook@chromium.org>
Cc: Kay Sievers <kay@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, ellyjones@chromium.org
Subject: Re: [PATCH] devtmpfs: mount with noexec and nosuid
Message-ID: <20121119235540.GB18012@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
Mail-Followup-To: Kees Cook <keescook@chromium.org>,
	Kay Sievers <kay@vrfy.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, ellyjones@chromium.org
References: <20121117002016.GA13493@www.outflux.net>
 <20121117002753.GA22778@kroah.com>
 <CAPXgP12e5LpN6XVxaXOHhH=u8XXN==2reTaJDCoCk4tP4QduDQ@mail.gmail.com>
 <CAGXu5jJVCEcrkkvqyoT=T0spnZJVBbxdskf0xM3rMK7d1Tv+Ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Content-Disposition: inline
In-Reply-To: <CAGXu5jJVCEcrkkvqyoT=T0spnZJVBbxdskf0xM3rMK7d1Tv+Ng@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-11-19 Monday at 10:14 -0800 Kees Cook wrote:
> On Fri, Nov 16, 2012 at 4:39 PM, Kay Sievers <kay@vrfy.org> wrote:
> > On Sat, Nov 17, 2012 at 1:27 AM, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >> On Fri, Nov 16, 2012 at 04:20:16PM -0800, Kees Cook wrote:
> >>> Since devtmpfs is writable, make the default noexec nosuid as well. T=
his
> >>> protects from the case of a privileged process having an arbitrary fi=
le
> >>> write flaw and an argumentless arbitrary execution (i.e. it would lack
> >>> the ability to run "mount -o remount,exec,suid /dev"), with a system
> >>> that already has nosuid,noexec on all other writable mounts.
> >>>
> >>> Cc: ellyjones@chromium.org
> >>> Signed-off-by: Kees Cook <keescook@chromium.org>
> >>> ---
> >>>  drivers/base/devtmpfs.c |    6 ++++--
> >>>  1 file changed, 4 insertions(+), 2 deletions(-)
> >>
> >> Have you tested this to verify that it doesn't break anything?
> >>
> >> Kay, could this cause any problems that you could think of?
> >
> > It breaks all sorts of old, possibly outdated, stuff, that does things
> > like mapping /dev/mem executable. It for sure used to break X drivers,
> > that fiddle with the BIOS of cards.
>=20
> Ah, yeah, you're totally right. Attempting an mmap with PROT_EXEC on
> /dev/mem would be denied.

Sidenote:  non-executable devtmpfs + nouveau + KMS + xorg works for me:

uname -mrs
=2E.........
Linux 3.2.33-grsecurity.roland.0 x86_64

grep devtmpfs /etc/{fs,m}tab /proc/{$$/mountinfo,mounts}
=2E.......................................................
/etc/fstab:devtmpfs     /dev    devtmpfs        rw,noexec,nosuid,size=3D8m,=
nr_inodes=3D16k,mode=3D0755        0       0
/etc/mtab:devtmpfs /dev devtmpfs rw,noexec,nosuid,size=3D8m,nr_inodes=3D16k=
,mode=3D0755 0 0
/proc/10358/mountinfo:18 15 0:5 / /dev rw,nosuid,noexec - devtmpfs devtmpfs=
 rw,size=3D8192k,nr_inodes=3D16384,mode=3D755
/proc/mounts:devtmpfs /dev devtmpfs rw,nosuid,noexec,size=3D8192k,nr_inodes=
=3D16384,mode=3D755 0 0

lspci -d 10de:0a3c -k -nn
=2E........................
01:00.0 VGA compatible controller [0300]: nVidia Corporation GT216 [Quadro =
FX 880M] [10de:0a3c] (rev a2)
        Subsystem: Dell Device [1028:040c]
        Kernel driver in use: nouveau

ps -p $( pgrep -d, xinit ) -F
=2E............................
UID        PID  PPID  C    SZ   RSS PSR STIME TTY          TIME CMD
roland    9514  9478  0 16583   844   2 Nov02 tty6     00:00:00 xinit /etc/=
X11/xinit/xinitrc -- /usr/bin/X :0 -auth /home/roland/.serverauth.9478
qemu     11486 11463  0 12723   848   0 Nov02 tty30    00:00:00 xinit /etc/=
X11/xinit/xinitrc -- /usr/bin/X :1 -auth /home/qemu/.serverauth.11463
opera    12273 12240  0  8973   848   3 Nov02 tty18    00:00:00 xinit /etc/=
X11/xinit/xinitrc -- /usr/bin/X :2 -auth /home/opera/.serverauth.12240


> Is this something we could put behind a CONFIG?

IMHO would be great :)

--=20
Roland

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlCqxvwACgkQdN/hKfT7G/JvzgCgoSz6XFaanMAZvsWmaksPi5bY
wR0AnA14eRdbxoEPv1WM+8EY1WD60YaW
=FxI9
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--

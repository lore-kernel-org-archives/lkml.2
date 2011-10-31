Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab1JaVP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 17:15:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab1JaVP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 17:15:56 -0400
Date: Tue, 1 Nov 2011 08:15:54 +1100
From: NeilBrown <neilb@suse.de>
To: Ming Lei <tom.leiming@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of
 suspend/hibernate interfaces
Message-ID: <20111101081554.52ee5b38@notabene.brown>
In-Reply-To: <CACVXFVO_qNoy=AMs4RQOPsNq5dnTsc-=-f70Njf9Hv8eRkx=+Q@mail.gmail.com>
References: <201110132145.42270.rjw@sisk.pl>
	<CACVXFVO_qNoy=AMs4RQOPsNq5dnTsc-=-f70Njf9Hv8eRkx=+Q@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/r8_M6lZmK0UQJpleVAadcbE"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/r8_M6lZmK0UQJpleVAadcbE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 1 Nov 2011 03:55:50 +0800 Ming Lei <tom.leiming@gmail.com> wrote:

> Hi,
>=20
> On Fri, Oct 14, 2011 at 3:45 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>=20
> > Second, to address the backup problem, we need to allow user space
> > processes other than the suspend/hibernate process itself to prevent the
> > system from being put into sleep states. =A0A mechanism for that is int=
roduced
> > by the second patch in the form of the /dev/sleepctl special device wor=
king
> > kind of like user space wakelocks on Android (although in a simplified
> > fashion).
>=20
> I also have another similar example: write(fd, buffer, 100*4096).
>=20
> Suppose only 80*4096 are copied into pages of the file, then someone
> run ' echo mem > /sys/power/state ' to trigger system sleep, so only
> partial writing is completed before system sleep and data inconsistence
> may be caused for the file on filesystem.
>=20
> But I am not sure if it is possible to happen in reality.
>=20
> thank,

I'm not sure if it is possible either, but even if it is it isn't a new
problem.  A suspend is expected to leave all sorts of external things in
inconsistent states. The contents of memory implicitly records all these
inconsistencies and allows them to be resolved in the normal course of thin=
gs
after resume.
If you lose power to memory during suspend then you can certainly expect
filesystems to be corrupted in exactly the same sort of way that they can be
corrupted by a crash.  This has always been the case and I assume always wi=
ll
(until we get main-memory that preserves state without power)

We want to block suspend during backups not to avoid corruption but simply =
to
allow the backups to complete promptly.

NeilBrown

--Sig_/r8_M6lZmK0UQJpleVAadcbE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTq8QEDnsnt1WYoG5AQIH7RAAoNOLTB5VBzMW6AlnG6ZK/0JUAolB9cc0
TkcrzR6fGinCt8htxojlMXsBgtHg0gQToGzfR8Bxi+Tc3VsrofN+E2Sx5ZbiVGUm
+hZ/8eWIC39QiNsKnm7vS/LJsI4qDqHJh6Bq802TMFlI5WxGhnPxwA99ZziLP4jP
vlc/J9gchabMS1N1lejrZP1AA5MFFG47O95hbV4J6X6D9gBTjP1DyRBqlvWiDhPj
JBMUOoo+tMcmzKutx6UlVCjc+u9wf03Ww0Y5TI9VzzxL44kdBC1shY0/SaGhNFWv
9e4mmSskUkO2rcZkl8uq52u6jOHjjmZYAuXV35HIOJopbwLgIYqIxGrH+rJ67Vat
6pL5KxAytjgJ4yCEFc0M7cYyJOpmU11EySbDts4CAwzKjjykd8RXcKIwZ4hU01wy
heWeCrIUU8Xd3JLlv31vESuch9ncn+cPfcBsnAZGDa7mCyc2jolJEYyfvQ3fId0u
3xZZPWnP4Wk45MZ1xp/6U1Qhj1i5cFXkdDdD3zFvjVKnJis6rIlMbVlDdyUJvtY1
JsNM4Yz1Gprkbb5lS4y5uaPOHQmgjUWQk0NMvUx7p3iaRGkCMxAP/atUr0ON0F7d
W9O/YMKRQWqAgkP0mSq+JWvD6TAAq+IyC7m9HDJDeC/qTZbLOluKZy48mikPWZJX
86zee8zppCM=
=Q/QL
-----END PGP SIGNATURE-----

--Sig_/r8_M6lZmK0UQJpleVAadcbE--

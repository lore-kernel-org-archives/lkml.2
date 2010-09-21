Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab0IUDGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 23:06:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36759 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab0IUDGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 23:06:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer;
        b=ozmKzIp7CvBNlSbeeUbnrSlQe1OphJT4jj5UeTIxXYYB1AWHPBZSYWZNCj+OFHFhTn
         TAhFaE8sYmKSHeHAxOPBemFXd/EkcSlhRrkM9Id4l7U0r7vXCMoeXNneIXYSDB89KmaA
         fNKAFFIF7tJUeBT8IqlfaiudxVtk0ogTpPnJw=
Subject: How to debug system hangs (bug #15737) on start of composite WM
From: Maciej Piechotka <uzytkownik2@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-ripemd160"; protocol="application/pgp-signature"; boundary="=-RipcffliihYf8rJqsBs9"
Date: Tue, 21 Sep 2010 04:06:26 +0100
Message-ID: <1285038386.3269.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.91 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RipcffliihYf8rJqsBs9
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I have problems debugging system hangs (bug #15737 -
https://bugzilla.kernel.org/show_bug.cgi?id=3D15737) which occur on
kernels >=3D2.6.33 (LTS i.e. 2.6.32 is not affected).=20

I cannot manage to debug them especially it actual results evolve along
with changes in userspace (however 2.6.32 is not affected). On various
stages:

    - Second start of composite WM would be either hard hang or will fix
the system (i.e. problem will not be reproduced until next reboot - and
will not be reproduced after hibernation) - recently (for 2 weeks) false
    - First start of X will result in soft hang only - true except some
builds of 2.6.35 with relocatable kernel (???) and very old builds
(2.6.33)
    - Magic SysRQ key does not work on hard hang
    - If second start of WM was successful the DRI after some time will
report bad drawables. It is fixed by reboot - recent (for 2 weeks)
    - Switching to console and back helps (i.e. more often there is no
hang) - possibly voodoo magic but it may help
    - Error messages about failing to pinpoint buffor (cause?
side-effect?)
    - Running X in gdb hangs system (even if it is not on current VT)

Soft hang: X hangs but I can switch to console. Turning off X will stop
it but it takes some time (a minute?). There is nothing in logs (X,
dmesg, system...)
Hard hang: System is not responsive including network, X, sysrq etc.
This is not kernel panic (caps lock and num lock does not blink).

Someone (probably not kernel dev) suggested that it might be connected
with removing BKL.

I am really sorry for spamming but I run out of ideas how to debug this
problem.

Regards


--=-RipcffliihYf8rJqsBs9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQIcBAABAwAGBQJMmCEyAAoJEJIdee2Vr4aPd7AP/R/5Ac9ugpceK+0pq560WL8N
rzgc/KcEiwa4hS4yPzCE8SkYw9rQbQLK7+tN26VJcH4h+OGFeesOGLdWxRVnvuBD
Nas+cPh3q176J0pfiGaPOCphVg2AoAAg2TfidjI37Q4Jb8ts7uD5rjtL/lsGyKNh
JaaY3/Jko8jEge+r+2haMQMqdUoZmiG/YeLEOnOfNyCSjEaibJB/zZRYXsiGo9fm
5txWIRRKUaGKR7TWRCz6XPgcQ57FWwCRtPVZ5mVvW/UzMb01agDAzd2vJ9MZsUVv
jMA6tkvFHAcQoWfla0g4XlzP4UXkJIOL+vu10cBpuL/EFlZQCDKqIOEsD6FnVVLu
HuQuhF+sKhnP98+mYPf9zpBT1jvq/osh6DBmZU7ybduz/UCCQELmpWii8ATgOX5U
GrA7nkBFMm/Cn5bILDQxhXgOunAzoc1Swr6KeY3l6cflClUNl12zomjwZQ4J67kK
uaYG1/rDL0SAOCf1SS4zQPKozIxRpBIz3vcenlqKBHlxIVYZ9Snm685ML6iMm3b2
dghN9bopsB9yzhQ+NzoCS7qLlCtkPkYdrxUg2j7jkX+3EEsb9WQeWXEr+6aYj44D
uLBfhe2WqT7fkEa1kpAu1+jtGm9KWrqca9nivdE8kxC6zutm77YwsvPQuWA3h46b
9AG/TqVvdA9QdqDb3d31
=8FAH
-----END PGP SIGNATURE-----

--=-RipcffliihYf8rJqsBs9--


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab1LNR6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 12:58:49 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:40786 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756258Ab1LNR6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 12:58:46 -0500
Date: Wed, 14 Dec 2011 12:58:44 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Avi Kivity <avi@redhat.com>
Cc: mingo@redhat.com, hpa@zytor.com, arnd@arndb.de, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, mtosatti@redhat.com,
        jeremy.fitzhardinge@citrix.com, levinsasha928@gmail.com,
        Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5 V5] Avoid soft lockup message when KVM is stopped by
 host
Message-ID: <20111214175844.GD4075@mgebm.net>
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net>
 <4EDF7B0D.4060001@redhat.com>
 <20111208151929.GA6301@mgebm.net>
 <4EE8BBF4.8070108@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DiL7RhKs8rK9YGuF"
Content-Disposition: inline
In-Reply-To: <4EE8BBF4.8070108@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DiL7RhKs8rK9YGuF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Dec 2011, Avi Kivity wrote:

> On 12/08/2011 05:19 PM, Eric B Munson wrote:
> > > error compiling committee.c: too many arguments to function
> > >=20
> > My concern for preempt notifiers is masking real soft lockup warnings. =
 If the
> > flag is set every time the vm is preempted, it becomes more likely that=
 we will
> > mask real warnings.  The ioctl was choosen because it sets the flag onl=
y when
> > the guest is being paused deliberately.
> >
> > AFAIK, SIGSTOP is not a supported way to stop a qemu vm so a soft lockup
>=20
> This is a kvm patch, not a qemu patch.  In general we try to address
> general requirements, not just those that are specific to one userspace,
> even if it is near to our hearts.
>=20
> > warning would be working as designed there.  If that isn't the case, or=
 if it
> > ever changes, we could always install a signal handler for SIGCONT that=
 set the
> > flag before resuming the vm.
> >
> > Scheduling delays are also beyond the scope of this problem and I see t=
he soft
> > lockup warning as appropriate in that case.
>=20
> I don't think you should see a guest softlockup if the host is
> overloaded.  Nor should you see it due to a long live migration pause,
> or STOP/CONT.  You should see a guest softlockup if it is spinning due
> to a guest bug, and not for any other reason.
>=20
> I think we need a mix of the ioctl (for STOP/CONT and voluntary pauses,
> like live migration or qemu stop/cont) and preempt notifiers (together
> with a check for TASK_RUNNING/TASK_UNINTERRUPTIBLE, for scheduling or
> swap delays)
>=20
> --=20
> error compiling committee.c: too many arguments to function
>=20

Do you want the preemption notifier work in before you will consider merging
this set, or can that be a follow on?

Eric

--DiL7RhKs8rK9YGuF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO6OPUAAoJEKhG9nGc1bpJfh0P/27rntQ0sjv9E711ZQm01dhK
7K+sev5s2I0VtZHgNICjQ31D8Ct0PSSOhwvmrs3Fe8SMb+WU18B/NWN8NCX3AFN8
EjRL8846AGfrzAqdKZyezCbEq+q4gDoESst8bH2kXWiKfpeRu7v/K+trALpheS/B
HM0B5pJ25hqqy6c18e2mX873WK0gvX2ZnRvitgChnnTGyC29yDh26Xc74mYC5iqP
RJ2QYVb99Qc0L7E6263NHoaZOKsGntUNcCBE3H8g487ZEwGaGXL37Cc2+tszAo1x
iu38AdVJwMvNlMlIXykHKA2bxhPSIYB4huooCTCy9oRApxV73Sn/N6IVFjN1loHi
frDrI5LRHWiSE1lwYQhH5h6C5RGnBIRljjpOqAa5P4lrwbkuf6UV2zJj00m3M+Qz
ynk216/CeHQfVtXHurHUK5i2L7D3K9DzM/DogaNCqwbd1jGHAIhaIiRtTzoMeqm0
MgdzqonV0xY6+Xe2MVAJpKL/gitnqIV1We7OAp0BjquQHM3nvNoyhPSrPwR1LEng
gNbgQJ32qCPs4ydzS76KJRum7BUi0ai8dE7vu0EdBnUrrPBignEjt8v1EZinmjCl
KHlQC7RW6VBjyre7mfOdPHPBCTw+gQ/4nq+u5qA4NqiEmLKmXaiEQ6MqqhTBFJDK
gvFdAUa4KV6IToBMkm2T
=FWT7
-----END PGP SIGNATURE-----

--DiL7RhKs8rK9YGuF--

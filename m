Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327Ab1LOSxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 13:53:51 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:45597 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759239Ab1LOSxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 13:53:48 -0500
Date: Thu, 15 Dec 2011 13:53:46 -0500
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
Message-ID: <20111215185346.GA2829@mgebm.net>
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net>
 <4EDF7B0D.4060001@redhat.com>
 <20111208151929.GA6301@mgebm.net>
 <4EE8BBF4.8070108@redhat.com>
 <20111214175844.GD4075@mgebm.net>
 <4EE9C274.3030603@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <4EE9C274.3030603@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Dec 2011, Avi Kivity wrote:

> On 12/14/2011 07:58 PM, Eric B Munson wrote:
> > > I don't think you should see a guest softlockup if the host is
> > > overloaded.  Nor should you see it due to a long live migration pause,
> > > or STOP/CONT.  You should see a guest softlockup if it is spinning due
> > > to a guest bug, and not for any other reason.
> > >=20
> > > I think we need a mix of the ioctl (for STOP/CONT and voluntary pause=
s,
> > > like live migration or qemu stop/cont) and preempt notifiers (together
> > > with a check for TASK_RUNNING/TASK_UNINTERRUPTIBLE, for scheduling or
> > > swap delays)
> > >=20
> >
> > Do you want the preemption notifier work in before you will consider me=
rging
> > this set, or can that be a follow on?
>=20
> Yes please.
>=20
> --=20
> error compiling committee.c: too many arguments to function
>=20

I am working on V7 to incorporate the __this_cpu_and suggestion, would you
consider that for inclusion and we can continue discussing the need for the
preemption notification work?  I think that having a guest complain when the
host is so loaded that the guest watchdog threads can't make any progress is
desirable behavior, it may be the only notification that an admin gets that=
 a
particular host is over loaded.

Eric

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO6kI6AAoJEKhG9nGc1bpJIbUP/3G9PFXfFMlQ1URaJG5PAGHT
0UNQ1DYgJhHhh4nZ8Xvvbu3KFpgtTI7ZLt+tFHyVy4dUv13P4M7w995zUgVPMwzO
IxTRtTpCNDou2bQv6iZSQpBqQ2EPniWt0ST3Rm+OztAwedX5govi0uYHJKhh5fJA
9E8FmfhpyYYrM/UPDL9l1OtMMfIrdNBT1u7IjCKfSB/8hmOoCFtJocHVdqDhGia4
RGPgjEy+KfPBaqE6MkUWEgyWrVw72vmP7aMRE6sLEywjjR4jbD5LVeNl9q6b6whY
Oinqb6GavyttXHn2aVIxZw5DfGPsfzrh8VLDc9fV8SItKnqNm6quvWO5eLgUPxPL
5b6KsjMMm8m9c4UK6qZHOVS7AXxUx5HSzGIQJlqUS/piLBFuzFQNi91EHRic+4cq
nXKojyqUOqg67gimibBJMGSijs+BdB9RuNciqi65eMp6Yspk51p1WtPCZzXaH1hY
cuSUGXf5E+GNHOrAxLfRGErs3t4tuYaZl+osqyFfJuYFzP8NMWVdvN5vTirxd6C7
XPVeGzWdDGGtUD5jt0A2ZaNuiu8ZUAj23GWGkEebL1hr2glPQT6eNGOzMdQfHDUl
ss7BbxJBUlXgn0GmmDKw2qZyiP68CA1tnjC4/JdJmH/oq4jc/hrhkaPpJyf/Ln+r
gmgDTEKoMJNlzwE+GBvF
=Ifx8
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--

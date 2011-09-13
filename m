Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631Ab1IMUt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 16:49:59 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:56326 "EHLO
	ozymandias.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932446Ab1IMUt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 16:49:57 -0400
Date: Tue, 13 Sep 2011 16:49:55 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, avi@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        riel@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, kvm-ppc@vger.kernel.org,
        aliguori@us.ibm.com, raharper@us.ibm.com, kvm-ia64@vger.kernel.org,
        Glauber Costa <glommer@gmail.com>, mjwolf@us.ibm.com
Subject: Re: [PATCH 0/4] Avoid soft lockup message when KVM is stopped by host
Message-ID: <20110913204955.GD9096@mgebm.net>
References: <1314660435-23293-1-git-send-email-emunson@mgebm.net>
 <20110830122630.GA19450@amt.cnet>
 <4E5FDBDC.2030302@codemonkey.ws>
 <6c387b0ab0b091253c1a1488dd625b94@mgebm.net>
 <20110909132955.GA19459@amt.cnet>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jCrbxBqMcLqd4mOl"
Content-Disposition: inline
In-Reply-To: <20110909132955.GA19459@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jCrbxBqMcLqd4mOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, 09 Sep 2011, Marcelo Tosatti wrote:

> On Thu, Sep 01, 2011 at 02:27:49PM -0600, emunson@mgebm.net wrote:
> > On Thu, 01 Sep 2011 14:24:12 -0500, Anthony Liguori wrote:
> > >On 08/30/2011 07:26 AM, Marcelo Tosatti wrote:
> > >>On Mon, Aug 29, 2011 at 05:27:11PM -0600, Eric B Munson wrote:
> > >>>Currently, when qemu stops a guest kernel that guest will
> > >>>issue a soft lockup
> > >>>message when it resumes.  This set provides the ability for
> > >>>qemu to comminucate
> > >>>to the guest that it has been stopped.  When the guest hits
> > >>>the watchdog on
> > >>>resume it will check if it was suspended before issuing the
> > >>>warning.
> > >>>
> > >>>Eric B Munson (4):
> > >>>   Add flag to indicate that a vm was stopped by the host
> > >>>   Add functions to check if the host has stopped the vm
> > >>>   Add generic stubs for kvm stop check functions
> > >>>   Add check for suspended vm in softlockup detector
> > >>>
> > >>>  arch/x86/include/asm/pvclock-abi.h |    1 +
> > >>>  arch/x86/include/asm/pvclock.h     |    2 ++
> > >>>  arch/x86/kernel/kvmclock.c         |   14 ++++++++++++++
> > >>>  include/asm-generic/pvclock.h      |   14 ++++++++++++++
> > >>>  kernel/watchdog.c                  |   12 ++++++++++++
> > >>>  5 files changed, 43 insertions(+), 0 deletions(-)
> > >>>  create mode 100644 include/asm-generic/pvclock.h
> > >>>
> > >>>--
> > >>>1.7.4.1
> > >>
> > >>How is the host supposed to set this flag?
> > >>
> > >>As mentioned previously, if you save save/restore the offset
> > >>added to
> > >>kvmclock on stop/cont (and the TSC MSR, forgot to mention that), no
> > >>paravirt infrastructure is required. Which means the issue is
> > >>also fixed
> > >>for older guests.
> > >

Marcelo,

I think that stopping the TSC is the wrong approach because it will break time
between the two systems so timething that expects the monotonic clock to move
consistently will be wrong.  IMO, messing with the TSC at run time to avoid a
watchdog message is the wrong solution, better to teach the watchdog to ignore
this special case.

Thanks,
Eric

--jCrbxBqMcLqd4mOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOb8HzAAoJEH65iIruGRnNMUsH/09X1qSCsJIRCf+bSRRbc+ic
6uSQwW+n/A+NqhLdzo7q/Ao4Z58gkwWYW8NarMigJjGVdXleWYBjFDzHe5cSnwBW
zmOVqetVTREcI0VLGVpmWlQLPbwduz0nnEKv3DI8c0+7ZAd+4BbhS9k1oGH9akNP
6SrV6hkEm8Xuw21JW+H7K11JDmRF70HRzqAMWsSiRH515DVWvdL1GOUJObg0jU0M
sf/QVTUExLy3nKTXGh9HQkReU0iKUg3FKRp+opiLw6r+DIakhJCA0rXHDV4iW591
/Xo+UdQHBCyNduAhmH4/DUUL99YliG/L6wLcTJjzag3Gz0yMOexGQ5kZtf0gwu4=
=wrS+
-----END PGP SIGNATURE-----

--jCrbxBqMcLqd4mOl--

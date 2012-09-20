Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab2ITHDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 03:03:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45119 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab2ITHDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 03:03:41 -0400
Date: Thu, 20 Sep 2012 17:03:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the signal tree with the tip tree
Message-Id: <20120920170330.30feaeed3399ecc22551add4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Sep_2012_17_03_30_+1000_0hHYvfdmkveO4L.7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Sep_2012_17_03_30_+1000_0hHYvfdmkveO4L.7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/x86/kernel/process_32.c between commit 304bceda6a18 ("x86, fpu: use
non-lazy fpu restore for processors supporting xsave") from the tip tree
and commits 450ca1f882ab ("x86: get rid of TIF_IRET hackery") and
5daca7153d68 ("x86, um/x86: switch to generic sys_execve and
kernel_execve") from the signal tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/process_32.c
index b9ff83c,9e84b4f..0000000
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@@ -190,6 -190,16 +190,12 @@@ start_thread(struct pt_regs *regs, unsi
  	regs->cs		=3D __USER_CS;
  	regs->ip		=3D new_ip;
  	regs->sp		=3D new_sp;
+ 	regs->flags		=3D X86_EFLAGS_IF;
+ 	/*
 -	 * Free the old FP and other extended state
 -	 */
 -	free_thread_xstate(current);
 -	/*
+ 	 * force it to the iret return path by making it look as if there was
+ 	 * some work pending.
+ 	 */
+ 	set_thread_flag(TIF_NOTIFY_RESUME);
  }
  EXPORT_SYMBOL_GPL(start_thread);
 =20

--Signature=_Thu__20_Sep_2012_17_03_30_+1000_0hHYvfdmkveO4L.7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQWr/CAAoJEECxmPOUX5FEsTAP+gMXFny1LBwWnO5eqiGi1kKx
egt4aVQJvdVQ4xfvC1bseQpAEJ/CEIPkpAE4KpVloFY92JKaT+IXgVIkV3huLZxI
n/BW227U/w3hbsW0R+EWTKXPGqdRFfy3TmIIAAsEemFycJskbCBEFKE+Ni/4fIQI
sZ8S66aNLHz7Rj8C2R6zqyVZwYV9eC5EkSR/vsglR5SRFUFjGV6tv2yggeIqrLAJ
II3VHLmIlqgluSHFMRrAX+GGfZPx8rkOesv+FUWShi+zJLg4ot7dkHLm4KNyLB6t
Na8sKJv23z50g/JvnnzQeYL36JG/jQWzo3hMqEZ/SaiZO3PEROmCPDa5SPD/laLX
cnGH80YHNeMquEqtLr3jJlC0eoPK1JsCBSR/TPt3DtNFbC2GQKFt6ZoPeLtVgqVs
f7TjxNl8UyaM07ubs+PkMdi5pVHb7IlCgGNScN4RWTIIFTB0bYWD7qpQntC82OQe
ifPDsn0ZWc1Hedtr4pIlAwEID00yMXhQ4x5ANJ1zIYRlmsWDwoXHstiEtP5irmWf
7hVnkbPetleQrBuUZ9RfI1IcuOFNjwVfqI9bPKPRNk05ieFsGnCJxt0yxRnmaVFx
JywdkQ0m2TB40izIQWc9JTyqQiYtcYwm+s2D5SoLiM26LYNXggB8QKIng/roQw1m
Wl9OsEEjkTLK60db1cc2
=9N5j
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Sep_2012_17_03_30_+1000_0hHYvfdmkveO4L.7--

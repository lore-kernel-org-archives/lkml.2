Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab2B0Uqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 15:46:51 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47519 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab2B0Uqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 15:46:49 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.218.5 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Mon, 27 Feb 2012 12:45:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.2.8
Message-ID: <20120227204557.GA12105@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.8 kernel.

This is an "interesting" update, in that "only" one bug is being
resolved here, handling a floating point issue with new x86 processors
running in 32bit mode.  But, this also fixes x86-64 issues as well in
this area, so all users are encouraged to upgrade.  If anyone has any
problems, please let us know as soon as possible.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                           |    2=20
 arch/x86/include/asm/i387.h        |  284 +++++++++++++++++++++++++++++---=
-----
 arch/x86/include/asm/processor.h   |    1=20
 arch/x86/include/asm/thread_info.h |    2=20
 arch/x86/kernel/process_32.c       |   25 ---
 arch/x86/kernel/process_64.c       |   29 ---
 arch/x86/kernel/traps.c            |   41 +++--
 arch/x86/kernel/xsave.c            |   12 -
 arch/x86/kvm/vmx.c                 |    2=20
 9 files changed, 269 insertions(+), 129 deletions(-)

Greg Kroah-Hartman (1):
      Linux 3.2.8

Linus Torvalds (10):
      i387: math_state_restore() isn't called from asm
      i387: make irq_fpu_usable() tests more robust
      i387: fix sense of sanity check
      i387: fix x86-64 preemption-unsafe user stack save/restore
      i387: move TS_USEDFPU clearing out of __save_init_fpu and into callers
      i387: don't ever touch TS_USEDFPU directly, use helper functions
      i387: do not preload FPU state at task switch time
      i387: move AMD K7/K8 fpu fxsave/fxrstor workaround from save to resto=
re
      i387: move TS_USEDFPU flag from thread_info to task_struct
      i387: re-introduce FPU state preloading at context switch time


--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPS+uFAAoJEDjbvchgkmk+8kEP/RGbeIn3Zp3XUPIVXY+OWqe0
HsWuApzgL9VdcrfqbM/oo3fJOhs2U5tfa0ZH2TZN88CVk1WvKCY+eIKqImhEBTvq
wK014ImjOiTlOYO+yu1GDCXe0t3hhuOerAGNpSa69KCBZ64u8rahxO/ejG9A/8Hf
Cxs56gZyP40Cz+J8vUigRub6KSXMa9psALy83Hd4B+VU+5pO1V+mFay+5xm3y6RU
Qp8SLB4cpaKjCPaMNYErmgdWCiBukwAYBNNn0KmKkqb0p8LXDBQMYVBlBbMG+5QC
pF/1P+AM70lTke6MvNpdelikjHcpa9auby4GMzWeM3QECuCWKGtfM11eGNhUy7Tv
VVgWzzou/2a7IvAU/b1hD/n7MSrOqB1FnNnlkdwCUxf3VGauSYz3cRF6F0KulvqF
mde5jEMKtkTYfXqr2VASjSEOxbGqALps7nIH5vThzKZTCcX5zgi79VlZcSh2LQOw
tOYVBBA3EyEe1PsgfkCXAOb4uyij5h7aSbm0SF9SYHOLMSasAGnWE9ThiAefEDrh
l1Jg8FjZWVpE+MPlDRTEFwQUDJBS/2hSG8FQQqFLeydpDjgmezVrhhAzsGLsifyp
6YExUBPuBP25jcNn/gZVFaEHB3SFw7By4glwieipkYgMuG1cNXWVXTLpTwRm/uaG
EYBGESJexZ1ezq68bSm4
=Z4Gy
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--

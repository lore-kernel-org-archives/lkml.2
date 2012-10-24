Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935158Ab2JXP07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:26:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:37545 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935005Ab2JXP05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:26:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,640,1344236400"; 
   d="asc'?scan'208";a="237621410"
Date: Wed, 24 Oct 2012 18:27:40 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Pekka Enberg <penberg@kernel.org>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [BUG] lkvm crash on crashkernel boot
Message-ID: <20121024152740.GA25303@otc-wbsnb-06>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I've tried to play with kexec using lkvm. Unfortunately, lkvm crashes when
I try to switch to crashkernel.

I use Linus tree + penberg/kvmtool/next + one x86 mm patch[1].

Kernel is defconfig + kvmconfig. I use the same kernel image for system and
crash env.

Host:

% lkvm run --cpus 1 -m 1024 --params 'crashkernel=3D256M loglevel=3D8'

Guest:

# kexec -p bzImage --reuse-cmdline
# echo c > /proc/sysrq-trigger
=2E..
[    0.947984] loop: module loaded
[    0.950078] virtio-pci 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.950925] virtio-pci 0000:00:01.0: irq 41 for MSI/MSI-X
[    0.952944] virtio-pci 0000:00:01.0: irq 42 for MSI/MSI-X
zsh: segmentation fault (core dumped)  lkvm run --cpus 1 -m 1024 --params '=
crashkernel=3D256M loglevel=3D8'

Guest kernel is somewhere in virtio_net initialization (for the second
time). I'm too lazy to find exact line.

Backtrace:

0  irq__add_msix_route (kvm=3Dkvm@entry=3D0xbf8010, msg=3D0xe3d090) at x86/=
irq.c:210
#1  0x000000000041b3bf in virtio_pci__specific_io_out.isra.5 (offset=3D<opt=
imized out>,=20
    data=3D<optimized out>, kvm=3D0xbf8010) at virtio/pci.c:150
#2  virtio_pci__io_out.9406 (ioport=3D<optimized out>, kvm=3D0xbf8010, port=
=3D<optimized out>,=20
    data=3D<optimized out>, size=3D<optimized out>) at virtio/pci.c:208
#3  0x000000000040f8c3 in kvm__emulate_io (count=3D<optimized out>, size=3D=
2, direction=3D1,=20
    data=3D<optimized out>, port=3D25108, kvm=3D0xbf8010) at ioport.c:165
#4  kvm_cpu__start (cpu=3D<optimized out>) at x86/include/kvm/kvm-cpu-arch.=
h:41
#5  0x0000000000416ca2 in kvm_cpu_thread.2824 (arg=3D<optimized out>) at bu=
iltin-run.c:176
#6  0x00007f701ebd0b50 in start_thread (arg=3D<optimized out>) at pthread_c=
reate.c:304
#7  0x00007f701e1fe70d in clone () at ../sysdeps/unix/sysv/linux/x86_64/clo=
ne.S:112
#8  0x0000000000000000 in ?? ()

[1] https://patchwork.kernel.org/patch/1608411/

--=20
 Kirill A. Shutemov

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQiAjsAAoJEAd+omnVudOMmwwP/3BhajX48h3Tglk5FxmxFFxQ
X2huBl6AwAhKLlt8IXlxebjPTIuDF2Z+168xCJA8rRwLiEItCYcwzyvP54fqIRqy
docU0Wf2LvNp14Y7VEW6sRh54IJXDl1Bt+pABsviSaSLa5H5gpknPFxZck06j+7J
P4w6NIKNgNhq3+y7cACRnF2rL2wujR1b1mKY1VvrLHH19aDBLty7a1A2rZrog+vq
7CEugwC8T5C48EF6CViHDczIBqdhGyWvl+ALeRYPxXy2N/yg5Q20iORDJYHtXpJg
Zb2QwArEHpIwDBlTfE91/8iUH047ldnhbfMVrqkYOK4KD58Nus9kgNP2p3KKRIRm
uVa5/NCb9N92YPv32mLhIHvsRTyligS4rlvJNJZe9cGR6Dr7hUyezrxhhVAnTbrV
0H8ubagO4vgwHIR4NvJU7J80NQSTZ5EpJRy+joXyO8Upl9kXemCYKB4tUFaMKgri
QFHdELG7d+2P8o3bvfXjF+p0chxTwsIiWlO3PtGkA5PQ/ibw13/A5St7FXzfgez+
gsqEuyoganerw5T0wZm4icMgie7aTd+lw0QxMoF3f9P8dbBW6W4VQl3n/e2bdr+A
FdLrO2peIaPT++OMw4f7K3ZZI75W2B1cUCbY4fMgKj1+iJrfOrwLc1V6U1lp/+wJ
27quF0Kq/uBesaVH60AX
=6EPR
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--

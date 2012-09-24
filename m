Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab2IXNGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 09:06:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36277 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab2IXNGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:06:30 -0400
Date: Mon, 24 Sep 2012 23:06:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the akpm tree with the vfs tree
Message-Id: <20120924230622.1ce14dfa53b01355b1898589@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_23_06_22_+1000_K3xBDc1zoop47FDW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_23_06_22_+1000_K3xBDc1zoop47FDW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in mm/nommu.c
between commit f9bd4f3ed24d ("make get_file() return its argument") from
the vfs tree and commit "mm: kill vma flag VM_EXECUTABLE and
mm->num_exe_file_vmas" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/nommu.c
index 98318dc,5583325..0000000
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@@ -1282,12 -1279,10 +1279,8 @@@ unsigned long do_mmap_pgoff(struct fil
  	vma->vm_pgoff =3D pgoff;
 =20
  	if (file) {
 -		region->vm_file =3D file;
 -		get_file(file);
 -		vma->vm_file =3D file;
 -		get_file(file);
 +		region->vm_file =3D get_file(file);
 +		vma->vm_file =3D get_file(file);
- 		if (vm_flags & VM_EXECUTABLE) {
- 			added_exe_file_vma(current->mm);
- 			vma->vm_mm =3D current->mm;
- 		}
  	}
 =20
  	down_write(&nommu_region_sem);

--Signature=_Mon__24_Sep_2012_23_06_22_+1000_K3xBDc1zoop47FDW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYFrOAAoJEECxmPOUX5FE7O8P/jzM7Uhat9o6cvAGBE9rLUfH
b2NC26J4N1AO2NeEdbRX+QrKe6HizOcRfQtqeTFKuVFrqnqPP7t83Uhb+XdpYrSt
hhYZvI6hX+gyKtXwyLSVxuejQxlYTI+apiru9W79kFjRXwzhzCewnDTqoFS1W9/z
Y8BtNNEM78dcRDmYxC6NLWpx9qIE2QlPi80qUldxH1n7RFwwbnHxMdgN5cmlWDnC
6KdycoXPSjAETKyCsT/+lq2mbEOr33dtfM9pQSztFe+mpOUo3B5m0P/Yz4MvOj2F
qs75nTwyLNmrmpbUFHmsQPHvgtVn8+oihNSGq49Dsew1E4ifIuzAiY7v+ZUG0CzO
wxfgE2i0PaM0KUPUfWNA8k3so+hK0R8x1dyIOxHfW8jy7VNMlDkhOvuTFvUNeKY/
1wDUqQAuse0Mk1bjnYmoKFUy+yKjhMyCv7WDSsFiburTkOIl4E/u6tZ2HoRWrpYZ
yd7JGuxzteOWCbSrkTa2jBHAkZz1nrhGTuYRcmV4gc9uIIYBqNWRkZZ+a9O2wMYg
YRAiya1lKVwqYvanYycdn3Fpk6Kfyy9PiXkcdAhXFWrlab7AfZ8yH5BEwqW4R0Zb
mmMtCbHR9SyxNd4ZVE3cnKUiwQQ5mfQUIagjKC4e5BSxEEosJaGZDdujmafhAABq
MmxfboeumL9eZnAX9qpD
=/3qW
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_23_06_22_+1000_K3xBDc1zoop47FDW--

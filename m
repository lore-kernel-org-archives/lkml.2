Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1KYRy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 12:54:26 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:39765 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab1KYRyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 12:54:25 -0500
Message-ID: <4ECFD645.2060201@web.de>
Date: Fri, 25 Nov 2011 15:54:13 -0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Liu Ping Fan <kernelfans@gmail.com>
CC: kvm@vger.kernel.org, qemu-devel@nongnu.org, linux-kernel@vger.kernel.org,
        avi@redhat.com, aliguori@us.ibm.com, ryanh@us.ibm.com
Subject: Re: [PATCH 0] A series patches for kvm&qemu to enable vcpu destruction
 in kvm
References: <1322188529-11609-1-git-send-email-kernelfans@gmail.com>
In-Reply-To: <1322188529-11609-1-git-send-email-kernelfans@gmail.com>
X-Enigmail-Version: 1.3.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC7C86A50CE315BFF8BF300E7"
X-Provags-ID: V02:K0:kAxerayRtJqI38N7Y41c1M9a4sYYnThk9nDlcN4zcIf
 xgXOWFy2xe0vJnF1JJVVcQCrcXQ416lVMKGq8JSS3Zp1LSILiS
 orjbAZMEVtmGxaBDCTFqH3KHisRZutUpb+pPagEYdDPXuW9+XJ
 ezc1yd+ccQbD7y0GDnA/ABvtrTqm/WBB8uOr+ulzlUI56PQB7J
 jF99n4TRf25xxeCval1SA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC7C86A50CE315BFF8BF300E7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 2011-11-25 00:35, Liu Ping Fan wrote:
> A series of patches from kvm, qemu to guest. These patches will finally=
 enable vcpu destruction in kvm instance and let vcpu thread exit in qemu=
=2E
> =20
> Currently, the vcpu online feature enables the dynamical creation of vc=
pu and vcpu thread, while the offline feature can not destruct the vcpu a=
nd let vcpu thread exit, it just halt in kvm. Because currently, the vcpu=
 will only be destructed when kvm instance is destroyed. We can=20
> change vcpu as an refer of kvm instance, and then vcpu's destruction MU=
ST and CAN come before kvm's destruction.
>=20
> These patches use guest driver to notify the CPU_DEAD event to qemu, an=
d later qemu asks kvm to release the dead vcpu and finally exit the=20
> thread.=20
> The usage is:=20
> 	qemu$cpu_set n online
> 	qemu$cpu_set n zap   ------------ This will destroy the vcpu-n in kvm =
and let vcpu thread exit
>      OR=09
> 	qemu$cpu_set n offline 	--------- This will just block vcpu-n in kvm
>=20
> Any comment and suggestion are welcome.

The cpu_set command will probably not make it to QEMU upstream
(device_add/delete is the way to go - IMHO). So I would refrain from
adding anything to qemu-kvm at this point anyway. Also, what would be
the advantage of 'zap' from user perspective?

>=20
>=20
> Patches include:
> |-- guest
> |   `-- 0001-virtio-add-a-pci-driver-to-notify-host-the-CPU_DEAD-.patch=

> |-- kvm
> |   |-- 0001-kvm-make-vcpu-life-cycle-separated-from-kvm-instance.patch=

> |   `-- 0002-kvm-exit-to-userspace-with-reason-KVM_EXIT_VCPU_DEAD.patch=

> `-- qemu
>     |-- 0001-Add-cpu_phyid_to_cpu-to-map-cpu-phyid-to-CPUState.patch
>     |-- 0002-Add-cpu_free-to-support-arch-related-CPUState-releas.patch=

>     |-- 0003-Introduce-a-pci-device-cpustate-to-get-CPU_DEAD-even.patch=

>     |-- 0004-Release-vcpu-and-finally-exit-vcpu-thread-safely.patch
>     `-- 0005-tmp-patches-for-linux-header-files.patch
>=20

I only found kvm patch 0001 so far. Something probably went wrong with
your postings.

Jan


--------------enigC7C86A50CE315BFF8BF300E7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7P1koACgkQitSsb3rl5xTFEgCeLKCL1pZDL6cwfodfh0QjVs8s
i5oAoNiEe23pzG62G67R45WgeRe+WUrU
=n5wB
-----END PGP SIGNATURE-----

--------------enigC7C86A50CE315BFF8BF300E7--

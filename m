Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab1ATTQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 14:16:33 -0500
Received: from outgoing.selfhost.de ([82.98.87.70]:37256 "EHLO
	outgoing.selfhost.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab1ATTQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 14:16:32 -0500
Message-ID: <4D388A08.1010004@afaics.de>
Date: Thu, 20 Jan 2011 20:16:24 +0100
From: Harald Dunkel <harri@afaics.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101210 Thunderbird/3.1.7
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: how to avoid that install.sh goes mad, if I am not root?
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi folks,

I am trying to build my own custom Debian kernel package. Problem:
If the kernel is supposed to be installed in a temporary package
build directory, then it dies with

:
:
make[1]: Entering directory `/var/tmp/build_kernel/raw-kernel-2.6.37/linux-2.6.37'
sh /var/tmp/build_kernel/raw-kernel-2.6.37/linux-2.6.37/arch/x86/boot/install.sh 2.6.37 arch/x86/boot/bzImage \
                System.map "/var/tmp/build_kernel/raw-kernel-2.6.37/debian/raw-kernel-2.6.37/boot"
run-parts: executing /etc/kernel/postinst.d/dkms 2.6.37 /var/tmp/build_kernel/raw-kernel-2.6.37/debian/raw-kernel-2.6.37/boot/vmlinuz-2.6.37
dkms: running auto installation service for kernel 2.6.37:
      nvidia-current (260.19.29)...done.
      vboxhost (3.2.12)...done.
run-parts: executing /etc/kernel/postinst.d/initramfs-tools 2.6.37 /var/tmp/build_kernel/raw-kernel-2.6.37/debian/raw-kernel-2.6.37/boot/vmlinuz-2.6.37
run-parts: executing /etc/kernel/postinst.d/pm-utils 2.6.37 /var/tmp/build_kernel/raw-kernel-2.6.37/debian/raw-kernel-2.6.37/boot/vmlinuz-2.6.37
touch: cannot touch `/var/run/do-not-hibernate': Permission denied
run-parts: /etc/kernel/postinst.d/pm-utils exited with return code 1
make[3]: *** [install] Error 1
make[2]: *** [install] Error 2
make[1]: *** [sub-make] Error 2
make[1]: Leaving directory `/var/tmp/build_kernel/raw-kernel-2.6.37/linux-2.6.37'


AFAICS this happens because the arch/x86/boot/install.sh script calls
/sbin/installkernel, which in turn runs all the scripts delivered
by various other packages. This is fine for a regular kernel install
as well as for an installation of the final kernel package, but for
a non-root install in a package build directory /sbin/installkernel
and all the run-parts scripts should not be run. installkernel doesn't
even know the redefined install directory.

Would it be possible to avoid that /sbin/installkernel is run by
install,sh, e.g. if the install directory has been redefined, or if
UID != 0?


Any helpful comment would be highly appreciated

Harri
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk04igIACgkQUTlbRTxpHjcO3wCcCXsb6ma4ypqQliWi8XYyFcUE
6PYAnA1JP78Bw2uZM4eyr4FHO9uBi0Ex
=zAFX
-----END PGP SIGNATURE-----

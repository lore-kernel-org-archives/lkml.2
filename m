Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705Ab1ATVr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:47:59 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:36873 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755579Ab1ATVr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 16:47:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19768.44428.482148.361069@pilspetsen.it.uu.se>
Date: Thu, 20 Jan 2011 22:47:56 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Harald Dunkel <harri@afaics.de>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: how to avoid that install.sh goes mad, if I am not root?
In-Reply-To: <4D388A08.1010004@afaics.de>
References: <4D388A08.1010004@afaics.de>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Dunkel writes:
 > -----BEGIN PGP SIGNED MESSAGE-----
 > Hash: SHA1
 > 
 > Hi folks,
 > 
 > I am trying to build my own custom Debian kernel package. Problem:
 > If the kernel is supposed to be installed in a temporary package
 > build directory, then it dies with
 > 
 > :
 > :
 > make[1]: Entering directory `/var/tmp/build_kernel/raw-kernel-2.6.37/linux-2.6.37'
 > sh /var/tmp/build_kernel/raw-kernel-2.6.37/linux-2.6.37/arch/x86/boot/install.sh 2.6.37 arch/x86/boot/bzImage \
 >                 System.map "/var/tmp/build_kernel/raw-kernel-2.6.37/debian/raw-kernel-2.6.37/boot"
 > run-parts: executing /etc/kernel/postinst.d/dkms 2.6.37 /var/tmp/build_kernel/raw-kernel-2.6.37/debian/raw-kernel-2.6.37/boot/vmlinuz-2.6.37
 > dkms: running auto installation service for kernel 2.6.37:
 >       nvidia-current (260.19.29)...done.
 >       vboxhost (3.2.12)...done.
 > run-parts: executing /etc/kernel/postinst.d/initramfs-tools 2.6.37 /var/tmp/build_kernel/raw-kernel-2.6.37/debian/raw-kernel-2.6.37/boot/vmlinuz-2.6.37
 > run-parts: executing /etc/kernel/postinst.d/pm-utils 2.6.37 /var/tmp/build_kernel/raw-kernel-2.6.37/debian/raw-kernel-2.6.37/boot/vmlinuz-2.6.37
 > touch: cannot touch `/var/run/do-not-hibernate': Permission denied
 > run-parts: /etc/kernel/postinst.d/pm-utils exited with return code 1
 > make[3]: *** [install] Error 1
 > make[2]: *** [install] Error 2
 > make[1]: *** [sub-make] Error 2
 > make[1]: Leaving directory `/var/tmp/build_kernel/raw-kernel-2.6.37/linux-2.6.37'
 > 
 > 
 > AFAICS this happens because the arch/x86/boot/install.sh script calls
 > /sbin/installkernel, which in turn runs all the scripts delivered
 > by various other packages. This is fine for a regular kernel install
 > as well as for an installation of the final kernel package, but for
 > a non-root install in a package build directory /sbin/installkernel
 > and all the run-parts scripts should not be run. installkernel doesn't
 > even know the redefined install directory.
 > 
 > Would it be possible to avoid that /sbin/installkernel is run by
 > install,sh, e.g. if the install directory has been redefined, or if
 > UID != 0?
 > 
 > 
 > Any helpful comment would be highly appreciated

First, at least on x86, the kernel will look for the 'installkernel'
executable first in your own ~/bin/, so if you have that then it will
override /sbin/installkernel.

Second, you don't have to let the kernel choose; just run
/path/to/myinstallkernel $kernelversion path/to/boot/image System.map
(Disadvantage: path/to/boot/image varies depending on arch.)

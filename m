Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab0JTCzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 22:55:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52134 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938Ab0JTCzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 22:55:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=vktjxukvjaG5+FC4nSRagTgBRmPBXT2g5kO4CQeyxH7usIaEOcjj4Wjx3nUHW/z1ae
         adS4A1fBSliymoYxwP9Zx5zUf+/+TDBz5WL4ele1j5swO+tDezDWawWQwuA2THPpGe+g
         bJwpVLGwC45HvPvVtUyCpFgYyvU3PkTEAJCLg=
MIME-Version: 1.0
Date: Tue, 19 Oct 2010 19:55:40 -0700
Message-ID: <AANLkTi=kHWqg32TFVjX5GT+R2hDPcadxsvYhL7RXiGsp@mail.gmail.com>
Subject: x86_32 compile error with the latest Mainline
From: Justin Mattock <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

looking into upstart, I realize I need to have an image in order to
load the policy
at boot... so after learning something new(normally make, make install
is just fine)
I seem to be hitting some thing with dpkg-gencontrol

make-kpkg  --initrd --rootcmd fakeroot --revision=1
--append-to-version -justin-rt kernel_image kernel_headers
(probably have something wrong)

and the error:

	    -e 's/=ST/linux/g'  -e 's/=R//g' \
            -e 's/=KPV/12.032/g'                       \
	    -e 's/=K/vmlinuz/g'           \
	    -e 's@=MK@@g' -e 's@=A@i386@g'   \
	    -e 's/=I/YES/g'     -e 's,=D,/boot,g'        \
	    -e 's/=MD//g'                                \
	    -e 's@=M@@g'    -e 's/=OF//g'    \
	    -e 's/=S//g' -e 's@=B@i386@g'     \
	 ./debian/templates.l10n   > ./debian/templates.master
install -p    -o root -g root  -m  644 ./debian/templates.master
/home/kernel/2.6.37/debian/linux-image-2.6.36-rc8-justin-rt+/DEBIAN/templates
dpkg-gencontrol -DArchitecture=i386 -isp	     \
			-plinux-image-2.6.36-rc8-justin-rt+
-P/home/kernel/2.6.37/debian/linux-image-2.6.36-rc8-justin-rt+/
dpkg-gencontrol: error: package linux-image-2.6.36-rc8-justin-rt+ not
in control info
make[2]: *** [debian/stamp/binary/linux-image-2.6.36-rc8-justin-rt+] Error 255
make[2]: Leaving directory `/home/kernel/2.6.37'
make[1]: *** [debian/stamp/binary/pre-linux-image-2.6.36-rc8-justin-rt+] Error 2
make[1]: Leaving directory `/home/kernel/2.6.37'
make: *** [kernel_image] Error 2


I've gone in an enabled/disabled CONFIG_LOCALVERSION but still errors
out both ways..

any ideas on what I did wrong?
BTW: also noticed this thread as well
http://www.gossamer-threads.com/lists/linux/kernel/1266036

-- 
Justin P. Mattock

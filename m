Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab0HVMY6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 08:24:58 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53097 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab0HVMY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 08:24:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=WuwcR/eJDPk9s57Nq3Sypah+XaBQfH4KhIto9hZr6RVBkqjxIoZdlq7vi0urKAeovp
         BI1k2wyHCkDjWdvOhe4vYOyc93rQIovlRrgr8n3D1cjYZ5dzaa4r/BSNzZz8tS4ZGLpA
         18Vq/kLjMfMuwJwr0O1q2K8i6uAE7HtBXDObM=
MIME-Version: 1.0
Date: Sun, 22 Aug 2010 15:24:55 +0300
Message-ID: <AANLkTinAqJdEPpTFsmY8rWYqy84qGsWVbL9VphOur+PT@mail.gmail.com>
Subject: Ubuntu 10.10 Kernel compile error
From: Anca Emanuel <anca.emanuel@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steps to reproduce on Ubuntu 10.10

1. sudo apt-get install git-core kernel-package fakeroot
build-essential ncurses-dev
2. git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
3. cd linux-2.6
4. cp /boot/config-`uname -r` .config
5. yes '' | make oldconfig
6. make nconfig
and select to not make the staging drivers
7. make-kpkg clean
8. CONCURRENCY_LEVEL=`getconf _NPROCESSORS_ONLN` fakeroot make-kpkg
--initrd --append-to-version=-c kernel_image kernel_headers

result:

dpkg-gencontrol: error: package linux-image-2.6.36-rc1-c+ not in control info
make[2]: *** [debian/stamp/binary/linux-image-2.6.36-rc1-c+] Error 255
make[2]: Leaving directory `/home/username/linux-2.6'
make[1]: *** [debian/stamp/binary/pre-linux-image-2.6.36-rc1-c+] Error 2
make[1]: Leaving directory `/home/username/linux-2.6'
make: *** [kernel_image] Error 2

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab1JXTEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 15:04:35 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52282 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab1JXTEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 15:04:34 -0400
Message-ID: <4EA5B6BF.8030908@gmail.com>
Date: Mon, 24 Oct 2011 14:04:31 -0500
From: "Steven R. Wright" <srw6666@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: make-kpkg target failing for v3.1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

while trying to build kernel v3.1 today,  i ran into this error:

****************************************
create_md5sums_fn () { cd $1 ; find . -type f ! -regex './DEBIAN/.*' ! 
-regex './var/.*'      -printf '%P\0' | xargs -r0 md5sum > 
DEBIAN/md5sums ; if [ -z "DEBIAN/md5sums" ] ; then rm -f 
"DEBIAN/md5sums" ; fi ; } ; create_md5sums_fn              
/usr/src/linux-3.1/debian/linux-image-3.1.0
chmod -R og=rX                 /usr/src/linux-3.1/debian/linux-image-3.1.0
chown -R root:root             /usr/src/linux-3.1/debian/linux-image-3.1.0
dpkg --build                   
/usr/src/linux-3.1/debian/linux-image-3.1.0 ..
dpkg-deb: error: control directory has bad permissions 2755 (must be 
 >=0755 and <=0775)
make[2]: *** [debian/stamp/binary/linux-image-3.1.0] Error 2
make[2]: Leaving directory `/usr/src/linux-3.1'
make[1]: *** [debian/stamp/binary/pre-linux-image-3.1.0] Error 2
make[1]: Leaving directory `/usr/src/linux-3.1'
make: *** [kernel_image] Error 2
****************************************

i have not encountered this error building the kernel in v3.0.4 and 
before (i generally build and install most of the new stable releases, 
and have done so since v.2.4). the command i used, and always have, was:
make-kpkg --initrd --rootcmd fakeroot kernel_image


there is a difference in the perms in a 3.1 build tree vs. a 3.0.4 tree
#52 decca:/usr/src/linux-3.1/debian
 > ls -l | egrep "^d"
drwxr-sr-x 2 root root  4096 Nov 18  2010 Config
drwxr-sr-x 3 root root  4096 Nov 18  2010 docs
drwxr-sr-x 3 root root  4096 Nov 18  2010 examples
drwxr-sr-x 7 root root  4096 Oct 24 13:55 linux-image-3.1.0
drwxr-sr-x 7 root root  4096 Mar 17  2010 pkg
drwxr-sr-x 2 root root  4096 Nov 18  2010 po
drwxr-sr-x 6 root root  4096 Nov 18  2010 ruleset
drwxr-sr-x 2 root root  4096 Nov 18  2010 scripts
drwxr-sr-x 6 root src   4096 Oct 24 13:55 stamp

#64 decca:/usr/src/linux-3.0.4/debian
 >  ls -l | egrep "^d"
drwxr-xr-x 2 root root  4096 Nov 18  2010 Config
drwxr-xr-x 3 root root  4096 Nov 18  2010 docs
drwxr-xr-x 3 root root  4096 Nov 18  2010 examples
drwxr-xr-x 7 root root  4096 Aug 30 11:37 linux-image-3.0.4
drwxr-xr-x 7 root root  4096 Mar 17  2010 pkg
drwxr-xr-x 2 root root  4096 Nov 18  2010 po
drwxr-xr-x 6 root root  4096 Nov 18  2010 ruleset
drwxr-xr-x 2 root root  4096 Nov 18  2010 scripts
drwxr-xr-x 6 root root  4096 Aug 30 11:37 stamp

while it certainly *looks* like the "chmod og=rX" should take place in 
the 3.0.4 build process,  the directory does not reflect it,  and the 
dpkg-deb process is content and completes.

sRw



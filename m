Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab0K0SVm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 13:21:42 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43654 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab0K0SVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 13:21:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=X0HS/FpKOViUrEJn1ro5F+gGjruBlCNfATggU0NNmXXD5FowiPzR+bMLSi91c0KVDh
         Q9XR/zXVhCVh396hMZOrRIHuBdn+8Jey9yyQ7dFIVqjrc5VPuPmd3vPqt0ZL7EZAT7BL
         PGhln8gAQ8To+Nm4gKRcDnmcE4LblOd5gBFNs=
From: Jason Vas Dias <jason.vas.dias@gmail.com>
Reply-To: jason.vas.dias@gmail.com
To: linux-kernel@vger.kernel.org
Subject: per-chroot clock module ?
Date: Sat, 27 Nov 2010 18:21:34 +0000
User-Agent: KMail/1.12.4 (Linux/2.6.34-jvd; KDE/4.3.4; x86_64; svn-1073138; 2010-01-11)
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011271821.35039.jason.vas.dias@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings -

Sorry in advance if this is a stupid idea, but -

I'd really like to be able to set a distinct "clock" for a specific chroot environment, 
such that the super-user could call :
   const char *my_chroot_directory = "/some_chroot";
   struct stat st;
   if(stat( my_chroot_directory, &st) ==0)
         sys_clock_settime ((clockid_t) st.st_inode,  (struct timespec *)tp)
   ( from glibc )
and there would be a real-time clock offset association in the kernel between the 
inode number of the directory to which a "chroot" has succeeded,  and a real-time
clock offset , so that ALL processes that run with their "root" directory of such
chroot directories can get the same values for time() or gettimeofday() which would be
offset from the real-time clock by the current offset of the last "clock_settime(inode, timespec)" 
second parameter for that directory inode (first parameter). 
Eventually,  the coreutils "date(1)" command could be extended to support setting the system 
date and time for different chroot() root directories.

Does anyone know of a module that does this ?

If not, and if no-one convinces me this is a stupid idea, I'm going to write one.

Thanks in advance for any replies,
All the best,
Jason Vas Dias (a software engineer) <jason.vas.dias@gmail.com>




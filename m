Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab0ERUK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 16:10:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43477 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab0ERUKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 16:10:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eLW3TX049Nf+jOwePlE/J9JEt13/x/4KyR/4qMn37IMbfuNU7vyb12mba2NY0s4FcO
         VRyh11wB7l3XGR09TE7dRYkmrQafUwWnFMLzuqOHIcMqnXAM1nXBxS/wwLv8cLR5vVZU
         YdcPb9wglbOPJ8EQySjpFKMeu0tiQ09g+1WoY=
Subject: Re: [tip:x86/fpu] x86: Add new static_cpu_has() function using
 alternatives
From: Eric Dumazet <eric.dumazet@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de, avi@redhat.com
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-a3c8acd04376d604370dcb6cd2143c9c14078a50@git.kernel.org>
References: <1273135546-29690-2-git-send-email-avi@redhat.com>
	 <tip-a3c8acd04376d604370dcb6cd2143c9c14078a50@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 22:10:43 +0200
Message-ID: <1274213443.2485.3.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 12 mai 2010 à 01:06 +0000, tip-bot for H. Peter Anvin a
écrit :
> Commit-ID:  a3c8acd04376d604370dcb6cd2143c9c14078a50
> Gitweb:     http://git.kernel.org/tip/a3c8acd04376d604370dcb6cd2143c9c14078a50
> Author:     H. Peter Anvin <hpa@zytor.com>
> AuthorDate: Tue, 11 May 2010 17:47:07 -0700
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Tue, 11 May 2010 17:47:07 -0700
> 
> x86: Add new static_cpu_has() function using alternatives
> 
> For CPU-feature-specific code that touches performance-critical paths,
> introduce a static patching version of [boot_]cpu_has().  This is run
> at alternatives time and is therefore not appropriate for most
> initialization code, but on the other hand initialization code is
> generally not performance critical.
> 
> On gcc 4.5+ this uses the new "asm goto" feature.

Might be time to change Documentation/Changes about gcc requirements ...

# make
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CC      arch/x86/kernel/process_32.o
/usr/src/linux-2.6/arch/x86/include/asm/cpufeature.h: In function
`prepare_to_copy':
/usr/src/linux-2.6/arch/x86/include/asm/cpufeature.h:315: warning: asm
operand 1 probably doesn't match constraints
/usr/src/linux-2.6/arch/x86/include/asm/cpufeature.h:315: error:
impossible constraint in `asm'
/usr/src/linux-2.6/arch/x86/include/asm/cpufeature.h:313: warning:
'flag' might be used uninitialized in this function
make[2]: *** [arch/x86/kernel/process_32.o] Error 1
make[1]: *** [arch/x86/kernel] Error 2
make: *** [arch/x86] Error 2
# gcc -v
Reading specs from /usr/lib/gcc/i386-redhat-linux/3.4.6/specs
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
--infodir=/usr/share/info --enable-shared --enable-threads=posix
--disable-checking --with-system-zlib --enable-__cxa_atexit
--disable-libunwind-exceptions --enable-java-awt=gtk
--host=i386-redhat-linux
Thread model: posix
gcc version 3.4.6 20060404 (Red Hat 3.4.6-10)




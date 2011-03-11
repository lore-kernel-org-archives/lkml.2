Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab1CKRlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 12:41:53 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32812 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab1CKRlu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 12:41:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc
         :content-type:content-transfer-encoding;
        b=C6RQfg5uXZXTwUP95J342Mi1ZdsAtwWeklxfZPcXEm4vsgMi01lIKMcEHFsUK6IX/C
         JUDwHhSc90gYEeWxN/2g6uJ4phKinj6BGvhNmtUeZGDzsO3/EAJVwlv+IdlJZ+O74P6x
         ZifS9UAWY5Xgli9Bvz0g3imBn9ciTv3dPfQ7g=
MIME-Version: 1.0
Reply-To: linasvepstas@gmail.com
From: Linas Vepstas <linasvepstas@gmail.com>
Date: Fri, 11 Mar 2011 11:40:50 -0600
Message-ID: <AANLkTim6CApZ3y0ZXKR-bWa3ZEAaVOXUj14igruC06in@mail.gmail.com>
Subject: PATCH: generic/fcntl.h [was Re: asm-generic/unistd.h and glibc use of NR_ipc]
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Arnd Bergmann <arnd@arndb.de>, GLIBC Devel <libc-alpha@sourceware.org>,
        linux-kernel@vger.kernel.org, libc-ports@sourceware.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

Another patch, to generic/fcntl.h, at bottom.

On 28 September 2010 08:05, Chris Metcalf <cmetcalf@tilera.com> wrote:
>  (Adding libc-ports to the cc list.)
>
> On 9/28/2010 4:40 AM, Arnd Bergmann wrote:
>> Chris Metcalf is using the generic unistd.h file on the tile architecture
>> and has a glibc port that should be easily portable to all future
>> architectures. There are a few of them getting ready to be merged
>> now (c6x, lm32, nios2, and some people have contacted me privately
>> for architectures I cannot name).
>>
>> I expect that all of them will just use the same syscall ABI and glibc
>> port.
>
> I'm happy to provide some previews of the work I'm doing to interested parties.

[...]

> Thanks in advance for any feedback.  Please keep me cc'ed on any
> discussions of the generic Linux syscall ABI.  Thanks!
>
> sysdeps/unix/sysv/linux/generic/access.c
> sysdeps/unix/sysv/linux/generic/bits/fcntl.h

glibc-2.13 breaks without F_GETPIPE_SZ

Closer inspection shows that F_DUPFD_CLOEXEC is usually
protected by __USE_XOPEN2K8 and not __USE_GNU so
I tweaked that; revert if you disagree ...

In lieu of the usual changelog entry ---
Signed-off-by: Linas Vepstas <linasvepsts@gmail.com>

---
 sysdeps/unix/sysv/linux/generic/bits/fcntl.h |    4 ++++
 1 file changed, 4 insertions(+)

Index: glibc-2.13/sysdeps/unix/sysv/linux/generic/bits/fcntl.h
===================================================================
--- glibc-2.13.orig/sysdeps/unix/sysv/linux/generic/bits/fcntl.h
 2011-03-11 11:11:12.000000000 -0600
+++ glibc-2.13/sysdeps/unix/sysv/linux/generic/bits/fcntl.h
2011-03-11 11:12:26.000000000 -0600
@@ -114,6 +114,10 @@
 # define F_SETLEASE    1024    /* Set a lease.  */
 # define F_GETLEASE    1025    /* Enquire what lease is active.  */
 # define F_NOTIFY      1026    /* Request notfications on a directory.  */
+# define F_SETPIPE_SZ   1031  /* Set pipe page size array.  */
+# define F_GETPIPE_SZ   1032  /* Set pipe page size array.  */
+#endif
+#ifdef __USE_XOPEN2K8
 # define F_DUPFD_CLOEXEC 1030  /* Duplicate file descriptor with
                                   close-on-exit set.  */
 #endif

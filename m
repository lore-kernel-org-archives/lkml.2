Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab0ERU7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 16:59:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48483 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab0ERU7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 16:59:04 -0400
Message-ID: <4BF2FF82.7090005@zytor.com>
Date: Tue, 18 May 2010 13:58:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, avi@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/fpu] x86: Add new static_cpu_has() function using alternatives
References: <1273135546-29690-2-git-send-email-avi@redhat.com>	 <tip-a3c8acd04376d604370dcb6cd2143c9c14078a50@git.kernel.org> <1274213443.2485.3.camel@edumazet-laptop>
In-Reply-To: <1274213443.2485.3.camel@edumazet-laptop>
Content-Type: multipart/mixed;
 boundary="------------020601000300000601060305"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020601000300000601060305
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05/18/2010 01:10 PM, Eric Dumazet wrote:
> 
> Might be time to change Documentation/Changes about gcc requirements ...
> 
> # make
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   CC      arch/x86/kernel/process_32.o
> /usr/src/linux-2.6/arch/x86/include/asm/cpufeature.h: In function
> `prepare_to_copy':
> /usr/src/linux-2.6/arch/x86/include/asm/cpufeature.h:315: warning: asm
> operand 1 probably doesn't match constraints
> /usr/src/linux-2.6/arch/x86/include/asm/cpufeature.h:315: error:
> impossible constraint in `asm'
> /usr/src/linux-2.6/arch/x86/include/asm/cpufeature.h:313: warning:
> 'flag' might be used uninitialized in this function
> make[2]: *** [arch/x86/kernel/process_32.o] Error 1
> make[1]: *** [arch/x86/kernel] Error 2
> make: *** [arch/x86] Error 2
> # gcc -v
> Reading specs from /usr/lib/gcc/i386-redhat-linux/3.4.6/specs
> Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
> --infodir=/usr/share/info --enable-shared --enable-threads=posix
> --disable-checking --with-system-zlib --enable-__cxa_atexit
> --disable-libunwind-exceptions --enable-java-awt=gtk
> --host=i386-redhat-linux
> Thread model: posix
> gcc version 3.4.6 20060404 (Red Hat 3.4.6-10)
> 

Here is the fallback patch if you want to test it.

	-hpa

--------------020601000300000601060305
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="diff"

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmUuaCBiL2FyY2gv
eDg2L2luY2x1ZGUvYXNtL2NwdWZlYXR1cmUuaAppbmRleCBkY2E5YzU0Li40NjgxNDU5IDEw
MDY0NAotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9jcHVmZWF0dXJlLmgKKysrIGIvYXJj
aC94ODYvaW5jbHVkZS9hc20vY3B1ZmVhdHVyZS5oCkBAIC0zMzIsNiArMzMyLDcgQEAgc3Rh
dGljIF9fYWx3YXlzX2lubGluZSBfX3B1cmUgYm9vbCBfX3N0YXRpY19jcHVfaGFzKHU4IGJp
dCkKICNlbmRpZgogfQogCisjaWYgX19HTlVDX18gPj0gNAogI2RlZmluZSBzdGF0aWNfY3B1
X2hhcyhiaXQpCQkJCQlcCiAoCQkJCQkJCQlcCiAJX19idWlsdGluX2NvbnN0YW50X3AoYm9v
dF9jcHVfaGFzKGJpdCkpID8JCVwKQEAgLTM0MCw2ICszNDEsMTIgQEAgc3RhdGljIF9fYWx3
YXlzX2lubGluZSBfX3B1cmUgYm9vbCBfX3N0YXRpY19jcHVfaGFzKHU4IGJpdCkKIAkJX19z
dGF0aWNfY3B1X2hhcyhiaXQpIDoJCQkJXAogCQlib290X2NwdV9oYXMoYml0KQkJCQlcCiAp
CisjZWxzZQorLyoKKyAqIGdjYyAzLnggaXMgdG9vIHN0dXBpZCB0byBkbyB0aGUgc3RhdGlj
IHRlc3Q7IGZhbGwgYmFjayB0byBkeW5hbWljLgorICovCisjZGVmaW5lIHN0YXRpY19jcHVf
aGFzKGJpdCkgYm9vdF9jcHVfaGFzKGJpdCkKKyNlbmRpZgogCiAjZW5kaWYgLyogZGVmaW5l
ZChfX0tFUk5FTF9fKSAmJiAhZGVmaW5lZChfX0FTU0VNQkxZX18pICovCiAK
--------------020601000300000601060305--

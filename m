Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab1GYWiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 18:38:20 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:61667 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab1GYWiQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 18:38:16 -0400
MIME-Version: 1.0
In-Reply-To: <1311625197.3526.35.camel@gandalf.stny.rr.com>
References: <1310982010-13849-1-git-send-email-wangshaoyan.pt@taobao.com>
	<1311618747.3526.32.camel@gandalf.stny.rr.com>
	<CACqU3MVJ9Oj4pXH9O_2jnqDVBqKA+AgoWHwP-n2HGD4LU0pMHQ@mail.gmail.com>
	<1311625197.3526.35.camel@gandalf.stny.rr.com>
Date: Mon, 25 Jul 2011 18:38:15 -0400
Message-ID: <CACqU3MUKU_0FbOQT+TKLnnaoFVS_QOgzzx-tvunQy94v-eykTw@mail.gmail.com>
Subject: Re: [PATCH] TRACING: Fix a copmile warning
From: Arnaud Lacombe <lacombar@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: stufever@gmail.com, linux-kernel@vger.kernel.org,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 25, 2011 at 4:19 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2011-07-25 at 15:43 -0400, Arnaud Lacombe wrote:
>
>> Actually, we have a special uninitialized_var(x) macro to handle such
>> false positive. From include/linux/compiler-gcc.h:
>>
>> /*
>>  * A trick to suppress uninitialized variable warning without generating any
>>  * code
>>  */
>> #define uninitialized_var(x) x = x
>
> I'm aware of that too, but I think that is inappropriate as well. As I
> said, some versions of gcc report it, others don't. Seems that gcc 4.6.0
> says this is an error where 4.5.1 does not (I just tried both).
>
did you ? gcc 4.5.1 from Fedora 14 definitively shows the warning:

# make ARCH=i386 kernel/trace/trace_printk.o V=1
[...]
gcc -Wp,-MD,kernel/trace/.trace_printk.o.d  -nostdinc -isystem
/usr/lib/gcc/x86_64-redhat-linux/4.5.1/include [...] -c -o
kernel/trace/trace_printk.o kernel/trace/trace_printk.c
/src/linux/linux/kernel/trace/trace_printk.c: In function
'hold_module_trace_bprintk_format':
/src/linux/linux/kernel/trace/trace_printk.c:52:8: warning: 'fmt' may
be used uninitialized in this function

# gcc -v
gcc -v
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/4.5.1/lto-wrapper
Target: x86_64-redhat-linux
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
--infodir=/usr/share/info
--with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap
--enable-shared --enable-threads=posix --enable-checking=release
--with-system-zlib --enable-__cxa_atexit
--disable-libunwind-exceptions --enable-gnu-unique-object
--enable-linker-build-id
--enable-languages=c,c++,objc,obj-c++,java,fortran,ada,lto
--enable-plugin --enable-java-awt=gtk --disable-dssi
--with-java-home=/usr/lib/jvm/java-1.5.0-gcj-1.5.0.0/jre
--enable-libgcj-multifile --enable-java-maintainer-mode
--with-ecj-jar=/usr/share/java/eclipse-ecj.jar
--disable-libjava-multilib --with-ppl --with-cloog --with-tune=generic
--with-arch_32=i686 --build=x86_64-redhat-linux
Thread model: posix
gcc version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC)

 - Arnaud

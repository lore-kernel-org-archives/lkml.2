Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab1GYXt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 19:49:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39268 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1GYXty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 19:49:54 -0400
X-Authority-Analysis: v=1.1 cv=sbbt6Wn8j+VvNVI1Ftt/uHhinWyuFt+R57MN9Ty2Tys= c=1 sm=0 a=wp_X8QvuP7UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=YMhppL7k-yvyJFBL_mUA:9 a=HP0wG5ovJNupJBSRVpgA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] TRACING: Fix a copmile warning
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: stufever@gmail.com, linux-kernel@vger.kernel.org,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <CACqU3MUKU_0FbOQT+TKLnnaoFVS_QOgzzx-tvunQy94v-eykTw@mail.gmail.com>
References: <1310982010-13849-1-git-send-email-wangshaoyan.pt@taobao.com>
	 <1311618747.3526.32.camel@gandalf.stny.rr.com>
	 <CACqU3MVJ9Oj4pXH9O_2jnqDVBqKA+AgoWHwP-n2HGD4LU0pMHQ@mail.gmail.com>
	 <1311625197.3526.35.camel@gandalf.stny.rr.com>
	 <CACqU3MUKU_0FbOQT+TKLnnaoFVS_QOgzzx-tvunQy94v-eykTw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 25 Jul 2011 19:49:48 -0400
Message-ID: <1311637788.3526.38.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 18:38 -0400, Arnaud Lacombe wrote:
> Hi,
> 
> On Mon, Jul 25, 2011 at 4:19 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Mon, 2011-07-25 at 15:43 -0400, Arnaud Lacombe wrote:
> >
> >> Actually, we have a special uninitialized_var(x) macro to handle such
> >> false positive. From include/linux/compiler-gcc.h:
> >>
> >> /*
> >>  * A trick to suppress uninitialized variable warning without generating any
> >>  * code
> >>  */
> >> #define uninitialized_var(x) x = x
> >
> > I'm aware of that too, but I think that is inappropriate as well. As I
> > said, some versions of gcc report it, others don't. Seems that gcc 4.6.0
> > says this is an error where 4.5.1 does not (I just tried both).
> >
> did you ? gcc 4.5.1 from Fedora 14 definitively shows the warning:

Heh, I didn't use Fedora's version. I wonder if they added a patch or
built it differently. I built my own 4.5.1 as well as my own 4.6.0.

-- Steve

> 
> # make ARCH=i386 kernel/trace/trace_printk.o V=1
> [...]
> gcc -Wp,-MD,kernel/trace/.trace_printk.o.d  -nostdinc -isystem
> /usr/lib/gcc/x86_64-redhat-linux/4.5.1/include [...] -c -o
> kernel/trace/trace_printk.o kernel/trace/trace_printk.c
> /src/linux/linux/kernel/trace/trace_printk.c: In function
> 'hold_module_trace_bprintk_format':
> /src/linux/linux/kernel/trace/trace_printk.c:52:8: warning: 'fmt' may
> be used uninitialized in this function
> 
> # gcc -v
> gcc -v
> Using built-in specs.
> COLLECT_GCC=gcc
> COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/4.5.1/lto-wrapper
> Target: x86_64-redhat-linux
> Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
> --infodir=/usr/share/info
> --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap
> --enable-shared --enable-threads=posix --enable-checking=release
> --with-system-zlib --enable-__cxa_atexit
> --disable-libunwind-exceptions --enable-gnu-unique-object
> --enable-linker-build-id
> --enable-languages=c,c++,objc,obj-c++,java,fortran,ada,lto
> --enable-plugin --enable-java-awt=gtk --disable-dssi
> --with-java-home=/usr/lib/jvm/java-1.5.0-gcj-1.5.0.0/jre
> --enable-libgcj-multifile --enable-java-maintainer-mode
> --with-ecj-jar=/usr/share/java/eclipse-ecj.jar
> --disable-libjava-multilib --with-ppl --with-cloog --with-tune=generic
> --with-arch_32=i686 --build=x86_64-redhat-linux
> Thread model: posix
> gcc version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC)
> 
>  - Arnaud



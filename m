Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565Ab1ADOeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 09:34:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:45489 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab1ADOeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 09:34:17 -0500
Date: Tue, 4 Jan 2011 12:34:00 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Han Pingtian <phan@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        mingo@elte.hu
Subject: Re: [GIT PULL||RFC 00/11] perf library and regression testing
 improvements
Message-ID: <20110104143359.GE19989@ghostprotocols.net>
References: <1294112905-25325-1-git-send-email-acme@infradead.org>
 <20110104071629.GB13299@elte.hu>
 <AANLkTinjkC=4yQbiLxF7=G1izFa2pOuR=WvRXbha3wsj@mail.gmail.com>
 <20110104140338.GA19989@ghostprotocols.net>
 <AANLkTi=osr9ZB9OzPxZ_99FU1A5JzCA3rMM64fxws34S@mail.gmail.com>
 <20110104141958.GC19989@ghostprotocols.net>
 <AANLkTi=uYpdirz_iJUNJoGcsG9_j0Uj+1H_O9bGQfUe+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=uYpdirz_iJUNJoGcsG9_j0Uj+1H_O9bGQfUe+@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 04, 2011 at 03:29:59PM +0100, Stephane Eranian escreveu:
> Indeed counts is bogus:
> 
> ./perf stat -i -e cycles date
> 
> evt:0x7d4250 counts=0x7d4450 <-- from perf_evsel__alloc_counts()
> 
> Tue Jan  4 15:28:36 CET 2011
> 
> counter=0x7d4250 counts=(nil) <-- from read_counter_aggr()
> 
> Segmentation fault

Strange I'm not reproducing it here (printf just on read_counter_aggr):

[acme@felicio linux]$ perf stat date
Tue Jan  4 12:32:15 BRST 2011
0x2586820: 0x2586948
0x2586790: 0x25869f8
0x2586700: 0x2586aa8
0x2586670: 0x2586b58
0x25865e0: 0x2586c08
0x2586550: 0x2586cb8
0x25864c0: 0x2586d68
0x2586430: 0x2586e18
0x25863a0: 0x2586ec8
0x2586310: 0x2586f78

 Performance counter stats for 'date':

             7,512 cache-misses             #     13.010 M/sec
           342,645 cache-references         #    593.445 M/sec
            14,884 branch-misses            #      8.241 %    
           180,611 branches                 #    312.810 M/sec
           925,986 instructions             #      0.000 IPC    (scaled from 49.88%)
     <not counted> cycles                  
               201 page-faults              #      0.348 M/sec
                 0 CPU-migrations           #      0.000 M/sec
                 0 context-switches         #      0.000 M/sec
          0.577383 task-clock-msecs         #      0.588 CPUs 

        0.000982448  seconds time elapsed

[acme@felicio linux]$

[acme@felicio linux]$ gcc -v
Using built-in specs.
COLLECT_GCC=/usr/bin/gcc
COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/4.5.1/lto-wrapper
Target: x86_64-redhat-linux
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap --enable-shared --enable-threads=posix --enable-checking=release --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --enable-languages=c,c++,objc,obj-c++,java,fortran,ada,lto --enable-plugin --enable-java-awt=gtk --disable-dssi --with-java-home=/usr/lib/jvm/java-1.5.0-gcj-1.5.0.0/jre --enable-libgcj-multifile --enable-java-maintainer-mode --with-ecj-jar=/usr/share/java/eclipse-ecj.jar --disable-libjava-multilib --with-ppl --with-cloog --with-tune=generic --with-arch_32=i686 --build=x86_64-redhat-linux
Thread model: posix
gcc version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC) 
[acme@felicio linux]$

[acme@felicio linux]$ uname -a
Linux felicio.ghostprotocols.net 2.6.35.10-72.fc14.x86_64 #1 SMP Mon Dec 20 21:14:22 UTC 2010 x86_64 x86_64 x86_64 GNU/Linux
[acme@felicio linux]$

[acme@felicio linux]$ cat /etc/fedora-release 
Fedora release 14 (Laughlin)
[acme@felicio linux]$

- Arnaldo

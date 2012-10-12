Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590Ab2JLNta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 09:49:30 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:35545 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab2JLNt3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 09:49:29 -0400
Date: Fri, 12 Oct 2012 09:37:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@redhat.com,
        acme@ghostprotocols.net, walken@google.com, akpm@linux-foundation.org
Subject: make DESTDIR=something -C linux/tools O=<somewhere>/tools
 perf_install fails during compile - ../../lib/rbtree.c:24:36: error:
 linux/rbtree_augmented.h ?
Message-ID: <20121012133719.GA7169@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Ingo, Andrew, Michel, etc.

Was wondering if you had seen similar errors? I am building perf out-of-tree
(so using the O= and -C combination). This did used to work in v3.6.

It looks like the libtree_augmented.h is missing somehow?

Extracting *libelf*.so* ..  (found) OK
Extracting *libdw*.so* ..  (found) OK
Extracting *libnewt*.so* ..  (found) OK
Extracting *libslang*.so* ..  (found) OK
Extracting *libnewt*.so* ..  (found) OK
Extracting ./usr/bin/less ..  (found) OK
Extracting ./usr/bin/expand ..  (found) OK
Extracting ./usr/bin/objdump ..  (found) OK
mkdir -p /home/konrad/ssd/xtt/root_image/..//linux-build/tools
make -j$((6 * 2))  V=1 NO_GTK2=1 DESTDIR=/home/konrad/ssd/xtt/root_image/userspace/ -C /home/konrad/ssd/xtt/linux/tools O=/home/konrad/ssd/xtt/root_image/..//linux-build/tools perf_install
make[1]: Entering directory `/home/konrad/ssd/linux/tools'
make -C perf/  install
make[2]: Entering directory `/home/konrad/ssd/linux/tools/perf'
Makefile:502: No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99
Makefile:567: No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev
make -C ../lib/traceevent/  O=/home/konrad/ssd/xtt/linux-build/tools/ libtraceevent.a
install 'perf-archive.sh' '/home/konrad/ssd/xtt/linux-build/tools/perf-archive'
CFLAGS='-Iutil/include -Iarch/x86/include -I/home/konrad/ssd/xtt/linux-build/tools/util -I../lib/traceevent/ -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -I/home/konrad/ssd/xtt/linux-build/tools/ -DLIBELF_NO_MMAP -DDWARF_SUPPORT -DNO_LIBUNWIND_SUPPORT -DNO_LIBAUDIT_SUPPORT -I/usr/include/slang -DNO_GTK2_SUPPORT -DNO_LIBPERL -DNO_STRLCPY' '/usr/bin/python' util/setup.py \
	  --quiet build_ext; \
	mkdir -p /home/konrad/ssd/xtt/linux-build/tools/python && \
	cp /home/konrad/ssd/xtt/linux-build/tools/python_ext_build/lib/perf.so /home/konrad/ssd/xtt/linux-build/tools/python/
make[3]: Entering directory `/home/konrad/ssd/linux/tools/lib/traceevent'
gcc -DPERF_VERSION='"3.6.10599.gfc7b06"' \
		'-DPERF_HTML_PATH="share/doc/perf-doc"' \
		-fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 -Wbad-function-cast -Wdeclaration-after-statement -Wformat-security -Wformat-y2k -Winit-self -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wno-system-headers -Wold-style-definition -Wpacked -Wredundant-decls -Wshadow -Wstrict-aliasing=3 -Wstrict-prototypes -Wswitch-default -Wswitch-enum -Wundef -Wwrite-strings -Wformat   -fstack-protector-all -Wstack-protector -Wvolatile-register-var -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -Iutil/include -Iarch/x86/include -I/home/konrad/ssd/xtt/linux-build/tools/util -I../lib/traceevent/ -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -I/home/konrad/ssd/xtt/linux-build/tools/ -DLIBELF_NO_MMAP -DDWARF_SUPPORT -DNO_LIBUNWIND_SUPPORT -DNO_LIBAUDIT_SUPPORT -I/usr/include/slang -DNO_GTK2_SUPPORT -DNO_LIBPERL -DNO_STRLCPY -DARCH_X86_64 -c perf.c make -C /home/konrad/ssd/xtt/linux-build/tools BUILD_SRC=/home/konrad/ssd/linux/tools/lib/traceevent -f /home/konrad/ssd/linux/tools/lib/traceevent/Makefile  libtraceevent.a
-o /home/konrad/ssd/xtt/linux-build/tools/perf.o
gcc -o /home/konrad/ssd/xtt/linux-build/tools/builtin-annotate.o -c -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 -Wbad-function-cast -Wdeclaration-after-statement -Wformat-security -Wformat-y2k -Winit-self -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wno-system-headers -Wold-style-definition -Wpacked -Wredundant-decls -Wshadow -Wstrict-aliasing=3 -Wstrict-prototypes -Wswitch-default -Wswitch-enum -Wundef -Wwrite-strings -Wformat   -fstack-protector-all -Wstack-protector -Wvolatile-register-var -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -Iutil/include -Iarch/x86/include -I/home/konrad/ssd/xtt/linux-build/tools/util -I../lib/traceevent/ -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -I/home/konrad/ssd/xtt/linux-build/tools/ -DLIBELF_NO_MMAP -DDWARF_SUPPORT -DNO_LIBUNWIND_SUPPORT -DNO_LIBAUDIT_SUPPORT -I/usr/include/slang -DNO_GTK2_SUPPORT -DNO_LIBPERL -DNO_STRLCPY -DARCH_X86_64 builtin-annotate.c
make[4]: warning: jobserver unavailable: using -j1.  Add `+' to parent make rule.
gcc -o /home/konrad/ssd/xtt/linux-build/tools/builtin-bench.o -c -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 -Wbad-function-cast -Wdeclaration-after-statement -Wformat-security -Wformat-y2k -Winit-self -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wno-system-headers -Wold-style-definition -Wpacked -Wredundant-decls -Wshadow -Wstrict-aliasing=3 -Wstrict-prototypes -Wswitch-default -Wswitch-enum -Wundef -Wwrite-strings -Wformat   -fstack-protector-all -Wstack-protector -Wvolatile-register-var -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -Iutil/include -Iarch/x86/include -I/home/konrad/ssd/xtt/linux-build/tools/util -I../lib/traceevent/ -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -I/home/konrad/ssd/xtt/linux-build/tools/ -DLIBELF_NO_MMAP -DDWARF_SUPPORT -DNO_LIBUNWIND_SUPPORT -DNO_LIBAUDIT_SUPPORT -I/usr/include/slang -DNO_GTK2_SUPPORT -DNO_LIBPERL -DNO_STRLCPY -DARCH_X86_64 builtin-bench.c
gcc -o /home/konrad/ssd/xtt/linux-build/tools/bench/sched-messaging.o -c -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 -Wbad-function-cast -Wdeclaration-after-statement -Wformat-security -Wformat-y2k -Winit-self -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wno-system-headers -Wold-style-definition -Wpacked -Wredundant-decls -Wshadow -Wstrict-aliasing=3 -Wstrict-prototypes -Wswitch-default -Wswitch-enum -Wundef -Wwrite-strings -Wformat   -fstack-protector-all -Wstack-protector -Wvolatile-register-var -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -Iutil/include -Iarch/x86/include -I/home/konrad/ssd/xtt/linux-build/tools/util -I../lib/traceevent/ -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -I/home/konrad/ssd/xtt/linux-build/tools/ -DLIBELF_NO_MMAP -DDWARF_SUPPORT -DNO_LIBUNWIND_SUPPORT -DNO_LIBAUDIT_SUPPORT -I/usr/include/slang -DNO_GTK2_SUPPORT -DNO_LIBPERL -DNO_STRLCPY -DARCH_X86_64 bench/sched-messaging.c
gcc -o /home/konrad/ssd/xtt/linux-build/tools/bench/sched-pipe.o -c -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 -Wbad-function-cast -Wdeclaration-after-statement -Wformat-security -Wformat-y2k -Winit-self -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wno-system-headers -Wold-style-definition -Wpacked -Wredundant-decls -Wshadow -Wstrict-aliasing=3 -Wstrict-prototypes -Wswitch-default -Wswitch-enum -Wundef -Wwrite-strings -Wformat   -fstack-protector-all -Wstack-protector -Wvolatile-register-var -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -Iutil/include -Iarch/x86/include -I/home/konrad/ssd/xtt/linux-build/tools/util -I../lib/traceevent/ -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -I/home/konrad/ssd/xtt/linux-build/tools/ -DLIBELF_NO_MMAP -DDWARF_SUPPORT -DNO_LIBUNWIND_SUPPORT -DNO_LIBAUDIT_SUPPORT -I/usr/include/slang -DNO_GTK2_SUPPORT -DNO_LIBPERL -DNO_STRLCPY -DARCH_X86_64 bench/sched-pipe.c
gcc -o /home/konrad/ssd/xtt/linux-build/tools/builtin-help.o -c -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 -Wbad-function-cast -Wdeclaration-after-statement -Wformat-security -Wformat-y2k -Winit-self -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wno-system-headers -Wold-style-definition -Wpacked -Wredundant-decls -Wshadow -Wstrict-aliasing=3 -Wstrict-prototypes -Wswitch-default -Wswitch-enum -Wundef -Wwrite-strings -Wformat   -fstack-protector-all -Wstack-protector -Wvolatile-register-var -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -Iutil/include -Iarch/x86/include -I/home/konrad/ssd/xtt/linux-build/tools/util -I../lib/traceevent/ -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -I/home/konrad/ssd/xtt/linux-build/tools/ -DLIBELF_NO_MMAP -DDWARF_SUPPORT -DNO_LIBUNWIND_SUPPORT -DNO_LIBAUDIT_SUPPORT -I/usr/include/slang -DNO_GTK2_SUPPORT -DNO_LIBPERL -DNO_STRLCPY -DARCH_X86_64 \
		'-DPERF_HTML_PATH="share/doc/perf-doc"' \
		'-DPERF_MAN_PATH="share/man"' \
		'-DPERF_INFO_PATH="share/info"' builtin-help.c
gcc -o /home/konrad/ssd/xtt/linux-build/tools/builtin-timechart.o -c -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 -Wbad-function-cast -Wdeclaration-after-statement -Wformat-security -Wformat-y2k -Winit-self -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wno-system-headers -Wold-style-definition -Wpacked -Wredundant-decls -Wshadow -Wstrict-aliasing=3 -Wstrict-prototypes -Wswitch-default -Wswitch-enum -Wundef -Wwrite-strings -Wformat   -fstack-protector-all -Wstack-protector -Wvolatile-register-var -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -Iutil/include -Iarch/x86/include -I/home/konrad/ssd/xtt/linux-build/tools/util -I../lib/traceevent/ -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -I/home/konrad/ssd/xtt/linux-build/tools/ -DLIBELF_NO_MMAP -DDWARF_SUPPORT -DNO_LIBUNWIND_SUPPORT -DNO_LIBAUDIT_SUPPORT -I/usr/include/slang -DNO_GTK2_SUPPORT -DNO_LIBPERL -DNO_STRLCPY -DARCH_X86_64 \
		'-DPERF_HTML_PATH="share/doc/perf-doc"' \
		'-DPERF_MAN_PATH="share/man"' \
		'-DPERF_INFO_PATH="share/info"' builtin-timechart.c
    * new build flags or cross compiler
gcc -o /home/konrad/ssd/xtt/linux-build/tools/util/pmu.o -c -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 -Wbad-function-cast -Wdeclaration-after-statement -Wformat-security -Wformat-y2k -Winit-self -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wno-system-headers -Wold-style-definition -Wpacked -Wredundant-decls -Wshadow -Wstrict-aliasing=3 -Wstrict-prototypes -Wswitch-default -Wswitch-enum -Wundef -Wwrite-strings -Wformat   -fstack-protector-all -Wstack-protector -Wvolatile-register-var -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -Iutil/include -Iarch/x86/include -I/home/konrad/ssd/xtt/linux-build/tools/util -I../lib/traceevent/ -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -I/home/konrad/ssd/xtt/linux-build/tools/ -DLIBELF_NO_MMAP -DDWARF_SUPPORT -DNO_LIBUNWIND_SUPPORT -DNO_LIBAUDIT_SUPPORT -I/usr/include/slang -DNO_GTK2_SUPPORT -DNO_LIBPERL -DNO_STRLCPY -DARCH_X86_64 util/pmu.c
gcc -o /home/konrad/ssd/xtt/linux-build/tools/util/parse-events.o -c -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 -Wbad-function-cast -Wdeclaration-after-statement -Wformat-security -Wformat-y2k -Winit-self -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wno-system-headers -Wold-style-definition -Wpacked -Wredundant-decls -Wshadow -Wstrict-aliasing=3 -Wstrict-prototypes -Wswitch-default -Wswitch-enum -Wundef -Wwrite-strings -Wformat   -fstack-protector-all -Wstack-protector -Wvolatile-register-var -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -Iutil/include -Iarch/x86/include -I/home/konrad/ssd/xtt/linux-build/tools/util -I../lib/traceevent/ -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -I/home/konrad/ssd/xtt/linux-build/tools/ -DLIBELF_NO_MMAP -DDWARF_SUPPORT -DNO_LIBUNWIND_SUPPORT -DNO_LIBAUDIT_SUPPORT -I/usr/include/slang -DNO_GTK2_SUPPORT -DNO_LIBPERL -DNO_STRLCPY -DARCH_X86_64 -Wno-redundant-decls util/parse-events.c
gcc -o /home/konrad/ssd/xtt/linux-build/tools/util/rbtree.o -c -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 -Wbad-function-cast -Wdeclaration-after-statement -Wformat-security -Wformat-y2k -Winit-self -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wno-system-headers -Wold-style-definition -Wpacked -Wredundant-decls -Wshadow -Wstrict-aliasing=3 -Wstrict-prototypes -Wswitch-default -Wswitch-enum -Wundef -Wwrite-strings -Wformat   -fstack-protector-all -Wstack-protector -Wvolatile-register-var -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -Iutil/include -Iarch/x86/include -I/home/konrad/ssd/xtt/linux-build/tools/util -I../lib/traceevent/ -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE -I/home/konrad/ssd/xtt/linux-build/tools/ -DLIBELF_NO_MMAP -DDWARF_SUPPORT -DNO_LIBUNWIND_SUPPORT -DNO_LIBAUDIT_SUPPORT -I/usr/include/slang -DNO_GTK2_SUPPORT -DNO_LIBPERL -DNO_STRLCPY -DARCH_X86_64 -DETC_PERFCONFIG='"etc/perfconfig"' ../../lib/rbtree.c
( gcc -c -g -Wall  -I. -I/usr/local/include    -D_GNU_SOURCE -std=gnu99 -fPIC /home/konrad/ssd/linux/tools/lib/traceevent/event-parse.c -o event-parse.o)
../../lib/rbtree.c:24:36: error: linux/rbtree_augmented.h: No such file or directory
cc1: warnings being treated as errors
../../lib/rbtree.c:47: error: ‘struct rb_node’ declared inside parameter list
../../lib/rbtree.c:47: error: its scope is only this definition or declaration, which is probably not what you want
../../lib/rbtree.c: In function ‘rb_set_black’:
../../lib/rbtree.c:49: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:49: error: ‘RB_BLACK’ undeclared (first use in this function)
../../lib/rbtree.c:49: error: (Each undeclared identifier is reported only once
../../lib/rbtree.c:49: error: for each function it appears in.)
../../lib/rbtree.c: In function ‘rb_red_parent’:
../../lib/rbtree.c:54: error: dereferencing pointer to incomplete type
../../lib/rbtree.c: At top level:
../../lib/rbtree.c:64: error: ‘struct rb_root’ declared inside parameter list
../../lib/rbtree.c: In function ‘__rb_rotate_set_parents’:
../../lib/rbtree.c:66: error: implicit declaration of function ‘rb_parent’
../../lib/rbtree.c:66: error: nested extern declaration of ‘rb_parent’
../../lib/rbtree.c:66: error: initialization makes pointer from integer without a cast
../../lib/rbtree.c:67: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:67: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:68: error: implicit declaration of function ‘rb_set_parent_color’
../../lib/rbtree.c:68: error: nested extern declaration of ‘rb_set_parent_color’
../../lib/rbtree.c:69: error: implicit declaration of function ‘__rb_change_child’
../../lib/rbtree.c:69: error: nested extern declaration of ‘__rb_change_child’
../../lib/rbtree.c: At top level:
../../lib/rbtree.c:72: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘void’
../../lib/rbtree.c:197: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘void’
../../lib/rbtree.c: In function ‘dummy_propagate’:
../../lib/rbtree.c:367: error: unused parameter ‘node’
../../lib/rbtree.c:367: error: unused parameter ‘stop’
../../lib/rbtree.c: In function ‘dummy_copy’:
../../lib/rbtree.c:368: error: unused parameter ‘old’
../../lib/rbtree.c:368: error: unused parameter ‘new’
../../lib/rbtree.c: In function ‘dummy_rotate’:
../../lib/rbtree.c:369: error: unused parameter ‘old’
../../lib/rbtree.c:369: error: unused parameter ‘new’
../../lib/rbtree.c: At top level:
../../lib/rbtree.c:371: error: variable ‘dummy_callbacks’ has initializer but incomplete type
../../lib/rbtree.c:372: error: excess elements in struct initializer
../../lib/rbtree.c:372: error: (near initialization for ‘dummy_callbacks’)
../../lib/rbtree.c:372: error: excess elements in struct initializer
../../lib/rbtree.c:372: error: (near initialization for ‘dummy_callbacks’)
../../lib/rbtree.c:373: error: excess elements in struct initializer
../../lib/rbtree.c:373: error: (near initialization for ‘dummy_callbacks’)
../../lib/rbtree.c:375: error: ‘struct rb_root’ declared inside parameter list
../../lib/rbtree.c:375: error: no previous prototype for ‘rb_insert_color’
../../lib/rbtree.c: In function ‘rb_insert_color’:
../../lib/rbtree.c:377: error: implicit declaration of function ‘__rb_insert’
../../lib/rbtree.c:377: error: nested extern declaration of ‘__rb_insert’
../../lib/rbtree.c: At top level:
../../lib/rbtree.c:381: error: ‘struct rb_root’ declared inside parameter list
../../lib/rbtree.c:381: error: no previous prototype for ‘rb_erase’
../../lib/rbtree.c: In function ‘rb_erase’:
../../lib/rbtree.c:383: error: implicit declaration of function ‘rb_erase_augmented’
../../lib/rbtree.c:383: error: nested extern declaration of ‘rb_erase_augmented’
../../lib/rbtree.c: At top level:
../../lib/rbtree.c:395: error: ‘struct rb_root’ declared inside parameter list
../../lib/rbtree.c:394: error: no previous prototype for ‘__rb_insert_augmented’
../../lib/rbtree.c:404: error: ‘struct rb_root’ declared inside parameter list
../../lib/rbtree.c:404: error: no previous prototype for ‘rb_first’
../../lib/rbtree.c: In function ‘rb_first’:
../../lib/rbtree.c:408: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:410: error: ‘NULL’ undeclared (first use in this function)
../../lib/rbtree.c:411: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:412: error: dereferencing pointer to incomplete type
../../lib/rbtree.c: At top level:
../../lib/rbtree.c:417: error: ‘struct rb_root’ declared inside parameter list
../../lib/rbtree.c:417: error: no previous prototype for ‘rb_last’
../../lib/rbtree.c: In function ‘rb_last’:
../../lib/rbtree.c:421: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:423: error: ‘NULL’ undeclared (first use in this function)
../../lib/rbtree.c:424: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:425: error: dereferencing pointer to incomplete type
../../lib/rbtree.c: At top level:
../../lib/rbtree.c:430: error: no previous prototype for ‘rb_next’
../../lib/rbtree.c: In function ‘rb_next’:
../../lib/rbtree.c:434: error: implicit declaration of function ‘RB_EMPTY_NODE’
../../lib/rbtree.c:434: error: nested extern declaration of ‘RB_EMPTY_NODE’
../../lib/rbtree.c:435: error: ‘NULL’ undeclared (first use in this function)
../../lib/rbtree.c:441: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:442: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:443: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:444: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:455: error: assignment makes pointer from integer without a cast
../../lib/rbtree.c:455: error: dereferencing pointer to incomplete type
../../lib/rbtree.c: At top level:
../../lib/rbtree.c:462: error: no previous prototype for ‘rb_prev’
../../lib/rbtree.c: In function ‘rb_prev’:
../../lib/rbtree.c:467: error: ‘NULL’ undeclared (first use in this function)
../../lib/rbtree.c:473: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:474: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:475: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:476: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:484: error: assignment makes pointer from integer without a cast
../../lib/rbtree.c:484: error: dereferencing pointer to incomplete type
../../lib/rbtree.c: At top level:
../../lib/rbtree.c:492: error: ‘struct rb_root’ declared inside parameter list
../../lib/rbtree.c:491: error: no previous prototype for ‘rb_replace_node’
../../lib/rbtree.c: In function ‘rb_replace_node’:
../../lib/rbtree.c:494: error: initialization makes pointer from integer without a cast
../../lib/rbtree.c:498: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:499: error: implicit declaration of function ‘rb_set_parent’
../../lib/rbtree.c:499: error: nested extern declaration of ‘rb_set_parent’
../../lib/rbtree.c:499: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:500: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:501: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:504: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:504: error: dereferencing pointer to incomplete type
make[2]: *** [/home/konrad/ssd/xtt/linux-build/tools/util/rbtree.o] Error 1
make[2]: *** Waiting for unfinished jobs....
( gcc -c -g -Wall  -I. -I/usr/local/include    -D_GNU_SOURCE -std=gnu99 -fPIC /home/konrad/ssd/linux/tools/lib/traceevent/trace-seq.c -o trace-seq.o)
( gcc -c -g -Wall  -I. -I/usr/local/include    -D_GNU_SOURCE -std=gnu99 -fPIC /home/konrad/ssd/linux/tools/lib/traceevent/parse-filter.c -o parse-filter.o)
( gcc -c -g -Wall  -I. -I/usr/local/include    -D_GNU_SOURCE -std=gnu99 -fPIC /home/konrad/ssd/linux/tools/lib/traceevent/parse-utils.c -o parse-utils.o)
( rm -f libtraceevent.a;  ar rcs libtraceevent.a event-parse.o trace-seq.o parse-filter.o parse-utils.o)
make[3]: Leaving directory `/home/konrad/ssd/linux/tools/lib/traceevent'
../../lib/rbtree.c:24:36: error: linux/rbtree_augmented.h: No such file or directory
../../lib/rbtree.c:47: warning: ‘struct rb_node’ declared inside parameter list
../../lib/rbtree.c:47: warning: its scope is only this definition or declaration, which is probably not what you want
../../lib/rbtree.c: In function ‘rb_set_black’:
../../lib/rbtree.c:49: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:49: error: ‘RB_BLACK’ undeclared (first use in this function)
../../lib/rbtree.c:49: error: (Each undeclared identifier is reported only once
../../lib/rbtree.c:49: error: for each function it appears in.)
../../lib/rbtree.c: In function ‘rb_red_parent’:
../../lib/rbtree.c:54: error: dereferencing pointer to incomplete type
../../lib/rbtree.c: At top level:
../../lib/rbtree.c:64: warning: ‘struct rb_root’ declared inside parameter list
../../lib/rbtree.c: In function ‘__rb_rotate_set_parents’:
../../lib/rbtree.c:66: warning: implicit declaration of function ‘rb_parent’
../../lib/rbtree.c:66: warning: initialization makes pointer from integer without a cast
../../lib/rbtree.c:67: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:67: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:68: warning: implicit declaration of function ‘rb_set_parent_color’
../../lib/rbtree.c:69: warning: implicit declaration of function ‘__rb_change_child’
../../lib/rbtree.c: At top level:
../../lib/rbtree.c:72: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘void’
../../lib/rbtree.c:197: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘void’
../../lib/rbtree.c:371: error: variable ‘dummy_callbacks’ has initializer but incomplete type
../../lib/rbtree.c:372: warning: excess elements in struct initializer
../../lib/rbtree.c:372: warning: (near initialization for ‘dummy_callbacks’)
../../lib/rbtree.c:372: warning: excess elements in struct initializer
../../lib/rbtree.c:372: warning: (near initialization for ‘dummy_callbacks’)
../../lib/rbtree.c:373: warning: excess elements in struct initializer
../../lib/rbtree.c:373: warning: (near initialization for ‘dummy_callbacks’)
../../lib/rbtree.c:375: warning: ‘struct rb_root’ declared inside parameter list
../../lib/rbtree.c: In function ‘rb_insert_color’:
../../lib/rbtree.c:377: warning: implicit declaration of function ‘__rb_insert’
../../lib/rbtree.c: At top level:
../../lib/rbtree.c:381: warning: ‘struct rb_root’ declared inside parameter list
../../lib/rbtree.c: In function ‘rb_erase’:
../../lib/rbtree.c:383: warning: implicit declaration of function ‘rb_erase_augmented’
../../lib/rbtree.c: At top level:
../../lib/rbtree.c:395: warning: ‘struct rb_root’ declared inside parameter list
../../lib/rbtree.c:404: warning: ‘struct rb_root’ declared inside parameter list
../../lib/rbtree.c: In function ‘rb_first’:
../../lib/rbtree.c:408: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:410: error: ‘NULL’ undeclared (first use in this function)
../../lib/rbtree.c:411: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:412: error: dereferencing pointer to incomplete type
../../lib/rbtree.c: At top level:
../../lib/rbtree.c:417: warning: ‘struct rb_root’ declared inside parameter list
../../lib/rbtree.c: In function ‘rb_last’:
../../lib/rbtree.c:421: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:423: error: ‘NULL’ undeclared (first use in this function)
../../lib/rbtree.c:424: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:425: error: dereferencing pointer to incomplete type
../../lib/rbtree.c: In function ‘rb_next’:
../../lib/rbtree.c:434: warning: implicit declaration of function ‘RB_EMPTY_NODE’
../../lib/rbtree.c:435: error: ‘NULL’ undeclared (first use in this function)
../../lib/rbtree.c:441: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:442: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:443: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:444: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:455: warning: assignment makes pointer from integer without a cast
../../lib/rbtree.c:455: error: dereferencing pointer to incomplete type
../../lib/rbtree.c: In function ‘rb_prev’:
../../lib/rbtree.c:467: error: ‘NULL’ undeclared (first use in this function)
../../lib/rbtree.c:473: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:474: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:475: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:476: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:484: warning: assignment makes pointer from integer without a cast
../../lib/rbtree.c:484: error: dereferencing pointer to incomplete type
../../lib/rbtree.c: At top level:
../../lib/rbtree.c:492: warning: ‘struct rb_root’ declared inside parameter list
../../lib/rbtree.c: In function ‘rb_replace_node’:
../../lib/rbtree.c:494: warning: initialization makes pointer from integer without a cast
../../lib/rbtree.c:498: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:499: warning: implicit declaration of function ‘rb_set_parent’
../../lib/rbtree.c:499: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:500: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:501: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:504: error: dereferencing pointer to incomplete type
../../lib/rbtree.c:504: error: dereferencing pointer to incomplete type
error: command 'gcc' failed with exit status 1
cp: cannot stat `/home/konrad/ssd/xtt/linux-build/tools/python_ext_build/lib/perf.so': No such file or directory
make[2]: *** [/home/konrad/ssd/xtt/linux-build/tools/python/perf.so] Error 1
make[2]: Leaving directory `/home/konrad/ssd/linux/tools/perf'
make[1]: *** [perf_install] Error 2
make[1]: Leaving directory `/home/konrad/ssd/linux/tools'
make: *** [perf-install] Error 2
FC-64 <konrad@phenom:~/ssd/xtt/root_image> 

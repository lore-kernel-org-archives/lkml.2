Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233Ab2EWOOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:14:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309Ab2EWOOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:14:06 -0400
Date: Wed, 23 May 2012 10:13:59 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
Subject: Perf build failure in v3.4-4842-g61011677
Message-ID: <20120523141359.GE1143@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building Linus' latest tree as of this morning results in perf being
very unhappy.  The build machine is running Fedora 17, so gcc 4.7.  The
gtk2 missing errors are fine as far as I'm concerned, but the rest of
the errors seem like things that might want fixing?

josh

+ make -j8 -C tools/perf -s V=1 WERROR=0 HAVE_CPLUS_DEMANGLE=1
prefix=/usr all
Package gtk+-2.0 was not found in the pkg-config search path.
Perhaps you should add the directory containing `gtk+-2.0.pc'
to the PKG_CONFIG_PATH environment variable
No package 'gtk+-2.0' found
Makefile:515: GTK2 not found, disables GTK2 support. Please install
gtk2-devel or libgtk2.0-dev
PERF_VERSION = 3.5.0-0.rc0.git4.1.fc18.x86_64
Package gtk+-2.0 was not found in the pkg-config search path.
Perhaps you should add the directory containing `gtk+-2.0.pc'
to the PKG_CONFIG_PATH environment variable
No package 'gtk+-2.0' found
Makefile:515: GTK2 not found, disables GTK2 support. Please install
gtk2-devel or libgtk2.0-dev
    * new build flags or prefix
make[1]: warning: jobserver unavailable: using -j1.  Add `+' to parent
make rule.
util/scripting-engines/trace-event-perl.c: In function
'define_event_symbols':
util/scripting-engines/trace-event-perl.c:188:2: warning: enumeration
value 'PRINT_BSTRING' not handled in switch [-Wswitch-enum]
util/scripting-engines/trace-event-perl.c:188:2: warning: enumeration
value 'PRINT_DYNAMIC_ARRAY' not handled in switch [-Wswitch-enum]
util/scripting-engines/trace-event-perl.c:188:2: warning: enumeration
value 'PRINT_FUNC' not handled in switch [-Wswitch-enum]
util/scripting-engines/trace-event-perl.c: In function
'find_cache_event':
util/scripting-engines/trace-event-perl.c:240:23: warning: assignment
from incompatible pointer type [enabled by default]
util/scripting-engines/trace-event-perl.c:244:34: error: dereferencing
pointer to incomplete type
util/scripting-engines/trace-event-perl.c:244:49: error: dereferencing
pointer to incomplete type
util/scripting-engines/trace-event-perl.c:246:44: error: dereferencing
pointer to incomplete type
util/scripting-engines/trace-event-perl.c: In function
'perl_process_tracepoint':
util/scripting-engines/trace-event-perl.c:282:34: error: dereferencing
pointer to incomplete type
util/scripting-engines/trace-event-perl.c:282:49: error: dereferencing
pointer to incomplete type
util/scripting-engines/trace-event-perl.c:303:20: error: dereferencing
pointer to incomplete type
util/scripting-engines/trace-event-perl.c: In function
'perl_generate_script':
util/scripting-engines/trace-event-perl.c:494:2: warning: passing
argument 1 of 'trace_find_next_event' from incompatible pointer type
[enabled by default]
In file included from util/scripting-engines/trace-event-perl.c:32:0:
util/scripting-engines/../trace-event.h:56:22: note: expected 'struct
event_format *' but argument is of type 'struct event *'
util/scripting-engines/trace-event-perl.c:494:16: warning: assignment
from incompatible pointer type [enabled by default]
util/scripting-engines/trace-event-perl.c:495:40: error: dereferencing
pointer to incomplete type
util/scripting-engines/trace-event-perl.c:495:55: error: dereferencing
pointer to incomplete type
util/scripting-engines/trace-event-perl.c:509:17: error: dereferencing
pointer to incomplete type
util/scripting-engines/trace-event-perl.c:528:17: error: dereferencing
pointer to incomplete type
util/scripting-engines/trace-event-perl.c:552:17: error: dereferencing
pointer to incomplete type
util/scripting-engines/trace-event-perl.c:565:37: error: dereferencing
pointer to incomplete type
util/scripting-engines/trace-event-perl.c:566:11: error: dereferencing
pointer to incomplete type
util/scripting-engines/trace-event-perl.c:575:37: error: dereferencing
pointer to incomplete type
util/scripting-engines/trace-event-perl.c:576:11: error: dereferencing
pointer to incomplete type
make: *** [util/scripting-engines/trace-event-perl.o] Error 1
make: *** Waiting for unfinished jobs....
/home/jwboyer/kernel/kernel-3.4.fc18/linux-3.5.0-0.rc0.git4.1.fc18.x86_64/tools/lib/traceevent/parse-filter.c:
In function 'create_arg_item':
/home/jwboyer/kernel/kernel-3.4.fc18/linux-3.5.0-0.rc0.git4.1.fc18.x86_64/tools/lib/traceevent/parse-filter.c:343:9:
warning: comparison between 'enum filter_arg_type' and 'enum event_type'
[-Wenum-compare]
/home/jwboyer/kernel/kernel-3.4.fc18/linux-3.5.0-0.rc0.git4.1.fc18.x86_64/tools/lib/traceevent/parse-filter.c:339:2:
warning: case value '8' not in enumerated type 'enum filter_arg_type'
[-Wswitch]
error: Bad exit status from /var/tmp/rpm-tmp.WBR9jG (%build)




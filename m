Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab1BBORZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 09:17:25 -0500
Received: from mx0.aculab.com ([213.249.233.131]:44605 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752018Ab1BBORY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 09:17:24 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 4/6] ftrace syscalls: Allow arch specific syscallsymbol matching
Date: Wed, 2 Feb 2011 14:15:00 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AC3A@saturn3.aculab.com>
In-Reply-To: <1296655484.10797.47.camel@gandalf.stny.rr.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 4/6] ftrace syscalls: Allow arch specific syscallsymbol matching
Thread-Index: AcvC4elUhC7XDI+LRy6jV6M2vAslRQAADQ/g
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Steven Rostedt" <rostedt@goodmis.org>, "Ian Munsie" <imunsie@au1.ibm.com>
Cc: "Andreas Dilger" <adilger@dilger.ca>,
        "Andreas Schwab" <schwab@linux-m68k.org>,
        "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "Namhyung Kim" <namhyung@gmail.com>, "Jiri Kosina" <jkosina@suse.cz>,
        "Jason Baron" <jbaron@redhat.com>, <linux-kernel@vger.kernel.org>,
        "Alexander Graf" <agraf@suse.de>, "Ingo Molnar" <mingo@redhat.com>,
        "Paul Mackerras" <paulus@samba.org>,
        "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Scott Wood" <scottwood@freescale.com>, "Nathan Lynch" <ntl@pobox.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "David Gibson" <dwg@au1.ibm.com>,
        "linuxppc-dev" <linuxppc-dev@lists.ozlabs.org>,
        "Avantika Mathur" <mathur@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> +#define arch_syscall_match_sym_name(sym, name) !strcmp(sym + 3, name
+ 3)

Whenever you use a #define macro arg, you should enclose it in ().
About the only time you don't need to is when it is being
passed as an argument to another function
(ie when it's use is also ',' separated).

So the above ought to be:
#define arch_syscall_match_sym_name(sym, name) (!strcmp((sym) + 3,
(name) + 3))

Whether an inline function is better or worse is much more subtle!
For instance I've used:
   asm volatile ( "# line " STR(__LINE__) :: )
to stop gcc merging the tails of conditionals.
Useful when the conditional is at the end of a loop (etc),
it might increase code size slightly, but removes a branch.

If I put one of those in an 'inline' function separate copies
of the function end up sharing code.
With a #define __LINE__ differs so they don't.

(I had some code to get below 190 clocks, these changes
were significant!)

	David



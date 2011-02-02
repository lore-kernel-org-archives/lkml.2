Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab1BBO2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 09:28:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47275 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab1BBO2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 09:28:18 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=8YA7GgcPyd0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=WppJQIY7CX8OfCplhfEA:9 a=efedLkpNb0gKaS2Lgy4A:7 a=hP8kHbWeAL6-SWxmW7LmEt_vVnMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: RE: [PATCH 4/6] ftrace syscalls: Allow arch specific syscallsymbol
 matching
From: Steven Rostedt <rostedt@goodmis.org>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Ian Munsie <imunsie@au1.ibm.com>, Andreas Dilger <adilger@dilger.ca>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Namhyung Kim <namhyung@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
        Alexander Graf <agraf@suse.de>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Scott Wood <scottwood@freescale.com>, Nathan Lynch <ntl@pobox.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Gibson <dwg@au1.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Avantika Mathur <mathur@linux.vnet.ibm.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8AC3A@saturn3.aculab.com>
References: <AE90C24D6B3A694183C094C60CF0A2F6D8AC3A@saturn3.aculab.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 02 Feb 2011 09:28:13 -0500
Message-ID: <1296656893.10797.53.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-02 at 14:15 +0000, David Laight wrote:
> > +#define arch_syscall_match_sym_name(sym, name) !strcmp(sym + 3, name
> + 3)
> 
> Whenever you use a #define macro arg, you should enclose it in ().
> About the only time you don't need to is when it is being
> passed as an argument to another function
> (ie when it's use is also ',' separated).
> 
> So the above ought to be:
> #define arch_syscall_match_sym_name(sym, name) (!strcmp((sym) + 3,
> (name) + 3))

I would have mentioned this if I wanted it to stay a macro ;)

> 
> Whether an inline function is better or worse is much more subtle!
> For instance I've used:
>    asm volatile ( "# line " STR(__LINE__) :: )
> to stop gcc merging the tails of conditionals.
> Useful when the conditional is at the end of a loop (etc),
> it might increase code size slightly, but removes a branch.
> 
> If I put one of those in an 'inline' function separate copies
> of the function end up sharing code.
> With a #define __LINE__ differs so they don't.
> 
> (I had some code to get below 190 clocks, these changes
> were significant!)

For what you were doing, this may have helped. But the code in question
is the "default" version of the function. I much more prefer it to be a
static inline. The issues you experience could change from gcc to gcc.
But static inlined functions are much cleaner and easier to read than
macros.

Using a macro for this purpose is just too messy.

Again, look at include/trace/ftrace.h. If I'm saying using a macro is
ugly, then don't use it! Listen to me, because I'm Mr. Ugly Macro Man.

-- Steve



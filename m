Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab0JSAsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 20:48:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:32833 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217Ab0JSAso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 20:48:44 -0400
X-Authority-Analysis: v=1.1 cv=vbQZhf6WRU4XF+4tPWNJEMYU0N1CowIjcRZ/qR/IBDs= c=1 sm=0 a=DQfcIUaFywYA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=kW4U0Hh1q0zK2dZO9F4A:9 a=5G96KsvviPL28zLCB4QA:7 a=sq_RhbO3TGtprtmuN1ES8eUmMKEA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v2][GIT PULL] ftrace: Remove recursion between
 recordmcount and scripts/mod/empty
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
In-Reply-To: <20101018163935.48260a13.akpm@linux-foundation.org>
References: <1287437213.16971.333.camel@gandalf.stny.rr.com>
	 <20101018163935.48260a13.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 18 Oct 2010 20:48:41 -0400
Message-ID: <1287449321.16971.336.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 16:39 -0700, Andrew Morton wrote:
> On Mon, 18 Oct 2010 17:26:53 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Please pull the latest tip/perf/recordmcount-2 tree
> 
> Today's linux-next has some problems.
> 
> make mrproper
> make allmodconfig
> make
> 
>   CHK     include/linux/version.h
>   UPD     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   UPD     include/generated/utsrelease.h
>   CC      kernel/bounds.s
>   GEN     include/generated/bounds.h
>   CC      arch/x86/kernel/asm-offsets.s
>   GEN     include/generated/asm-offsets.h
>   CALL    scripts/checksyscalls.sh
>   HOSTCC  scripts/genksyms/genksyms.o
>   SHIPPED scripts/genksyms/lex.c
>   SHIPPED scripts/genksyms/parse.h
>   SHIPPED scripts/genksyms/keywords.c
>   HOSTCC  scripts/genksyms/lex.o
>   SHIPPED scripts/genksyms/parse.c
>   HOSTCC  scripts/genksyms/parse.o
>   HOSTLD  scripts/genksyms/genksyms
>   CC      scripts/mod/empty.o
> /bin/sh: /usr/src/25/scripts/recordmcount: No such file or directory
> 
> If you run `make' a few times, scritps/recordmcount eventually turns
> up and the build runs OK.  Some ordering thing or a race or whatever?

The patch you just replied to fixes this :-)

-- Steve



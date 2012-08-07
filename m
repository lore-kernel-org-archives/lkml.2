Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab2HHAG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 20:06:56 -0400
Received: from bitwagon.com ([74.82.39.175]:53882 "HELO bitwagon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751502Ab2HHAGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 20:06:55 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Aug 2012 20:06:55 EDT
Message-ID: <5021AB86.30900@bitwagon.com>
Date: Tue, 07 Aug 2012 16:57:58 -0700
From: John Reiser <jreiser@bitwagon.com>
Organization: -
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH 1/4] ftrace: Make recordmcount.c handle __fentry__
References: <20120807193845.146666357@goodmis.org> <20120807194058.990674363@goodmis.org>
In-Reply-To: <20120807194058.990674363@goodmis.org>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 12:38 PM, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> With gcc 4.6.0 the -mfentry feature places the function profiling call at the start of the function. When this is used, the call is to __fentry__ and not mcount.
> 
> Change recordmcount.c to record both callers to __fentry__ and mcount.
   [snip]
> -	    (altmcount && strcmp(altmcount, symname) == 0))
> +	    (altmcount && strcmp(altmcount, symname) == 0) ||
> +	    (strcmp(fentry, symname) == 0))


The proposed change will work as long as all the *.o use the same name.
Only one of {"__fentry__", "mcount", "_mcount", altmcount} is allowed
for all the *.o as input for a particular run.  [Modulo the hack
of ignoring a leading '.' for 64-bit PowerPC, of course.]

If the user changes compilers (or changes CFLAGS by insert/remove "-mfentry")
without doing a "make clean", then recordmcount will omit some calls.

Those restrictions are easy to guess, and recovery is easy.  Therefore,
Ack'ed by: John Reiser <jreiser@bitwagon.com>

-- 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab2HVNeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 09:34:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2HVNeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 09:34:06 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=S27OPPXCPnoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=DFDjzt-BLwoA:10 a=meVymXHHAAAA:8 a=swxe52V3TsgdCJ0XmMgA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345642439.5069.27.camel@gandalf.local.home>
Subject: Re: [PATCH] perf tools: Fix 'No libunwind found' make warning
 message
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Feng Tang <feng.tang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ulrich Drepper <drepper@gmail.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Wed, 22 Aug 2012 09:33:59 -0400
In-Reply-To: <20120822084017.GA21581@gmail.com>
References: <1345479985-18669-1-git-send-email-acme@infradead.org>
	 <20120821093231.GA12385@gmail.com>
	 <20120821093628.GA981@krava.brq.redhat.com>
	 <20120822083812.GC1003@krava.brq.redhat.com>
	 <20120822084017.GA21581@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-22 at 10:40 +0200, Ingo Molnar wrote:
>  
> >  FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(ALL_CFLAGS) $(LIBUNWIND_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
> >  ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND)),y)
> > -	msg := $(warning No libunwind found. Please install libunwind >= 0.99);
> > +	msg := $(warning No libunwind found, disables post unwind support. Please install libunwind-dev[el] >= 0.99);
> 
> s/disables/disable

Is it a command for the user to do, or something it is about to do for
the user? If the latter, then "disabling" may be the better word.

-- Steve



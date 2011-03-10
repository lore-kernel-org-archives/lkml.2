Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab1CJAPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:15:01 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50407 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1CJAO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:14:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jvS+gZnCxfVEliYlr23UlNaeg0/FjQTGhv7juibPVb3eq9f2XxA8aycna4mEEOHZpL
         cqBpeP0Mf/hZsF5R5ux2M5GVGIZ2vqLHnhDnJgNsUNdiF1GKjlzB4kh01UZELu65Xsnk
         XUavbkFUcswPnJM6BzlSQCKfQ2KoLTdaHMMGE=
Date: Thu, 10 Mar 2011 01:14:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <daahern@cisco.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 07/10] perf script: Move printing of 'common' data from
 print_event and rename
Message-ID: <20110310001453.GD2533@nowhere>
References: <1299695491-15786-1-git-send-email-acme@infradead.org>
 <1299695491-15786-8-git-send-email-acme@infradead.org>
 <20110309235007.GB2533@nowhere>
 <4D78158F.6010403@cisco.com>
 <20110310001039.GC2533@nowhere>
 <4D78174B.2090209@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D78174B.2090209@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 05:11:55PM -0700, David Ahern wrote:
> 
> 
> On 03/09/11 17:10, Frederic Weisbecker wrote:
> > On Wed, Mar 09, 2011 at 05:04:31PM -0700, David Ahern wrote:
> >>
> >>
> >> On 03/09/11 16:50, Frederic Weisbecker wrote:
> >>
> >>>> +++ b/tools/perf/util/trace-event-parse.c
> >>>> @@ -2648,63 +2648,8 @@ static void print_lat_fmt(void *data, int size __unused)
> >>>>  		printf("%d", lock_depth);
> >>>>  }
> >>>>  
> >>>> -/* taken from Linux, written by Frederic Weisbecker */
> >>>> -static void print_graph_cpu(int cpu)
> >>>> -{
> >>>> -	int i;
> >>>> -	int log10_this = log10_cpu(cpu);
> >>>> -	int log10_all = log10_cpu(cpus);
> >>>> -
> >>>> -
> >>>> -	/*
> >>>> -	 * Start with a space character - to make it stand out
> >>>> -	 * to the right a bit when trace output is pasted into
> >>>> -	 * email:
> >>>> -	 */
> >>>> -	printf(" ");
> >>>> -
> >>>> -	/*
> >>>> -	 * Tricky - we space the CPU field according to the max
> >>>> -	 * number of online CPUs. On a 2-cpu system it would take
> >>>> -	 * a maximum of 1 digit - on a 128 cpu system it would
> >>>> -	 * take up to 3 digits:
> >>>> -	 */
> >>>> -	for (i = 0; i < log10_all - log10_this; i++)
> >>>> -		printf(" ");
> >>>> -
> >>>> -	printf("%d) ", cpu);
> >>>> -}
> >>>
> >>> So, we indeed don't use the function graph tracer with perf yet.
> >>> But there are fair chances we will in the future.
> >>>
> >>> So if we remove such code, I would prefer this to be made as
> >>> a seperate commit. Something we can easily retrieve and revert
> >>> in the future.
> >>
> >> Once the references to the functions are removed, compile fails --
> >> functions defined without a user.
> >>
> >> I left the cpu arg into print_trace_event to avoid having to delete even
> >> more code because of that.
> > 
> > And if you actually keep those functions in place?
> 
> Compile fails.

Ok, but why does it fail? :)

You can probably keep their callsites, like before they simply won't happen.

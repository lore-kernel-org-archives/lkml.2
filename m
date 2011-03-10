Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab1CJAWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:22:47 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49401 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab1CJAWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:22:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=waOsJxJQA7Gjx7HrcdF1tXlv7QEavxvqQ4mHmWIpz6grWKAIcb5/BV0mxpUKeLBJBQ
         7PjxVeJawuf1CeqbryqhrDjTKPK6i71fH6VXjwKLMESjJ3y/oi6ojK5jRUXndvA21bz1
         5Tyn3Hls6FfszJ+qb+eDYvhwmnw2L3m6Ioa+o=
Date: Thu, 10 Mar 2011 01:22:42 +0100
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
Message-ID: <20110310002240.GE2533@nowhere>
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

On Wed, Mar 09, 2011 at 05:15:00PM -0700, David Ahern wrote:
> 
> 
> On 03/09/11 17:10, Frederic Weisbecker wrote:
> > 
> > And if you actually keep those functions in place?
> 
>     CC /tmp/build-perf/util/trace-event-read.o
> cc1: warnings being treated as errors
> util/trace-event-parse.c:2652:13: error: 'print_graph_cpu' defined but
> not used
> util/trace-event-parse.c:2681:13: error: 'print_graph_proc' defined but
> not used
> make: *** [/tmp/build-perf/util/trace-event-parse.o] Error 1
> make: *** Waiting for unfinished jobs....

All right, that's because you removed their calls in pretty_print_func_ent().
So either you remove the whole in a specific patch, pretty_print_func_ent()
included and other related functions, or you keep them.

But I prefer we don't do something halfway, and in particular not in a
semi-hidden way inside a patch that is not particularly focused on that
purpose.

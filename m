Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab1CNVD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 17:03:28 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39160 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757193Ab1CNVDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 17:03:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=jHeETUIzi3Q8lh1rxVgbOJjfelGRU5FQ/FhswlsHu4mz3C3TPqxacd7tEKw8z3xRJr
         T+spmFZICpyYELU6tEsq/whsBTWj1HfziMLxyqcn2QzvIwdujpPDvQwrahZ9J6YGtH94
         bfcRACoqwRFr+ClGOntghglWS8RN7kfFjJi+0=
Date: Mon, 14 Mar 2011 18:03:15 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: Re: [RFC PATCH 0/4] perf: Custom contexts
Message-ID: <20110314210315.GC2388@ghostprotocols.net>
References: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
 <20110314204341.GC9388@ghostprotocols.net>
 <20110314205100.GG6139@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314205100.GG6139@nowhere>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 14, 2011 at 09:51:02PM +0100, Frederic Weisbecker escreveu:
> On Mon, Mar 14, 2011 at 05:43:41PM -0300, Arnaldo Carvalho de Melo wrote:
> > > - Count instructions inside softirqs, outside softirqs and everywhere:

> > > 	$ perf stat -e irq:softirq_entry -e irq:softirq_exit \
> > > 		-e instructions --starter 0 --stopper 1 --enable-on-starter \
> > > 		-e instructions --starter 1 --stopper 0 \
> > > 		-e instructions ./perf bench sched messaging

> > $ perf record -e instructions@irq:softirq_entry..irq:softirq_exit \
> > 	      -e instructions@irq:softirq_exit..irq:softirq_entry \
> > 	      -e instructions \
> > 	perf bench sched messaging

> Agreed that's nice but may be more as a shortcut than a full replacement?
> Otherwise it becomes hard or unreadable to define a filter on a starter. Or
> a starter on a starter.

Sure, multiple ways to express ranges probably is ok, with more complex
ones for more complex cases, like the way you did, that first defines an
evlist that is the set of starters/stoppers and then evsel->evidx to add
starters/stoppers to later events.

But starter on a starter? Couldn't grok, could you provide an example?

But I could think of this as a way to express filters:

$ perf record -e instructions@irq:irq:irq_handler_entry(irq=eth0)..irq:irq_handler_exit(\1) \
	      -e instructions \
	netperf

looks quite natural for someone used to git and sed, i.e. developers :)

- Arnaldo

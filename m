Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab2CFG0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 01:26:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37012 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999Ab2CFG0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 01:26:16 -0500
Date: Tue, 6 Mar 2012 07:25:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arun Sharma <asharma@fb.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, ravitillo@lbl.gov, khandual@linux.vnet.ibm.com,
        robert.richter@amd.com, ming.m.lin@intel.com, vweaver1@eecs.utk.edu,
        andi@firstfloor.org
Subject: Re: [PATCH] perf report: auto-detect branch stack sampling mode
Message-ID: <20120306062546.GA622@elte.hu>
References: <20120224094048.GA7952@quad>
 <20120305154753.GA14604@elte.hu>
 <20120305155011.GA32413@elte.hu>
 <20120305155642.GB32413@elte.hu>
 <1330965033.11248.240.camel@twins>
 <20120305203518.GA5656@infradead.org>
 <4F55337B.4080807@fb.com>
 <20120305222614.GB5656@infradead.org>
 <4F554DC7.8010504@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F554DC7.8010504@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arun Sharma <asharma@fb.com> wrote:

> Something like this seems to do it for me.
> 
>         offset = addr - sym->start;
> +       len = sym->end - sym->start;
> +       if (offset >= len)
> +               return 0;
> +

It would be nice to not have such inconsistent sym entries to 
begin with - i.e. to filter in the symbol code, not in the GUI 
front-end code.

> The other problem area seems to be callchains when using -p 
> regexp -x options. I'll try to summarize problems there in a 
> separate thread.

Btw., I have a text/regex filtering feature request there going 
beyond the issue of parent filtering, I often would love to be 
able to filter the sampled function itself:

  perf report sched

or:

  perf report time

or:

  perf report perf

to only see the list of (kernel) functions whose name name 
matches those patterns. (and skip all other functions)

Especially when I want to improve the tail portion of the 
profile this would be pretty useful. Today I can only do that 
with --stdio:

  perf report | grep sched

The -S option is too strict, it only allows individual symbols, 
no filters. Also, I hate typing '-S' ;-)

Thanks,

	Ingo

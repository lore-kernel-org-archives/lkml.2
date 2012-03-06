Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab2CFDHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 22:07:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426Ab2CFDHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 22:07:05 -0500
Date: Tue, 6 Mar 2012 00:06:35 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Arun Sharma <asharma@fb.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, ravitillo@lbl.gov, khandual@linux.vnet.ibm.com,
        robert.richter@amd.com, ming.m.lin@intel.com, vweaver1@eecs.utk.edu,
        andi@firstfloor.org
Subject: Re: [PATCH] perf report: auto-detect branch stack sampling mode
Message-ID: <20120306030635.GC5656@infradead.org>
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
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 05, 2012 at 03:35:35PM -0800, Arun Sharma escreveu:
> Like you probably figured from my other mail, we deal with deeply
> nested callchains with unwieldy function names a lot -- thanks to C++
> and template programming. --tui's collapsing/expanding functionality
> is quite useful to navigate that mess. I'm just taking this
> opportunity to get some attention focused on improving it :)

Excellent!

I can think about other Zoom operations, like zooming into just the
entries where some specific function in its callchains, say the one
under the cursor, appears, etc.
 
> On 3/5/12 2:26 PM, Arnaldo Carvalho de Melo wrote:
> 
> >>Here's an example:
> >>
> >># perf record -ag -- sleep 3
> >># perf report -G -s pid --tui # SIGSEGV
> >
> >Ok, now this is a good report, I managed to reproduce and will work on a
> >fix, thanks,
> 
> Something like this seems to do it for me.
> 
>         offset = addr - sym->start;
> +       len = sym->end - sym->start;
> +       if (offset >= len)
> +               return 0;
> +

That is my fault, I should have added a BUG_ON() spitting out a
callchain in this case, as that function shouldn't be called if the
address is not within its range :-\
 
> The other problem area seems to be callchains when using -p regexp
> -x options. I'll try to summarize problems there in a separate
> thread.

Please do,

Thanks a lot!

- Arnaldo

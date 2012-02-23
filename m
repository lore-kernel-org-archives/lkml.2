Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab2BWSMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 13:12:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501Ab2BWSMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 13:12:03 -0500
Date: Thu, 23 Feb 2012 16:11:32 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Roberto Agostino Vitillo <ravitillo@lbl.gov>,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, vweaver1@eecs.utk.edu, khandual@linux.vnet.ibm.com,
        dsahern@gmail.com
Subject: Re: [PATCH v6 13/18] perf: add support for taken branch sampling
	to perf report
Message-ID: <20120223181132.GB3571@infradead.org>
References: <1328826068-11713-1-git-send-email-eranian@google.com> <1328826068-11713-14-git-send-email-eranian@google.com> <20120222111501.GA23068@elte.hu> <CABPqkBQz0G6DQfAfzD2=1mCDvmVsaZhFjW0qEh4y+rNxtbLC4Q@mail.gmail.com> <20120223095922.GC24310@elte.hu> <CABPqkBT39C6zaKWGoHrRjqWE2P433NF-gYCYoa=JkJnGzMVjMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBT39C6zaKWGoHrRjqWE2P433NF-gYCYoa=JkJnGzMVjMQ@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 23, 2012 at 05:53:53PM +0100, Stephane Eranian escreveu:
> Ok, so I looked at that today. Adding the feature bit is trivial.
> But what's not easy is to get to the feature bit in perf report
> by the time we need it. Very quickly after parsing the options,
> we setup a bunch of things such as browser mode, sorting
> order based on the -b option. But to get to the feature bit, we
> would need to wait until after the session is created in
> __cmd_report() which is way later.
> 
> So we either hoist perf_session__new() very early, i.e., as soon
> as we have the filename or we write yet another parse_header()
> function just to get to the feature bits. I would rather choose the
> first option. But none is really pretty...
> 
> Arnaldo, any better idea?

Humm, lemme see...


By the time we need it is when we do setup_sorting, right? Perhaps we
can delay that till after we do perf_session__new and thus have read the
headers...

/me looks at the code.

- Arnaldo

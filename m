Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab2IMNqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:46:38 -0400
Received: from [205.233.59.134] ([205.233.59.134]:60768 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2IMNqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:46:36 -0400
Date: Thu, 13 Sep 2012 06:45:42 -0700
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Dong Hao <haodong@linux.vnet.ibm.com>, xiaoguangrong@linux.vnet.ibm.com,
        avi@redhat.com, mtosatti@redhat.com, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 3/3] KVM: perf: kvm events analysis tool
Message-ID: <20120913134541.GH10019@ghostprotocols.net>
References: <1346061106-5364-1-git-send-email-haodong@linux.vnet.ibm.com>
 <1346061106-5364-4-git-send-email-haodong@linux.vnet.ibm.com>
 <503FB105.9000205@gmail.com>
 <5051678C.1070209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5051678C.1070209@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 12, 2012 at 10:56:44PM -0600, David Ahern escreveu:
> >>  static const char * const kvm_usage[] = {
> >>+    "perf kvm [<options>] {top|record|report|diff|buildid-list|stat}",

> >The usage for the report/record sub commands of stat is never shown. e.g.,
> >$ perf kvm stat
> >--> shows help for perf-stat

> >$ perf kvm
> >--> shows the above and perf-kvm's usage
> 
> [I deleted this thread, so having to reply to one of my responses.
> hopefully noone is unduly harmed by this.]
> 
> I've been using this command a bit lately -- especially on nested
> virtualization -- and I think the syntax is quirky - meaning wrong.
> In my case I always follow up a record with a report and end up
> using a shell script wrapper that combines the 2 and running it
> repeatedly. e.g.,
> 
>     $PERF kvm stat record -o $FILE -p $pid -- sleep $time
>     [ $? -eq 0 ] && $PERF --no-pager kvm  -i $FILE stat report
> 
> As my daughter likes to say - awkward.
> 
> That suggests what is really needed is a 'live' mode - a continual
> updating of the output like perf top, not a record and analyze later
> mode. Which does come back to why I responded to this email -- the
> syntax is klunky and awkward.
> 
> So, I spent a fair amount of time today implementing a live mode.
> And after a lot of swearing at the tracepoint processing code I

What kind of swearing? I'm working on 'perf test' entries for
tracepoints to make sure we don't regress on the perf/libtraceevent
junction, doing that as prep work for further simplifying tracepoint
tools like sched, kvm, kmem, etc.

> finally have it working. And the format extends easily (meaning <
> day and the next step) to a perf-based kvm_stat replacement. Example
> syntax is:
> 
>    perf kvm stat [-p <pid>|-a|...]
> 
> which defaults to an update delay of 1 second, and vmexit analysis.
> 
> The guts of the processing logic come from the existing kvm-events
> code. The changes focus on combining the record and report paths
> into one. The display needs some help (Arnaldo?), but it seems to
> work well.
> 
> I'd like to get opinions on what next? IMO, the record/report path
> should not get a foot hold from a backward compatibility perspective
> and having to maintain those options. I am willing to take the
> existing patches into git to maintain authorship and from there
> apply patches to make the live mode work - which includes a bit of
> refactoring of perf code (like the stats changes).
> 
> Before I march down this path, any objections, opinions, etc?

Can I see the code?

- Arnaldo

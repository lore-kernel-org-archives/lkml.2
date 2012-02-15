Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104Ab2BONcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 08:32:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757982Ab2BONch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 08:32:37 -0500
Date: Wed, 15 Feb 2012 14:32:18 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCHv4 0/9] perf tool: parser generator for events parsing
Message-ID: <20120215133218.GD1664@m.brq.redhat.com>
References: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
 <1327674868-10486-1-git-send-email-jolsa@redhat.com>
 <1329236924.2293.13.camel@twins>
 <1329237838.2293.20.camel@twins>
 <1329250830.2293.24.camel@twins>
 <1329253030.2293.27.camel@twins>
 <1329253391.2293.31.camel@twins>
 <20120215092423.GB1664@m.brq.redhat.com>
 <1329304712.2293.46.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329304712.2293.46.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 12:18:32PM +0100, Peter Zijlstra wrote:
> On Wed, 2012-02-15 at 10:24 +0100, Jiri Olsa wrote:
> > On Tue, Feb 14, 2012 at 10:03:11PM +0100, Peter Zijlstra wrote:
> 
> > > These would be: period, config, config1, config2 and stephane's new
> > > branch_sample_type, although that might want to get a shorter name.
> > 
> > right, for pmu/.../ syntax there are allowed only fields from 'format'
> > directory are so far.. with exceptions like: cycles/period=100000/
> > 
> > so I'll hardcode following config fields:
> > 	config
> > 	config1
> > 	config2
> > 	period
> > 	branch_sample_type (branch, branch_type, branch_st  ???)
> 
> Uhmm,.. Stephane any particular preference on this?
> 
> > to be used in xxx/.../ syntax
> > 
> > also we need to choose some strategy of format field name shadowing
> > with hardcoded fields:
> > 
> > - BUILD_BUG in kernel PMU_FORMAT_ATTR
> > - not allowed.. report error in perf runtime
> > - allowed - hardcoded field have precedence
> > - allowed - format field values have precedence
> > 
> > I'd say either allow shadowing(with whatever precedence we this is better),
> > or have the BUILD_BUG line in kernel..
> 
> I agree, if we can get the BUILD_BUG thing working that might be the
> best option, otherwise we can do the precedence thing. We could even add
> a syntax to resolve the namespace conflict in the latter case (eg. use
> '$' PE_NAME to mean the hardcoded in case of conflict).
err.. I could not get the BUILD_BUG working... looks like string
comparison is something you are not supposed to do in cpp.. ;)

currently, I have the hardcoded fields to have a precedence,
and I'd workaround/fix it if there's need.. later I mean..

also, any idea when's the branch_sample_type going in?

thanks,
jirka

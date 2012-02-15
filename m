Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab2BOJYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 04:24:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab2BOJYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 04:24:37 -0500
Date: Wed, 15 Feb 2012 10:24:23 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCHv4 0/9] perf tool: parser generator for events parsing
Message-ID: <20120215092423.GB1664@m.brq.redhat.com>
References: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
 <1327674868-10486-1-git-send-email-jolsa@redhat.com>
 <1329236924.2293.13.camel@twins>
 <1329237838.2293.20.camel@twins>
 <1329250830.2293.24.camel@twins>
 <1329253030.2293.27.camel@twins>
 <1329253391.2293.31.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329253391.2293.31.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 10:03:11PM +0100, Peter Zijlstra wrote:
> On Tue, 2012-02-14 at 21:57 +0100, Peter Zijlstra wrote:
> > On Tue, 2012-02-14 at 21:20 +0100, Peter Zijlstra wrote:
> > > OK, this one works. the attributes thing wants NULL termination.
> > > Thanks
> > > for mentioning that Jiri. 
> > 
> > OK, it mostly works, except:
> > 
> > perf record -e "cpu/config=0x108000c0/upp" ./loop_1b_locks
> > 
> > doesn't seem to work...
> 
> This seems to come back to hardcoding config* vs including it in every
> single format description.
> 
> I prefer to have all perf_event_attr fields (of interest) hard-coded in
> the parser so that we can omit them for all actual format descriptions.
> 
> These would be: period, config, config1, config2 and stephane's new
> branch_sample_type, although that might want to get a shorter name.

right, for pmu/.../ syntax there are allowed only fields from 'format'
directory are so far.. with exceptions like: cycles/period=100000/

so I'll hardcode following config fields:
	config
	config1
	config2
	period
	branch_sample_type (branch, branch_type, branch_st  ???)

to be used in xxx/.../ syntax

also we need to choose some strategy of format field name shadowing
with hardcoded fields:

- BUILD_BUG in kernel PMU_FORMAT_ATTR
- not allowed.. report error in perf runtime
- allowed - hardcoded field have precedence
- allowed - format field values have precedence

I'd say either allow shadowing(with whatever precedence we this is better),
or have the BUILD_BUG line in kernel..

jirka

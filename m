Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab2AYIy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 03:54:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab2AYIy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 03:54:27 -0500
Date: Wed, 25 Jan 2012 09:54:14 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] perf: Add sysfs format attribute for pmu device
Message-ID: <20120125085414.GB2582@m.brq.redhat.com>
References: <20120109152855.GA1597@m.brq.redhat.com>
 <1326717103-10287-1-git-send-email-jolsa@redhat.com>
 <1326717103-10287-6-git-send-email-jolsa@redhat.com>
 <m1bopupi3v.fsf@fess.ebiederm.org>
 <20120123153350.GB1821@m.redhat.com>
 <1327418538.2446.61.camel@twins>
 <m139b4khxv.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m139b4khxv.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 11:40:28AM -0800, Eric W. Biederman wrote:
> Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
> 
> > On Mon, 2012-01-23 at 16:33 +0100, Jiri Olsa wrote:
> >>   
> >> > > +static ssize_t perf_default_event_format(struct pmu *pmu, char *page)
> >> > > +{
> >> > > +	ssize_t ret;
> >> > > +
> >> > > +	ret  = sprintf(page,       "config  config:0-63\n");
> >> > > +	ret += sprintf(page + ret, "config1 config1:0-63\n");
> >> > > +	ret += sprintf(page + ret, "config2 config2:0-63\n");
> >> > 
> >> > This looks like abuse of sysfs.  The rule is one value per file.
> >> > When you start adding newlines I can't see how this format attribute can
> >> > be considered one value.
> >> 
> >> ops, missed that rule.. I think we can carry the syntax files
> >> within perf, or have it builtin somehow.. or procfs? :) PeterZ?
> >
> > There's plenty of exceptions to this rule though and touching procfs is
> > even less appreciated.
> 
> There may be exceptions but certainly not plenty of exceptions.
> 
> There is also a practical scaling problem.  You have to be careful
> with how big you make that value before you have problems.
> 
> Perhaps what you want is a directory with a bunch of sysfs attributes?
> 
yep, Peter outlined this possibility in here
https://lkml.org/lkml/2012/1/24/206

> All I know is I see buffer overflows waiting to happen whenever I look
> at the code snippet above.

from this point of view, the above data should always be static/hardcoded
for given pmu.. so we will be fine with the page size buffer,
it could be valifated with some sort of BUILD_BUG_ON(data_size < pagesize)

jirka

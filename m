Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab2AXPW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 10:22:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33437 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab2AXPW2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 10:22:28 -0500
Message-ID: <1327418538.2446.61.camel@twins>
Subject: Re: [PATCH 5/9] perf: Add sysfs format attribute for pmu device
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, acme@redhat.com,
        mingo@elte.hu, paulus@samba.org, cjashfor@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Date: Tue, 24 Jan 2012 16:22:18 +0100
In-Reply-To: <20120123153350.GB1821@m.redhat.com>
References: <20120109152855.GA1597@m.brq.redhat.com>
	 <1326717103-10287-1-git-send-email-jolsa@redhat.com>
	 <1326717103-10287-6-git-send-email-jolsa@redhat.com>
	 <m1bopupi3v.fsf@fess.ebiederm.org> <20120123153350.GB1821@m.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-23 at 16:33 +0100, Jiri Olsa wrote:
>   
> > > +static ssize_t perf_default_event_format(struct pmu *pmu, char *page)
> > > +{
> > > +	ssize_t ret;
> > > +
> > > +	ret  = sprintf(page,       "config  config:0-63\n");
> > > +	ret += sprintf(page + ret, "config1 config1:0-63\n");
> > > +	ret += sprintf(page + ret, "config2 config2:0-63\n");
> > 
> > This looks like abuse of sysfs.  The rule is one value per file.
> > When you start adding newlines I can't see how this format attribute can
> > be considered one value.
> 
> ops, missed that rule.. I think we can carry the syntax files
> within perf, or have it builtin somehow.. or procfs? :) PeterZ?

There's plenty of exceptions to this rule though and touching procfs is
even less appreciated.

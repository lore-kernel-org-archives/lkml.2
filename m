Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab2HAOum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 10:50:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992Ab2HAOuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 10:50:40 -0400
Date: Wed, 1 Aug 2012 16:50:06 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCH 13/13] perf, tool: Support for dwarf mode callchain on
 perf record
Message-ID: <20120801145006.GG2528@krava.brq.redhat.com>
References: <1343815865-5511-1-git-send-email-jolsa@redhat.com>
 <1343815865-5511-14-git-send-email-jolsa@redhat.com>
 <50193C83.6050503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50193C83.6050503@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 08:26:11AM -0600, David Ahern wrote:
> On 8/1/12 4:11 AM, Jiri Olsa wrote:
> >+static int
> >+parse_callchain_opt(const struct option *opt __used, const char *arg,
> >+		    int unset)
> >+{
> >+	struct perf_record *rec = (struct perf_record *)opt->value;
> >+	char *tok, *name, *saveptr = NULL;
> >+	char buf[20];
> >+	int ret = -1;
> >+
> >+	/* --no-call-graph */
> >+	if (unset)
> >+		return 0;
> >+
> >+	/* We specified default option if none is provided. */
> >+	BUG_ON(!arg);
> >+
> >+	/* We need buffer that we know we can write to. */
> >+	snprintf(buf, 20, "%s", arg);
> 
> Isn't arg the user supplied string? What if the user messes up and
> passes in 20+ characters to -g argument?

  [jolsa@dhcp-26-214 perf]$ ./perf record -g dwarf123213214321432143214321432143214321432143214321 ls
  callchain: Unknown -g option value: dwarf12321321432143
  ...

hm, but if user specified it like this:

  [jolsa@dhcp-26-214 perf]$ ./perf record -vg 'dwarf,                    50000' ls
  callchain: Incorrect stack dump size (max 65528):              

then we're in trouble.. I'll send a fix

thanks,
jirka

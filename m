Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab2GXOk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:40:27 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:41352 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab2GXOk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:40:26 -0400
Date: Tue, 24 Jul 2012 16:40:22 +0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 11/11] perf kvm top: limit guest kernel info message to
 once
Message-ID: <20120724144022.GH6717@infradead.org>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
 <1342826756-64663-12-git-send-email-dsahern@gmail.com>
 <20120723181708.GE6717@infradead.org>
 <500EAB0C.8090504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500EAB0C.8090504@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jul 24, 2012 at 08:02:52AM -0600, David Ahern escreveu:
> On 7/23/12 12:17 PM, Arnaldo Carvalho de Melo wrote:
> >Em Fri, Jul 20, 2012 at 05:25:56PM -0600, David Ahern escreveu:
> >>+		static struct strlist *seen;
> >>+		char pidstr[8];

> >>+		if (!seen)
> >>+			seen = strlist__new(true, NULL);

> >>+		scnprintf(pidstr, sizeof(pidstr), "%d", event->ip.pid);
> >>+		if (!strlist__has_entry(seen, pidstr)) {
> >>+			pr_err("Can't find guest [%d]'s kernel information\n",
> >>+				event->ip.pid);
> >>+			strlist__add(seen, pidstr);

> >Abuse of strlist? Can't we have an intlist?
> 
> Use of existing facility. :-) I'll look at adding an intlist facility.

Thanks!

- Arnaldo

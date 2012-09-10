Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab2IJQ4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:56:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35630 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab2IJQ4n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:56:43 -0400
Message-ID: <1347296189.2124.31.camel@twins>
Subject: Re: [PATCH 4/4] perf tools: Back [vdso] DSO with real data
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 10 Sep 2012 18:56:29 +0200
In-Reply-To: <1347295819-23177-5-git-send-email-jolsa@redhat.com>
References: <1347295819-23177-1-git-send-email-jolsa@redhat.com>
	 <1347295819-23177-5-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-10 at 18:50 +0200, Jiri Olsa wrote:
> +       maps = fopen("/proc/self/maps", "r");
> +       if (!maps) {
> +               pr_err("vdso: cannot open maps\n");
> +               return -1;
> +       }
> +
> +       while (!found && fgets(line, sizeof(line), maps)) {
> +               int m = -1;
> +
> +               /* We care only about private r-x mappings. */
> +               if (2 != sscanf(line, "%p-%p r-xp %*x %*x:%*x %*u %n",
> +                               start, end, &m))
> +                       continue;
> +               if (m < 0)
> +                       continue;
> +
> +               if (!strncmp(&line[m], VDSO__MAP_NAME,
> +                            sizeof(VDSO__MAP_NAME) - 1))
> +                       found = 1;
> +       } 

Argh.. :-) We so should have the vdso as a proper elf DSO somewhere
in /proc or /sys, but yeah, lacking that what you've done is about all
we can do.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab0EaULa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 16:11:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:57988 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab0EaUL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 16:11:29 -0400
Message-ID: <4C0417EC.8050906@suse.cz>
Date: Mon, 31 May 2010 22:11:24 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, "David S. Miller" <davem@davemloft.net>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] perf tools: Make target to generate self contained
 source tarball
References: <20100528185357.GA28009@ghostprotocols.net> <20100529072948.GE16257@merkur.ravnborg.org> <20100531174207.GB3481@ghostprotocols.net>
In-Reply-To: <20100531174207.GB3481@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.5.2010 19:42, Arnaldo Carvalho de Melo wrote:
> +git archive --prefix=$(perf-tar)/ HEAD^{tree}                       \

If you use plain "HEAD" (a commit-ish) instead if HEAD^{tree}, then
git archive will store the commit id in the archive metadata and the
user can then use git get-tar-commit-id to extract it.


> +	$$(cat $(srctree)/tools/perf/MANIFEST) -o $(perf-tar).tar;  \
> +mkdir -p $(perf-tar);                                               \
> +git rev-parse HEAD > $(perf-tar)/HEAD;                              \
> +tar rf $(perf-tar).tar $(perf-tar)/HEAD;                            \

... then this HEAD file might not even be necessary (even if you keep
it, it would be nice not to break git get-tar-commit-id).

Michal

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab2GXSD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 14:03:29 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:40830 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704Ab2GXSDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 14:03:18 -0400
Date: Tue, 24 Jul 2012 20:03:12 +0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 08/11] perf tool: precise mode requires exclude_guest
Message-ID: <20120724180312.GJ6717@infradead.org>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
 <1342826756-64663-9-git-send-email-dsahern@gmail.com>
 <20120723181358.GC6717@infradead.org>
 <500EAF23.8060909@gmail.com>
 <20120724161507.GG3732@erda.amd.com>
 <500EDB50.3070704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500EDB50.3070704@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jul 24, 2012 at 11:28:48AM -0600, David Ahern escreveu:
> On 7/24/12 10:15 AM, Robert Richter wrote:
> >On AMD cpus precise_ip maps to IBS, which does not support hardware
> >options as perfctrs do. Thus, following attr flags are not supported:

> >  exclude_user, exclude_kernel, exclude_host, exclude_guest

> >Counting in guest mode is possible with IBS, but not the exclusion of
> >a certain mode. If precise_ip counting is enabled on AMD we may not
> >set the exclude_guest flag.

> Ok, so with AMD precise_ip requires exclude_guest to be unset; for
> Intel we need it set.

> So then we look at vendor_id in /proc/cpuinfo?

Does it return EOPNOTSUPP or something similar if something not
supported is asked for?

Fallbacking, or capability querying if you will, may be the way to do it
without having to maintain an userland table for what is possible,
leaving it to the kernel drivers for each arch.

We do it now for sample_id_all and some other newer stuff, maybe we can
do it for this as well.

- Arnaldo

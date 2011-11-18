Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab1KROXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 09:23:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab1KROXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 09:23:06 -0500
Date: Fri, 18 Nov 2011 12:22:55 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] perf tool: Initialize events IDs in a single
	function
Message-ID: <20111118142255.GB13052@ghostprotocols.net>
References: <1321624005-6889-1-git-send-email-jolsa@redhat.com> <1321624005-6889-3-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321624005-6889-3-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 18, 2011 at 02:46:42PM +0100, Jiri Olsa escreveu:
> Currently events' IDs initialization is scattered among the
> code. Adding function 'perf_evlist__init_ids' to allocate
> and retrive events' IDs in one place.

I'm ok with this one, will merge it in my perf/core branch together with
a fix for a bug I noticed in the original code and that remains with
your changes: consider what happens if we do a second perf_evlist__mmap,
we will call perf_evlist__id_add_fd again and thus bump evsel->ids++
over nr_threads * nr_cpus, overflowing it.

- Arnaldo

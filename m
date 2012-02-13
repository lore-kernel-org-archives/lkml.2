Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639Ab2BMTFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 14:05:52 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45548 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757597Ab2BMTFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 14:05:50 -0500
Date: Mon, 13 Feb 2012 17:05:42 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Namhyung Kim <namhyung@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] perf tools: Introduce struct perf_maps_opts
Message-ID: <20120213190542.GL15955@infradead.org>
References: <1329118064-9412-1-git-send-email-namhyung.kim@lge.com>
 <1329118064-9412-2-git-send-email-namhyung.kim@lge.com>
 <20120213183232.GD15955@infradead.org>
 <4F395B75.4060800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F395B75.4060800@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Feb 13, 2012 at 11:50:29AM -0700, David Ahern escreveu:
> The cleanup might make my multiple tid/pid patch easier: e.g.,
> 
> struct perf_target{
> 	...
> 	char errmsg[128];
> };
> 
> Then if the tid/pid string parsing fails in perf_evlist__create_maps and
> friends the errmsg can be put into the buffer for the callers to get a
> more useful message to the user as to what happened.
> 
> Today's perf if you give it an invalid pid, scandir fails and the
> command spits out the usage statement. Which is completely confusing --
> ie., not clear that the command failed b/c the pid does not exist.

Humm, ok, but then I think we should have an enum + a strerror(3)
equivalent, i.e.:

	enum perf_target_error perf_evlist__create_maps(...);

	int perf_target__strerror(struct perf_target *target, int errnum,
				  char *buf, size_t buflen);

Please see 'man strerror_r", and make it work like the POSIX compliant
variant.

Ok, so it may be better to first process Kim's patches and then you
rework yours?

- Arnaldo

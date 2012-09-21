Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab2IUCgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 22:36:14 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:46495 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab2IUCgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 22:36:13 -0400
X-AuditID: 9c930197-b7b6dae000000e70-f5-505bd29b8d30
From: Namhyung Kim <namhyung@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH V3] perf: Fix parallel build
References: <505BAC5D.9020909@redhat.com> <505BBF12.4060800@redhat.com>
	<87392cyvpl.fsf@sejong.aot.lge.com> <505BD190.40707@redhat.com>
Date: Fri, 21 Sep 2012 11:27:31 +0900
In-Reply-To: <505BD190.40707@redhat.com> (Eric Sandeen's message of "Thu, 20
	Sep 2012 21:31:44 -0500")
Message-ID: <87y5k4xg8c.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2012 21:31:44 -0500, Eric Sandeen wrote:
> Parallel builds of perf were failing for me on a 32p box, with:
>
>     * new build flags or prefix
> util/pmu.l:7:23: error: pmu-bison.h: No such file or directory
>
> ...
>
> make: *** [util/pmu-flex.o] Error 1
> make: *** Waiting for unfinished jobs....
>
> This can pretty quickly be seen by adding a sleep in front of
> the bison calls in tools/perf/Makefile and running make -j4 on a
> smaller box i.e.:
>
> 	sleep 10; $(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c
>
> Adding the following dependencies fixes it for me.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Namhyung Kim <namhyung@kernel.org>

Thanks for fixing this!
Namhyung

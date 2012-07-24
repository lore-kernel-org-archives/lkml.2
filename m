Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab2GXAnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 20:43:49 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49520 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab2GXAns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 20:43:48 -0400
X-AuditID: 9c930179-b7bdcae000003d91-e6-500defc208c1
From: Namhyung Kim <namhyung@kernel.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: fix build error
References: <1343055645-24083-1-git-send-email-kirill@shutemov.name>
	<20120723180244.GB5418@infradead.org>
	<20120723181608.GA24558@shutemov.name>
	<20120723181849.GF6717@infradead.org>
	<20120723195146.GA24938@shutemov.name>
	<20120723210407.GA25186@shutemov.name>
Date: Tue, 24 Jul 2012 09:38:24 +0900
In-Reply-To: <20120723210407.GA25186@shutemov.name> (Kirill A. Shutemov's
	message of "Tue, 24 Jul 2012 00:04:07 +0300")
Message-ID: <874noy6lj3.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kirill

On Tue, 24 Jul 2012 00:04:07 +0300, Kirill A. Shutemov wrote:
> From 14f476dddcb36bca93a50ef1a3341e2c60836e0a Mon Sep 17 00:00:00 2001
> From: "Kirill A. Shutemov" <kirill@shutemov.name>
> Date: Mon, 23 Jul 2012 17:39:11 +0300
> Subject: [PATCH 1/2] perf: fix build error
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
>
> Bison 2.6 started to generate parse_events_parse() declaration in
> header. In this case we have redundant redeclaration:
>
> util/parse-events.c:29:5: error: redundant redeclaration of ‘parse_events_parse’ [-Werror=redundant-decls]
> In file included from util/parse-events.c:14:0:
> util/parse-events-bison.h:99:5: note: previous declaration of ‘parse_events_parse’ was here
> cc1: all warnings being treated as errors
>
> Let's disable -Wredundant-decls for util/parse-events.c since it
> includes header we can't control.
>

It'd be better if the subject line is more descriptive. Like:

  "perf tools: fix a build error with bison 2.6"

Other than that, looks good to me.

Thanks,
Namhyung


> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> ---
>  tools/perf/Makefile | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 75d74e5..1091192 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -803,6 +803,9 @@ $(OUTPUT)ui/browsers/map.o: ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
>  $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
>  
> +$(OUTPUT)util/parse-events.o: util/parse-events.c $(OUTPUT)PERF-CFLAGS
> +	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Wno-redundant-decls $<
> +
>  $(OUTPUT)util/scripting-engines/trace-event-perl.o: util/scripting-engines/trace-event-perl.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<

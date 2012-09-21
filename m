Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab2IUCQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 22:16:34 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48896 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab2IUCQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 22:16:33 -0400
X-AuditID: 9c930197-b7b6dae000000e70-aa-505bcdfe5487
From: Namhyung Kim <namhyung@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH V2] perf: Fix parallel build
References: <505BAC5D.9020909@redhat.com> <505BBF12.4060800@redhat.com>
Date: Fri, 21 Sep 2012 11:07:50 +0900
In-Reply-To: <505BBF12.4060800@redhat.com> (Eric Sandeen's message of "Thu, 20
	Sep 2012 20:12:50 -0500")
Message-ID: <87392cyvpl.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

On Thu, 20 Sep 2012 20:12:50 -0500, Eric Sandeen wrote:
> -$(OUTPUT)util/parse-events-flex.c: util/parse-events.l
> +$(OUTPUT)util/parse-events-flex.c: util/parse-events.l util/parse-events-bison.c

I realized that the generated *-bison.c files should have $(OUTPUT)
prefix since they can be under another directory than *.[ly] files.


>  	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h $(PARSER_DEBUG_FLEX) -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
>  
>  $(OUTPUT)util/parse-events-bison.c: util/parse-events.y
>  	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)util/parse-events-bison.c
>  
> -$(OUTPUT)util/pmu-flex.c: util/pmu.l
> +$(OUTPUT)util/pmu-flex.c: util/pmu.l util/pmu-bison.c

Ditto.

Thanks,
Namhyung


>  	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/pmu-flex.h -t util/pmu.l > $(OUTPUT)util/pmu-flex.c
>  
>  $(OUTPUT)util/pmu-bison.c: util/pmu.y

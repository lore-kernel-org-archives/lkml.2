Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab2IDA5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 20:57:49 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64912 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab2IDA5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 20:57:48 -0400
X-AuditID: 9c930197-b7b93ae0000028a7-f5-5045520a9346
From: Namhyung Kim <namhyung@kernel.org>
To: Feng Tang <feng.tang@intel.com>
Cc: acme@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        andi@firstfloor.org, dsahern@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] perf ui/browser: Add browser for perf script
References: <1346660073-20279-1-git-send-email-feng.tang@intel.com>
Date: Tue, 04 Sep 2012 09:50:16 +0900
In-Reply-To: <1346660073-20279-1-git-send-email-feng.tang@intel.com> (Feng
	Tang's message of "Mon, 3 Sep 2012 16:14:26 +0800")
Message-ID: <87mx16ehmf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Feng

On Mon,  3 Sep 2012 16:14:26 +0800, Feng Tang wrote:
> Hi Arnaldo and all,
>
> This is a patch set mainly to add a browser for perf script, which
> will be integrated into the main hists and annotation browser.
>
> Patch 1-4 are some preparation for adding the script
> patch 5 introduce the script browser
> patch 6-7 integrate the browser to hists browser and annotation browser
>
> The patches are on top of current perf/core branch of your git tree. 
> Please help to review, thanks
>

There was a build failure on my F17 box:

      CC builtin-script.o
  builtin-script.c: In function ‘find_scripts’:
  builtin-script.c:1047:7: error: variable ‘first_half’ set but not used [-Werror=unused-but-set-variable]
  builtin-script.c:1046:22: error: variable ‘desc’ set but not used [-Werror=unused-but-set-variable]
  cc1: all warnings being treated as errors
  make: *** [builtin-script.o] Error 1

Thanks,
Namhyung


> Feng
> -----------------------
> Feng Tang (7):
>   perf symbols: Filter samples with unresolved symbol when "--symbols"
>     option is used
>   perf scripts: Add --symbols option to handle specific symbols
>   perf scripts: Add event_analyzing_sample-record/report
>   perf scripts: Export a find_scripts() function
>   perf ui/browser: Add a browser for perf script
>   perf ui/browser: Integrate script browser into annotation browser
>   perf ui/browser: Integrate script browser into main hists browser
>
>  tools/perf/Makefile                                |    5 +
>  tools/perf/builtin-script.c                        |   49 ++++++
>  tools/perf/builtin.h                               |    1 +
>  .../python/bin/event_analyzing_sample-record       |    8 +
>  .../python/bin/event_analyzing_sample-report       |    3 +
>  tools/perf/ui/browsers/annotate.c                  |    8 +
>  tools/perf/ui/browsers/hists.c                     |   39 +++++
>  tools/perf/ui/browsers/scripts.c                   |  159 ++++++++++++++++++++
>  tools/perf/ui/browsers/scripts.h                   |    5 +
>  tools/perf/util/event.c                            |    5 +-
>  10 files changed, 280 insertions(+), 2 deletions(-)
>  create mode 100644 tools/perf/scripts/python/bin/event_analyzing_sample-record
>  create mode 100644 tools/perf/scripts/python/bin/event_analyzing_sample-report
>  create mode 100644 tools/perf/ui/browsers/scripts.c
>  create mode 100644 tools/perf/ui/browsers/scripts.h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab2K2LwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 06:52:21 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62722 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab2K2LwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 06:52:20 -0500
X-AuditID: 9c930179-b7c9dae000000e53-dc-50b74c7255b9
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 09/14] perf diff: Update perf diff documentation for multiple data comparison
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
	<1354110769-2998-10-git-send-email-jolsa@redhat.com>
Date: Thu, 29 Nov 2012 20:52:18 +0900
In-Reply-To: <1354110769-2998-10-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Wed, 28 Nov 2012 14:52:44 +0100")
Message-ID: <87ip8oocct.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2012 14:52:44 +0100, Jiri Olsa wrote:
> +COMPARISON
> +----------
> +The comparison is governed by the baseline file. The baseline perf.data
> +file is iterated for samples. All other perf.data files specified on
> +the command line are searched for the baseline sample pair. If the pair
> +is found, specified computation is made and result is displayed.
> +
> +All samples from non-baseline perf.data files, that do not match any
> +baseline entry, are displayed with empty space within baseline column
> +and possible computation results (delta) in their related column.
> +
> +Example files samples:
> +- file A with samples f1, f2, f3, f4,    f6
> +- file B with samples     f2,     f4, f5
> +- file C with samples f1, f2,         f5
> +
> +Example output:
> +  x - computation takes place for pair
> +  b - baseline sample percentage
> +
> +- perf diff A B C
> +
> +  baseline/A compute/B compute/C  samples
> +  ---------------------------------------
> +  b                    x          f1
> +  b          x         x          f2
> +  b                               f3
> +  b          x                    f4
> +  b                               f6
> +             x         x          f5
> +
> +- perf diff B A C
> +
> +  baseline/B compute/A compute/C  samples
> +  ---------------------------------------
> +  b          x         x          f2
> +  b          x                    f4
> +  b                    x          f5
> +             x         x          f1
> +             x                    f3
> +             x                    f6
> +
> +- perf diff C B A
> +
> +  baseline/C compute/B compute/A  samples
> +  ---------------------------------------
> +  b                    x          f1
> +  b          x         x          f2
> +  b          x                    f5
> +                       x          f3
> +             x         x          f4
> +                       x          f6
> +

It seems not work this way.  When I test multiple diff, I didn't get
consecutive 'b's on the baseline column like your example in the cover
letter of this series.

Thanks,
Namhyung

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab2ICBQv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 21:16:51 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47107 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab2ICBQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 21:16:50 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-d6-504405011a90
From: Namhyung Kim <namhyung@kernel.org>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 11/13] perf tools: replace mempcpy with memcpy
References: <CANg8OW+Y3ZMG-GdhYu2_yKOYH_XEMgw73PdCX_23UTnfYhmttA@mail.gmail.com>
Date: Mon, 03 Sep 2012 10:09:14 +0900
In-Reply-To: <CANg8OW+Y3ZMG-GdhYu2_yKOYH_XEMgw73PdCX_23UTnfYhmttA@mail.gmail.com>
	(Irina Tirdea's message of "Wed, 29 Aug 2012 01:22:16 +0300")
Message-ID: <87y5krewud.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Aug 2012 01:22:16 +0300, Irina Tirdea wrote:
> mempcpy is not supported by bionic in Android
> and will lead to compilation errors.
>
> Replacing mempcpy with memcpy so it will work in Android.

Unfortunately I've added another instance of the mempcpy in a
libtraceevent code. :-/

Thanks,
Namhyung


>
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> ---
>  tools/perf/util/target.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
> index 051eaa6..065528b 100644
> --- a/tools/perf/util/target.c
> +++ b/tools/perf/util/target.c
> @@ -117,8 +117,8 @@ int perf_target__strerror(struct perf_target
> *target, int errnum,
>
>  		if (err != buf) {
>  			size_t len = strlen(err);
> -			char *c = mempcpy(buf, err, min(buflen - 1, len));
> -			*c = '\0';
> +			memcpy(buf, err, min(buflen - 1, len));
> +			*(buf + min(buflen - 1, len)) = '\0';
>  		}
>
>  		return 0;

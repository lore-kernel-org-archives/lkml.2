Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab2F0Nkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:40:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50031 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab2F0Nkm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:40:42 -0400
MIME-Version: 1.0
In-Reply-To: <87fw9hyvt5.fsf@sejong.aot.lge.com>
References: <CACV3sbKFcHgai6AzKGrf=LEb67VjZXjMUqMQuXAOUmby7CeiJg@mail.gmail.com>
	<87fw9hyvt5.fsf@sejong.aot.lge.com>
Date: Wed, 27 Jun 2012 21:40:40 +0800
Message-ID: <CACV3sbL7qQRe9oo6uCm-dLATU1nirMxsK0qrkwktuRhX9zpZtQ@mail.gmail.com>
Subject: Re: [PATCH] perf: fix wrong hw_breakpoint documentation
From: Jovi Zhang <bookjovi@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, mingo@redhat.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

> It should be a bug in event parser. I guess the patch below will fix it:
>
>
> diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
> index 488362e14133..aafca33a8a09 100644
> --- a/tools/perf/util/parse-events.l
> +++ b/tools/perf/util/parse-events.l
> @@ -76,7 +76,7 @@ num_hex               0x[a-fA-F0-9]+
>  num_raw_hex    [a-fA-F0-9]+
>  name           [a-zA-Z_*?][a-zA-Z0-9_*?]*
>  modifier_event [ukhpGH]{1,8}
> -modifier_bp    [rwx]
> +modifier_bp    [rwx]+
>

that should also be fine, but it will export rx/wx interface to user,
and rx/wx mostly not supported on many architecture.
Perhaps this issue is very tiny :)

[root@jovi perf]# ./perf stat -e mem:0x080652c8:rx  -e mem:0x0 --
/usr/bin/ls > /dev/null

Performance counter stats for '/usr/bin/ls':

  <not supported> mem:0x80652c8:rx
                0 mem:(nil):rw

      0.006728643 seconds time elapsed

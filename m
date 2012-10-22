Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab2JVH53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 03:57:29 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48336 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2JVH52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 03:57:28 -0400
X-AuditID: 9c930197-b7c4aae000004160-ff-5084fc65c7ac
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 03/11] perf tool: Use PERF_EVENT_IOC_ID perf ioctl to read event id
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
	<1350743599-4805-4-git-send-email-jolsa@redhat.com>
Date: Mon, 22 Oct 2012 16:57:24 +0900
In-Reply-To: <1350743599-4805-4-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Sat, 20 Oct 2012 16:33:11 +0200")
Message-ID: <87ehkrj5wb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just a minor nitpicking..


On Sat, 20 Oct 2012 16:33:11 +0200, Jiri Olsa wrote:
> Changing the way we retrieve the event ID. Instead of parsing out
> the ID out of the read data, using the PERF_EVENT_IOC_ID ioctl.
>
> Keeping the old way in place to support kernels without
> PERF_EVENT_IOC_ID ioctl support.
[snip]
> +	} else if (errno)
> +		return -1;

Is this check really needed?  I think that returning non-zero from the
ioctl always sets the errno, no?  How about this:

	ret = ioctl(fd, PERF_EVENT_IOC_ID, &id);
	if (!ret)
		goto add;

	if (errno != ENOTTY)
		return -1;

	...

I guess that it'll show you better diff stat. :)

Thanks,
Namhyung

>  
> -	perf_evlist__id_add(evlist, evsel, cpu, thread, read_data[id_idx]);
> + add:
> +	perf_evlist__id_add(evlist, evsel, cpu, thread, id);
>  	return 0;
>  }

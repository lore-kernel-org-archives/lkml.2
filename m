Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402Ab2EVD3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 23:29:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44773 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758226Ab2EVD3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 23:29:06 -0400
Message-ID: <4FBB07FD.6080309@gmail.com>
Date: Mon, 21 May 2012 21:29:01 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] perf, tool: Carry perf_event_attr bitfield throught
 different endians
References: <1337151548-2396-1-git-send-email-jolsa@redhat.com> <1337151548-2396-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1337151548-2396-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/12 12:59 AM, Jiri Olsa wrote:
> When the perf data file is read cross architectures, the perf_event__attr_swap
> function takes care about endianness of all the struct fields except the
> bitfield flags.
>
> The bitfield flags need to be transformed as well, since the bitfield
> binary storage differs for both endians.
>
> ABI says:
>    Bit-fields are allocated from right to left (least to most significant)
>    on little-endian implementations and from left to right (most to least
>    significant) on big-endian implementations.
>
> The above seems to be byte specific, so we need to reverse each
> byte of the bitfield. 'Internet' also says this might be implementation
> specific and we probably need proper fix and carry perf_event_attr
> bitfield flags in separate data file FEAT_ section. Thought this seems
> to work for now.
>
> Note, running following to test perf endianity handling:
> test 1)
>    - origin system:
>      # perf record -a -- sleep 10 (any perf record will do)
>      # perf report>  report.origin
>      # perf archive perf.data
>
>    - copy the perf.data, report.origin and perf.data.tar.bz2
>      to a target system and run:
>      # tar xjvf perf.data.tar.bz2 -C ~/.debug
>      # perf report>  report.target
>      # diff -u report.origin report.target
>
>    - the diff should produce no output
>      (besides some white space stuff and possibly different
>       date/TZ output)
>
> test 2)
>    - origin system:
>      # perf record -ag -fo /tmp/perf.data -- sleep 1
>    - mount origin system root to the target system on /mnt/origin
>    - target system:
>      # perf script --symfs /mnt/origin -I -i /mnt/origin/tmp/perf.data \
>       --kallsyms /mnt/origin/proc/kallsyms
>    - complete perf.data header is displayed
>
> Signed-off-by: Jiri Olsa<jolsa@redhat.com>
> ---
>   tools/perf/util/session.c |   34 ++++++++++++++++++++++++++++++++++
>   1 files changed, 34 insertions(+), 0 deletions(-)


Reviewed-by and Tested-by: David Ahern <dsahern@gmail.com>

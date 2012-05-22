Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759787Ab2EVDfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 23:35:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53890 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759759Ab2EVDfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 23:35:50 -0400
Message-ID: <4FBB0991.9070307@gmail.com>
Date: Mon, 21 May 2012 21:35:45 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] perf, tool: Handle endianity swap on sample_id_all
 header data
References: <1337151548-2396-1-git-send-email-jolsa@redhat.com> <1337151548-2396-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1337151548-2396-5-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/12 12:59 AM, Jiri Olsa wrote:
> Adding endianity swapping for event header attached via sample_id_all.
>
> Currently we dont do that and it's causing wrong data to be read when
> running report on architecture with different endianity than the record.
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

The code change is fine, but the commit message could use some 
additions: for example, what does the current output look like and how 
does the patch change it.

For example, perf is currently able to process 32-bit PPC samples on 
32-bit and 64-bit x86 -- that's the use case I have and it works. So an 
example of the affects of this patch for the commit log would be helpful.

Code wise:
Reviewed-by and Tested-by: David Ahern <dsahern@gmail.com>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab2EVEiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 00:38:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63261 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab2EVEiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 00:38:13 -0400
Message-ID: <4FBB1831.80906@gmail.com>
Date: Mon, 21 May 2012 22:38:09 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] perf, tool: Fix 32 bit values endianity swap for
 sample_id_all header
References: <1337151548-2396-1-git-send-email-jolsa@redhat.com> <1337151548-2396-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1337151548-2396-6-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/16/12 12:59 AM, Jiri Olsa wrote:
> We swap the sample_id_all header by u64 pointers. Some members
> of the header happen to be 32 bit values. We need to handle them
> separatelly.
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

Same comment as the last - the commit log could use some words about 
command line arguments you are running and how the output is affected. 
As I mentioned perf-report/script on x86 processes data files and parses 
samples from 32-bit ppc just fine -- including tid, pid, comm, 
filenames, symbols, etc. So is the sample_id_all path run and how does 
this patch change it.

Code wise:
Reviewed-by and Tested-by: David Ahern <dsahern@gmail.com>


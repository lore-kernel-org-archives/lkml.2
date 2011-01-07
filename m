Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1AGXEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 18:04:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34506 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563Ab1AGXEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 18:04:54 -0500
Date: Sat, 8 Jan 2011 00:04:52 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizf@cn.fujitsu.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Documentation/trace/events.txt: Remove obsolete
 sched_signal_send.
In-Reply-To: <1294207674-3912-1-git-send-email-tm@tao.ma>
Message-ID: <alpine.LNX.2.00.1101080004420.26685@pobox.suse.cz>
References: <1294207674-3912-1-git-send-email-tm@tao.ma>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jan 2011, Tao Ma wrote:

> From: Tao Ma <boyu.mt@taobao.com>
> 
> 'sched_signal_send' doesn't exist in the kernel now. Replace it
> with 'signal_generate' so that the example in events.txt can be
> executed successfully.
> 
> I also change some /debug to /sys/kernel/debug which is debugfs'
> default mount directory now(similar to commit 52ad51e).
> 
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  Documentation/trace/events.txt |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
> index 09bd8e9..b510564 100644
> --- a/Documentation/trace/events.txt
> +++ b/Documentation/trace/events.txt
> @@ -125,7 +125,7 @@ is the size of the data item, in bytes.
>  For example, here's the information displayed for the 'sched_wakeup'
>  event:
>  
> -# cat /debug/tracing/events/sched/sched_wakeup/format
> +# cat /sys/kernel/debug/tracing/events/sched/sched_wakeup/format
>  
>  name: sched_wakeup
>  ID: 60
> @@ -201,19 +201,19 @@ to the 'filter' file for the given event.
>  
>  For example:
>  
> -# cd /debug/tracing/events/sched/sched_wakeup
> +# cd /sys/kernel/debug/tracing/events/sched/sched_wakeup
>  # echo "common_preempt_count > 4" > filter
>  
>  A slightly more involved example:
>  
> -# cd /debug/tracing/events/sched/sched_signal_send
> +# cd /sys/kernel/debug/tracing/events/signal/signal_generate
>  # echo "((sig >= 10 && sig < 15) || sig == 17) && comm != bash" > filter
>  
>  If there is an error in the expression, you'll get an 'Invalid
>  argument' error when setting it, and the erroneous string along with
>  an error message can be seen by looking at the filter e.g.:
>  
> -# cd /debug/tracing/events/sched/sched_signal_send
> +# cd /sys/kernel/debug/tracing/events/signal/signal_generate
>  # echo "((sig >= 10 && sig < 15) || dsig == 17) && comm != bash" > filter
>  -bash: echo: write error: Invalid argument
>  # cat filter

Applied, thanks for catching this.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

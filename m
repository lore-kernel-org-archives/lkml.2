Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab2AJLJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 06:09:53 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36227 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853Ab2AJLJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 06:09:52 -0500
Date: Tue, 10 Jan 2012 11:09:42 +0000
From: Will Deacon <will.deacon@arm.com>
To: "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        gregkh@suse.de
Subject: Re: perf event group siblings not counting in mainline
Message-ID: <20120110110942.GB24180@mudshark.cambridge.arm.com>
References: <20111224125415.GA14559@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111224125415.GA14559@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 24, 2011 at 12:54:15PM +0000, Will Deacon wrote:
> If I try using perf with event groups on a mainline kernel, only the group
> leader counts:
> 
> 
> linaro@mashed-potato:~$ perf stat --no-scale -g -e task-clock -e cpu-clock -e cs -- ls
> hwb  linux
> 
>  Performance counter stats for 'ls':
> 
>          17.545541 task-clock                #    0.634 CPUs utilized
>           0.000000 cpu-clock
>                  0 cs                        #    0.000 M/sec
> 
>        0.027684984 seconds time elapsed
> 
> 
> This is fixed by b79387ef ("perf: Fix enable_on_exec for sibling events")
> in -next (20111222) but I can't see this queued anywhere for 3.2 (I thought
> I might see it in -rc7).
> 
> Is this going in for the final cut, or will groups just be borked until 3.3?

Now that 3.2 is out with this regression, would it be possible to get this
(b79387ef ("perf: Fix enable_on_exec for sibling events")) into -stable please?

Will

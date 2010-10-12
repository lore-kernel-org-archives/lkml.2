Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab0JLGDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 02:03:30 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:44083 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752993Ab0JLGD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 02:03:29 -0400
Date: Tue, 12 Oct 2010 07:03:27 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Robert Richter <robert.richter@amd.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the oprofile tree with the tip tree
Message-ID: <20101012060327.GA13409@console-pimps.org>
References: <20101012131828.5fedf1bf.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101012131828.5fedf1bf.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 01:18:28PM +1100, Stephen Rothwell wrote:
> Hi Robert,
> 
> Today's linux-next merge of the oprofile tree got a conflict in
> arch/arm/oprofile/common.c between commit
> 38a81da2205f94e8a2a834b51a6b99c91fc7c2e8 ("perf events: Clean up pid
> passing") from the tip tree and commit
> 3d90a00763b51e1db344a7430c966be723b67a29 ("oprofile: Abstract the
> perf-events backend") from the oprofile tree.
> 
> The latter moved the code modified by the former, so I used the version
> of this file from the oprofile tree.  I also applied the effect of the
> tip tree patch to the new file drivers/oprofile/oprofile_perf.c:
> 
> diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
> index b17235a..afbc43b 100644
> --- a/drivers/oprofile/oprofile_perf.c
> +++ b/drivers/oprofile/oprofile_perf.c
> @@ -77,7 +77,7 @@ static int op_create_counter(int cpu, int event)
>  		return 0;
>  
>  	pevent = perf_event_create_kernel_counter(&counter_config[event].attr,
> -						  cpu, -1,
> +						  cpu, NULL1,
>  						  op_overflow_handler);

Is that a typo? Shouldn't that be NULL, and not NULL1?

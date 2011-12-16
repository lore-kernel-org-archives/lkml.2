Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab1LPAOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 19:14:49 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45684 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759671Ab1LPAOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 19:14:47 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4EEA8D43.8090506@jp.fujitsu.com>
Date: Fri, 16 Dec 2011 09:13:55 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>, Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 4/6] x86, mce: Add mechanism to safely save information
 in MCE handler
References: <cover.1323979146.git.tony.luck@intel.com> <5d6588ab3dadabd8334cffee06b3e87abe3b81b7.1323979146.git.tony.luck@intel.com>
In-Reply-To: <5d6588ab3dadabd8334cffee06b3e87abe3b81b7.1323979146.git.tony.luck@intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/12/15 8:55), Tony Luck wrote:
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 645070f..7d7303a 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -887,6 +887,49 @@ static void mce_clear_state(unsigned long *toclear)
>  }
>  
>  /*
> + * Need to save faulting physical address associated with a process
> + * in the machine check handler some place where we can grab it back
> + * later in mce_notify_process()
> + */
> +#define	MAX_MCE_INFO	16

(nitpick) IMHO, I'd prefer MCE_INFO_MAX.

Thanks,
H.Seto


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab2DEVLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 17:11:19 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:53614
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753543Ab2DEVLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 17:11:17 -0400
X-SpamScore: -10
X-BigFish: VPS-10(zzbb2dI1432N98dKzz1202hzz8275dhz2dh668h839hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M20YUK-01-ALP-02
X-M-MSG: 
Message-ID: <4F7E0A6A.40204@amd.com>
Date: Thu, 5 Apr 2012 17:11:06 -0400
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111101 SUSE/3.1.16 Thunderbird/3.1.16
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, Len Brown <len.brown@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: BUG at cpuidle_play_dead
References: <4F7E0884.5090602@suse.cz>
In-Reply-To: <4F7E0884.5090602@suse.cz>
Content-Type: text/plain; charset="ISO-8859-2"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/12 17:03, Jiri Slaby wrote:
> Hi,
>
> I'm hitting this BUG as the last thing during shutdown:
> BUG: unable to handle kernel NULL pointer dereference at 00000000000002d8
> IP: [<ffffffff814ab60d>] cpuidle_play_dead+0x1d/0xb0
>
>
> It's because drv is NULL. The problem is gone if I do this:
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -83,6 +83,11 @@ int cpuidle_play_dead(void)
>          int i, dead_state = -1;
>          int power_usage = -1;
>
> +       if (!drv) {
> +               printk("DRIVER IS NULL\n");
> +               return -ENODEV;
> +       }
> +
>          /* Find lowest-power state that supports long-term idle */
>          for (i = CPUIDLE_DRIVER_STATE_START; i<  drv->state_count; i++) {
>                  struct cpuidle_state *s =&drv->states[i];
>
> thanks,


This was already fixed in https://lkml.org/lkml/2012/3/31/249.

Len, please apply that patch.

Thanks.
-boris


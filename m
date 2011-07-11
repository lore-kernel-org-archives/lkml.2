Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab1GKQmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 12:42:15 -0400
Received: from smtpo.poczta.interia.pl ([217.74.65.206]:34489 "EHLO
	smtpo.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758104Ab1GKQmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 12:42:13 -0400
X-Greylist: delayed 1186 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jul 2011 12:42:13 EDT
Message-ID: <4E1B269E.2060408@interia.pl>
Date: Mon, 11 Jul 2011 17:36:46 +0100
From: =?UTF-8?b?UmFmYcWC?= Bilski <rafalbilski@interia.pl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:5.0) Gecko/20110628
	Thunderbird/5.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        cpufreq@vger.kernel.org
Subject: Re: [RFC][PATCH] cpufreq: e_powersaver: Fix checking brand for
 EPS_BRAND_C3
References: <1310114243.2940.3.camel@phoenix>
In-Reply-To: <1310114243.2940.3.camel@phoenix>
X-Interia-Antivirus: OK
X-EMID: 820da958
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Do not return -ENODEV for EPS_BRAND_C3.
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---
> I just found the code is suspect.
> I don't have this hardware handy.
> Anyone can help to confirm and test if this patch works?
> Axel
>
>   drivers/cpufreq/e_powersaver.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
> index 35a257d..637f055 100644
> --- a/drivers/cpufreq/e_powersaver.c
> +++ b/drivers/cpufreq/e_powersaver.c
> @@ -199,8 +199,9 @@ static int eps_cpu_init(struct cpufreq_policy *policy)
>   		break;
>   	case EPS_BRAND_C3:
>   		printk(KERN_CONT "C3\n");
> -		return -ENODEV;
>   		break;
> +	default:
> +		return -ENODEV;
>   	}
>   	/* Enable Enhanced PowerSaver */
>   	rdmsrl(MSR_IA32_MISC_ENABLE, val);
EPS_BRAND_C3 isn't handled by this driver. So you have to return -ENODEV 
for it. Why this code is suspect?
If you looking for an error it is probably in:
 > rdmsr(0x1154, lo, hi);
 > brand = (((lo >> 4) ^ (lo >> 2))) & 0x000000ff;
which was added later to this driver. Probably & 0xff should be replaced 
by & 3.

Best regards
Rafał Bilski


----------------------------------------------------------------
Najwieksza baza samochodow nowych i uzywanych
Sprawdz >> http://linkint.pl/f29e3

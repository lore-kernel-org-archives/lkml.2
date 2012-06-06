Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab2FFPMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:12:55 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60146 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab2FFPMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:12:53 -0400
Message-ID: <4FCF6DD4.4090608@linux.vnet.ibm.com>
Date: Wed, 06 Jun 2012 07:48:52 -0700
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
CC: Linux PM mailing list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "Tomas M." <tmezzadra@gmail.com>,
        Ferenc Wagner <wferi@niif.hu>, Arnd Bergmann <arnd@arndb.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Kevin Hilman <khilman@ti.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Jean Pihet <j-pihet@ti.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        linux-pm@lists.linux-foundation.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        preeti@linux.vnet.ibm.com
Subject: Re: Suspend/resume regressions on Lenovo S10-3
References: <4FC2DA8C.7050401@linux.vnet.ibm.com> <4FCF5249.2070600@linux.vnet.ibm.com>
In-Reply-To: <4FCF5249.2070600@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060615-5806-0000-0000-000015F0430A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2012 05:51 AM, Deepthi Dharwar wrote:
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index 24fe3af..6e35293 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -895,8 +895,9 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
>  	if (unlikely(!pr))
>  		return -EINVAL;
> 
> -
>  	if (acpi_idle_suspend) {
> +		local_irq_disable();
> +		local_irq_enable();
>  		cpu_relax();
>  		return -EINVAL;
>  	}

Heh, that is quite the hack. :)

However, it does at least work around my problem: I can suspend again
with 46bcfad + your patch.


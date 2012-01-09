Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab2AINBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 08:01:09 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:53172 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab2AINBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 08:01:07 -0500
Message-ID: <4F0AE507.8020200@linux.vnet.ibm.com>
Date: Mon, 09 Jan 2012 18:30:55 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Len Brown <len.brown@intel.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Kevin Hilman <khilman@ti.com>, Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch] cpuidle: checking the wrong variable in __cpuidle_register_device()
References: <20120109105454.GA6940@elgon.mountain>
In-Reply-To: <20120109105454.GA6940@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12010902-5490-0000-0000-00000080E376
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2012 04:24 PM, Dan Carpenter wrote:

> We updated this in 8a25a2fd12 "cpu: convert 'cpu' and 'machinecheck'
> sysdev_class to a regular subsystem" but it should be checking "cpu_dev"
> here not "dev".  The "dev" variable was dereferenced already.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 59f4261..7771810 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -294,7 +294,7 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
>  	struct device *cpu_dev = get_cpu_device((unsigned long)dev->cpu);
>  	struct cpuidle_driver *cpuidle_driver = cpuidle_get_driver();
> 
> -	if (!dev)
> +	if (!cpu_dev)
>  		return -EINVAL;
>  	if (!try_module_get(cpuidle_driver->owner))
>  		return -EINVAL;


Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>


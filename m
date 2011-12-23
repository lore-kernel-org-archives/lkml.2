Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab1LWVEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 16:04:48 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:34797 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757811Ab1LWVEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 16:04:44 -0500
Message-ID: <4EF4FAF0.3090308@xenotime.net>
Date: Fri, 23 Dec 2011 14:04:32 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: Re: Print PCI device in power management warning.
References: <20111223181626.GA18647@redhat.com> <20111223202635.GA20991@andromeda.dapyr.net> <20111223204608.GA24014@redhat.com>
In-Reply-To: <20111223204608.GA24014@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2011 12:46 PM, Dave Jones wrote:
> On Fri, Dec 23, 2011 at 04:26:35PM -0400, Konrad Rzeszutek Wilk wrote:
>  
>  > don't you just want:
>  > 
>  > 	WARN(ret && drv->driver.pm, "pci: %s Has both legacy and new PM
>  > support!\n", drv_name(drv));
>  > 
>  > which will do what it previously does and also add the message you
>  > wanted to add?
> 
> close. Not sure what drv_name() is, but I don't seem to have it in my tree.
> This works though..
> 
> --- 
> 
> When the WARN_ON in pci_has_legacy_pm_support() triggers, we get
> users filing backtraces, but it's not obvious which driver is
> triggering the trace.  Printing the driver name in addition to the trace
> should make these easier to debug.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 12d1e81..8af9ff2 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -604,7 +604,7 @@ static bool pci_has_legacy_pm_support(struct pci_dev *pci_dev)
>  	 * supported as well.  Drivers are supposed to support either the
>  	 * former, or the latter, but not both at the same time.
>  	 */
> -	WARN_ON(ret && drv->driver.pm);
> +	WARN(ret && drv->driver.pm, "pci: %s Has both legacy and new PM support!\n", drv->name);

	                                     has

and why not cc: linux-pci?


>  
>  	return ret;
>  }
> --


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

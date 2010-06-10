Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab0FJFgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 01:36:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44760 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab0FJFgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 01:36:47 -0400
Message-ID: <4C1079CA.1030301@oracle.com>
Date: Wed, 09 Jun 2010 22:36:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/device: Move struct of_device define outside of CONFIG_OF_DEVICE
 test
References: <20100610045159.615.89343.stgit@angua>
In-Reply-To: <20100610045159.615.89343.stgit@angua>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4C1079EB.01E2:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/10 21:54, Grant Likely wrote:
> Some code uses of_device even when CONFIG_OF_DEVICE is not set.  This
> patch makes of_device valid all the time by moving it outside of the
> ifdef CONFIG_OF_DEVICE test.
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> 
> Hi Randy,
> 
> Here's what I applied to my tree to fix the niu driver compile warning.
> I've compile tested it on several architectures, and am pushing it out
> to my linux-next branch now.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

along with the niu.c patch, of course.

> g.
> 
>  include/linux/of_device.h |   12 +++++-------
>  1 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/of_device.h b/include/linux/of_device.h
> index c877d54..8cd1fe7 100644
> --- a/include/linux/of_device.h
> +++ b/include/linux/of_device.h
> @@ -1,13 +1,6 @@
>  #ifndef _LINUX_OF_DEVICE_H
>  #define _LINUX_OF_DEVICE_H
>  
> -#ifdef CONFIG_OF_DEVICE
> -#include <linux/device.h>
> -#include <linux/platform_device.h>
> -#include <linux/of.h>
> -#include <linux/mod_devicetable.h>
> -
> -
>  /*
>   * The of_device *was* a kind of "base class" that was a superset of
>   * struct device for use by devices attached to an OF node and probed
> @@ -22,7 +15,12 @@
>   * from the kernel.
>   */
>  #define of_device platform_device
> +#include <linux/platform_device.h>
>  
> +#ifdef CONFIG_OF_DEVICE
> +#include <linux/device.h>
> +#include <linux/of.h>
> +#include <linux/mod_devicetable.h>
>  #include <asm/of_device.h>
>  
>  #define	to_of_device(d) container_of(d, struct of_device, dev)
> 


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

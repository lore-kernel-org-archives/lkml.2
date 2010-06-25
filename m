Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab0FYCEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 22:04:24 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47910 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab0FYCEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 22:04:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Subject: Re: [PATCH] memory hotplug disable boot option
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <4C24012B.9030506@austin.ibm.com>
References: <4C24012B.9030506@austin.ibm.com>
Message-Id: <20100625105340.803C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 25 Jun 2010 11:04:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Proposed patch to disable memory hotplug via a boot option,
> mem_hotplug=[on|off].  The patch only disables memory hotplug in that it 
> prevents the creation of the memory sysfs directories for memory sections.
> 
> This patch is meant to help alleviate very long boot times on systems with
> large memory (1+ TB) and many memory sections (10's of thousands).

Why making simple /sys file is so slowly? Couldn't we fix such performance
problem?


> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
> 
> ---
>  drivers/base/memory.c  |   33 +++++++++++++++++++++++++++++++++
>  drivers/base/node.c    |    3 +++
>  include/linux/memory.h |    2 ++
>  3 files changed, 38 insertions(+)
> 
> Index: linux-2.6/drivers/base/memory.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/memory.c	2010-06-23 15:07:03.000000000 -0500
> +++ linux-2.6/drivers/base/memory.c	2010-06-24 18:46:52.000000000 -0500
> @@ -29,6 +29,24 @@
>  
>  #define MEMORY_CLASS_NAME	"memory"
>  
> +static int mem_hp_enabled __read_mostly = 1;

please don't use 'hp' acronym. 'hotplug' is not so long word.


> +
> +static int __setup_memory_hotplug(char *option)
> +{
> +	if (!strcmp(option, "off"))
> +		mem_hp_enabled = 0;
> +	else if (!strcmp(option, "on"))
> +		mem_hp_enabled = 1;
> +
> +	return 1;
> +}
> +__setup("mem_hotplug=", __setup_memory_hotplug);

no documentation on Documentation/kernel-parameters.txt?





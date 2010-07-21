Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab0GUFlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:41:36 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28630 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab0GUFld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 01:41:33 -0400
Message-ID: <4C468883.4050207@oracle.com>
Date: Tue, 20 Jul 2010 22:41:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, buytenh@wantstofly.org
Subject: Re: [PATCH -next] net: NET_DSA depends on NET_ETHERNET
References: <20100706103417.8923b697.randy.dunlap@oracle.com>	<20100710.190954.245403400.davem@davemloft.net>	<4C462B44.5010107@oracle.com> <20100720.174530.139530021.davem@davemloft.net>
In-Reply-To: <20100720.174530.139530021.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C468886.0239:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/10 17:45, David Miller wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> Date: Tue, 20 Jul 2010 16:03:32 -0700
> 
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> NET_DSA code selects and uses PHYLIB code, but PHYLIB depends on
>> NET_ETHERNET.  However, "select" does not follow kconfig dependencies,
>> so explicitly list that requirement here instead.
>>
>> Fixes this kconfig warning:
>>
>> warning: (NET_DSA && NET && EXPERIMENTAL && !S390 ...) selects PHYLIB which has unmet direct dependencies (!S390 && NET_ETHERNET)
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Randy, this has been fixed in net-2.6 for some time now.

OK, I did see the commit get merged today.

> And I'm pretty sure I sent a copy of this to you when I
> checked it in :-)

I missed it somehow.  Thanks.

> --------------------
> From 336a283b9cbe47748ccd68fd8c5158f67cee644b Mon Sep 17 00:00:00 2001
> From: David S. Miller <davem@davemloft.net>
> Date: Mon, 12 Jul 2010 20:03:42 -0700
> Subject: [PATCH 09/24] dsa: Fix Kconfig dependencies.
> 
> Based upon a report by Randy Dunlap.
> 
> DSA needs PHYLIB, but PHYLIB needs NET_ETHERNET.  So, in order
> to select PHYLIB we have to make DSA depend upon NET_ETHERNET.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  net/dsa/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index c51b554..1120178 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -1,7 +1,7 @@
>  menuconfig NET_DSA
>  	bool "Distributed Switch Architecture support"
>  	default n
> -	depends on EXPERIMENTAL && !S390
> +	depends on EXPERIMENTAL && NET_ETHERNET && !S390
>  	select PHYLIB
>  	---help---
>  	  This allows you to use hardware switch chips that use


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

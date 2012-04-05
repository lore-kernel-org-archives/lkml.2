Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab2DEFgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 01:36:45 -0400
Received: from mail4.ccl.ru ([195.222.140.73]:53158 "EHLO mail4.ccl.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746Ab2DEFgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 01:36:44 -0400
Message-ID: <4F7D2F61.8040601@permonline.ru>
Date: Thu, 05 Apr 2012 11:36:33 +0600
From: Mike Sinkovsky <msink@permonline.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH v8 0/2] Ethernet drivers for WIZnet chips
References: <1333524216-23488-1-git-send-email-msink@permonline.ru><1333540660-30551-1-git-send-email-msink@trikom.ru> <20120404.211506.929057223227809703.davem@davemloft.net>
In-Reply-To: <20120404.211506.929057223227809703.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-7; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

05.04.2012 7:15, David Miller wrote:
> From: Mike Sinkovsky<msink@trikom.ru>
> Date: Wed,  4 Apr 2012 17:57:38 +0600
>
>> From: Mike Sinkovsky<msink@permonline.ru>
>>
>> Based on original driver from chip manufacturer, but nearly full rewite.
>> Tested and used in production with Blackfin BF531 embedded processor.
>>
>> Signed-off-by: Mike Sinkovsky<msink@permonline.ru>
>
> I don't see the appropriate changes in your patches to make
> sure that drivers/net/ethernet/{Kconfig,Makefile} consider
> and traverse down into the wiznet/ subdirectory.
>
> Furthermore, once that is fixed these drivers generate warnings
> when built:
>
> drivers/net/ethernet/wiznet/w5300.c:708:8: warning: initialization from incompatible pointer type [enabled by default]
> drivers/net/ethernet/wiznet/w5300.c:708:8: warning: (near initialization for ¡w5300_pm_ops.suspend¢) [enabled by default]
> drivers/net/ethernet/wiznet/w5300.c:708:8: warning: initialization from incompatible pointer type [enabled by default]
> drivers/net/ethernet/wiznet/w5300.c:708:8: warning: (near initialization for ¡w5300_pm_ops.resume¢) [enabled by default]
> drivers/net/ethernet/wiznet/w5300.c:708:8: warning: initialization from incompatible pointer type [enabled by default]
> drivers/net/ethernet/wiznet/w5300.c:708:8: warning: (near initialization for ¡w5300_pm_ops.freeze¢) [enabled by default]
> drivers/net/ethernet/wiznet/w5300.c:708:8: warning: initialization from incompatible pointer type [enabled by default]
> drivers/net/ethernet/wiznet/w5300.c:708:8: warning: (near initialization for ¡w5300_pm_ops.thaw¢) [enabled by default]
> drivers/net/ethernet/wiznet/w5300.c:708:8: warning: initialization from incompatible pointer type [enabled by default]
> drivers/net/ethernet/wiznet/w5300.c:708:8: warning: (near initialization for ¡w5300_pm_ops.poweroff¢) [enabled by default]
> drivers/net/ethernet/wiznet/w5300.c:708:8: warning: initialization from incompatible pointer type [enabled by default]
> drivers/net/ethernet/wiznet/w5300.c:708:8: warning: (near initialization for ¡w5300_pm_ops.restore¢) [enabled by default]
>
> It seems that the arguments and return types for these operations have
> changed since you worked on these patches, but this should be easy
> to fix up.
>
> Please cure these two issues and I'll happily put these new drivers
> into net-next, and meanwhile you can continue to work with Eric
> Dumazet to correct the TX flow control and locking issues.
>
> Thanks.

Fixed and posted v9.

Thanks.

-- 
Mike


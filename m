Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab1EWDf5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 23:35:57 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:58606 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445Ab1EWDf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 23:35:56 -0400
Message-ID: <4DD9D5EB.3060807@st.com>
Date: Mon, 23 May 2011 09:05:07 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] ata: PATA_ARASAN_CF depends on DMADEVICES
References: <20110520165507.cba539d5.sfr@canb.auug.org.au> <20110522173227.5ba18817.randy.dunlap@oracle.com>
In-Reply-To: <20110522173227.5ba18817.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2011 06:02 AM, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kconfig unmet dependency warning:
> 
> warning: (PATA_ARASAN_CF && VIDEO_TIMBERDALE && SND_SOC_SH4_SIU) selects DMA_ENGINE which has unmet direct dependencies (DMADEVICES)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/ata/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20110520.orig/drivers/ata/Kconfig
> +++ linux-next-20110520/drivers/ata/Kconfig
> @@ -313,6 +313,7 @@ config PATA_AMD
>  
>  config PATA_ARASAN_CF
>  	tristate "ARASAN CompactFlash PATA Controller Support"
> +	depends on DMADEVICES
>  	select DMA_ENGINE

Randy,

I think we can also remove this "select DMA_ENGINE" line.

Otherwise, it looks fine.

Acked-by: Viresh Kumar <viresh.kumar@st.com>

-- 
viresh

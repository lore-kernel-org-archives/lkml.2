Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab1ESBe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 21:34:58 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:35103 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab1ESBe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 21:34:56 -0400
Subject: Re: [PATCH 5/6] forcedeth: Add messages to indicate using MSI or
 MSI-X
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Decotigny <decot@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-net-upstream@google.com,
        Mike Ditto <mditto@google.com>
In-Reply-To: <1305764080-24853-5-git-send-email-decot@google.com>
References: <1305764080-24853-1-git-send-email-decot@google.com>
	 <1305764080-24853-5-git-send-email-decot@google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare
Date: Thu, 19 May 2011 02:34:52 +0100
Message-ID: <1305768892.19966.176.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 May 2011 01:34:56.0519 (UTC) FILETIME=[F59A1170:01CC15C4]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18142.005
X-TM-AS-Result: No--13.292400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 17:14 -0700, David Decotigny wrote:
> From: Mike Ditto <mditto@google.com>
> 
> This adds a few debug messages to indicate whether PCIe interrupts are
> signaled with MSI or MSI-X.
> 
> 
> Signed-off-by: David Decotigny <decot@google.com>
> ---
>  drivers/net/forcedeth.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
> index 17e79de..2712ddc 100644
> --- a/drivers/net/forcedeth.c
> +++ b/drivers/net/forcedeth.c
> @@ -3745,6 +3745,7 @@ static int nv_request_irq(struct net_device *dev, int intr_test)
>  				writel(0, base + NvRegMSIXMap0);
>  				writel(0, base + NvRegMSIXMap1);
>  			}
> +			netdev_info(dev, "forcedeth: MSI-X enabled\n");
[...]

netdev_info() and similar logging functions already include the driver
name.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


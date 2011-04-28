Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab1D1Hf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 03:35:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab1D1HfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 03:35:25 -0400
Date: Thu, 28 Apr 2011 09:34:18 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: David Decotigny <decot@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <bhutchings@solarflare.com>, mirq-linux@rere.qmqm.pl,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        Grant Grundler <grundler@parisc-linux.org>,
        e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCHv4 2/7] ethtool: Call ethtool's get/set_settings callbacks
 with cleaned data
Message-ID: <20110428073417.GA2220@redhat.com>
References: <1303965163-8198-1-git-send-email-decot@google.com>
 <1303965163-8198-3-git-send-email-decot@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303965163-8198-3-git-send-email-decot@google.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 09:32:38PM -0700, David Decotigny wrote:
> --- a/drivers/net/stmmac/stmmac_ethtool.c
> +++ b/drivers/net/stmmac/stmmac_ethtool.c
> @@ -237,13 +237,12 @@ stmmac_set_pauseparam(struct net_device *netdev,
>  
>  	if (phy->autoneg) {
>  		if (netif_running(netdev)) {
> -			struct ethtool_cmd cmd;
> +			struct ethtool_cmd cmd = { .cmd = ETHTOOL_SSET };
>  			/* auto-negotiation automatically restarted */
> -			cmd.cmd = ETHTOOL_NWAY_RST;

Why did you change ETHTOOL_NWAY_RST to ETHTOOL_SSET ?


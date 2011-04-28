Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab1D1Mqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 08:46:45 -0400
Received: from mail.solarflare.com ([216.237.3.220]:57841 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab1D1Mqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 08:46:43 -0400
Subject: Re: [PATCHv4 2/7] ethtool: Call ethtool's get/set_settings
 callbacks with cleaned data
From: Ben Hutchings <bhutchings@solarflare.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: David Decotigny <decot@google.com>,
        "David S. Miller" <davem@davemloft.net>, mirq-linux@rere.qmqm.pl,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        Grant Grundler <grundler@parisc-linux.org>,
        e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <20110428073417.GA2220@redhat.com>
References: <1303965163-8198-1-git-send-email-decot@google.com>
	 <1303965163-8198-3-git-send-email-decot@google.com>
	 <20110428073417.GA2220@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare
Date: Thu, 28 Apr 2011 13:46:39 +0100
Message-ID: <1303994799.3032.456.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Apr 2011 12:46:43.0510 (UTC) FILETIME=[53C40D60:01CC05A2]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18102.003
X-TM-AS-Result: No--17.578800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-28 at 09:34 +0200, Stanislaw Gruszka wrote:
> On Wed, Apr 27, 2011 at 09:32:38PM -0700, David Decotigny wrote:
> > --- a/drivers/net/stmmac/stmmac_ethtool.c
> > +++ b/drivers/net/stmmac/stmmac_ethtool.c
> > @@ -237,13 +237,12 @@ stmmac_set_pauseparam(struct net_device *netdev,
> >  
> >  	if (phy->autoneg) {
> >  		if (netif_running(netdev)) {
> > -			struct ethtool_cmd cmd;
> > +			struct ethtool_cmd cmd = { .cmd = ETHTOOL_SSET };
> >  			/* auto-negotiation automatically restarted */
> > -			cmd.cmd = ETHTOOL_NWAY_RST;
> 
> Why did you change ETHTOOL_NWAY_RST to ETHTOOL_SSET ?

Because the function it's calling is an implementation of ETHTOOL_SSET,
not ETHTOOL_NWAY_RST.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


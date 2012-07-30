Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab2G3UJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 16:09:17 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36426 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab2G3UJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 16:09:10 -0400
Date: Mon, 30 Jul 2012 22:09:05 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jon Mason <jon.mason@intel.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [RFC v2 2/2] net: Add support for NTB virtual ethernet device
Message-ID: <20120730200905.GA1673@minipsycho.orion>
References: <1343607994-32415-1-git-send-email-jon.mason@intel.com>
 <1343607994-32415-3-git-send-email-jon.mason@intel.com>
 <20120730140216.GA1550@minipsycho.orion>
 <20120730181910.GB987@jonmason-lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120730181910.GB987@jonmason-lab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mon, Jul 30, 2012 at 08:19:11PM CEST, jon.mason@intel.com wrote:
>On Mon, Jul 30, 2012 at 04:02:16PM +0200, Jiri Pirko wrote:
>> Mon, Jul 30, 2012 at 02:26:34AM CEST, jon.mason@intel.com wrote:
>> >+static int __devinit ntb_netdev_probe(struct pci_dev *pdev)
>> >+{
>> >+	struct net_device *ndev;
>> >+	struct ntb_netdev *dev;
>> >+	int rc;
>> >+
>> >+	ndev = alloc_etherdev(sizeof(struct ntb_netdev));
>> >+	if (!ndev)
>> >+		return -ENOMEM;
>> >+
>> >+	dev = netdev_priv(ndev);
>> >+	dev->ndev = ndev;
>> >+	dev->pdev = pdev;
>> >+	BUG_ON(!dev->pdev);
>> >+	ndev->features = NETIF_F_HIGHDMA;
>> >+
>> >+	//ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
>> 	^^ I guess you forgot to un-comment this.
>
>Oops.  An easy fix.  Anything else?

The rest looks good to me.

>
>Thanks,
>Jon

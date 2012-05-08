Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab2EHIWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 04:22:17 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:11507 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab2EHIWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 04:22:15 -0400
Date: Tue, 8 May 2012 10:15:49 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v3 2/3] Staging: ipack: added support for the TEWS
 TPCI-200 carrier board
Message-ID: <20120508081549.GB18595@becoht-mvanga>
Mail-Followup-To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>
References: <1336463005-26234-1-git-send-email-siglesias@igalia.com>
 <1336463005-26234-2-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1336463005-26234-2-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Samuel,

> +static void tpci200_uninstall(struct tpci200_board *tpci200)
> +{
> +	int i;
> +
> +	for (i = 0; i < TPCI200_NB_SLOT; i++) {
> +		if (tpci200->slots[i].dev == NULL)
> +			continue;
> +		else
> +			tpci200->slots[i].dev->driver->ops->remove(tpci200->slots[i].dev);

Check whether the function exists or you could have trouble :)
If you already added a check when registering to make sure this is always non-NULL then
ignore this. I would recommend wrapping this up in some function:

    void tpci_slot_remove(struct tpci_slot *slot)
    {
        if (slot->dev->driver->ops->remove)
        	slot->dev->driver->ops->remove(slot->dev);
    }

-- 
/manohar

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab1GRMi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 08:38:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52756 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab1GRMi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 08:38:58 -0400
Date: Mon, 18 Jul 2011 15:36:48 +0300
From: Dan Carpenter <error27@gmail.com>
To: Toon Schoenmakers <nighteyes1993@gmail.com>
Cc: gregkh@suse.de, caratorn@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Summary: Fixed all the indents and other errors in
 IEEE11h.c
Message-ID: <20110718123648.GA4010@shale.localdomain>
References: <1310859509.4191.6.camel@Rarity>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310859509.4191.6.camel@Rarity>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 17, 2011 at 01:38:29AM +0200, Toon Schoenmakers wrote:

> +	uNumOfEIDs = ((uLength - offsetof(WLAN_FRAME_MSRREQ,
> +			sMSRReqEIDs))/
> +			(sizeof(WLAN_IE_MEASURE_REQ)));

It would be better to write this in C instead of Lisp:

	uNumOfEIDs = (uLength - offsetof(WLAN_FRAME_MSGREQ, sMSRReqEIDS)) /
			sizeof(WLAN_EI_MEASURE_REQ);

The other advantage of that is that the call to offsetof() is now
all together on one line.

> +	pTxPacket->p80211Header = (PUWLAN_80211HDR)((unsigned char *)pTxPacket +
> +sizeof(STxMgmtPacket));
> +
> +	pFrame = (PWLAN_FRAME_TPCREP)((unsigned char *)pTxPacket +
> +sizeof(STxMgmtPacket));
> +

Don't do that.

> +	pFrame->Header.wFrameCtl = (WLAN_SET_FC_FTYPE(WLAN_FTYPE_MGMT) |
> +				WLAN_SET_FC_FSTYPE(WLAN_FSTYPE_ACTION)
> +				);

The close parenthesis can fit on the end of the other line.  In fact
the paren is not needed at all.  Why is the second line aligned where
you have it?  The WLAN_SET_FC_FSTYPE() isn't aligned with anything.

Take a another look through the patch and you'll find a bunch of
similar issues.

regards,
dan carpenter

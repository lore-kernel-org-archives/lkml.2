Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab2KLMb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 07:31:29 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62971 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab2KLMb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 07:31:27 -0500
MIME-Version: 1.0
In-Reply-To: <1352709418-28996-2-git-send-email-joseph.gasparakis@intel.com>
References: <1352709418-28996-1-git-send-email-joseph.gasparakis@intel.com> <1352709418-28996-2-git-send-email-joseph.gasparakis@intel.com>
From: saeed bishara <saeed.bishara@gmail.com>
Date: Mon, 12 Nov 2012 14:31:05 +0200
Message-ID: <CAMAG_ecK1eUEcCD49DxSzCEqEHwd8qzJPvs3uK+FBW2MMwkV8w@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] net: Add support for hardware-offloaded encapsulation
To: Joseph Gasparakis <joseph.gasparakis@intel.com>
Cc: davem@davemloft.net, shemminger@vyatta.com, chrisw@sous-sol.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry@broadcom.com,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
> index 5ac3212..6dd59a5 100644
> --- a/include/linux/netdev_features.h
> +++ b/include/linux/netdev_features.h

>         NETIF_F_RXCSUM_BIT,             /* Receive checksumming offload */
> +       NETIF_F_RXCSUM_ENC_BIT,         /* Receive checksuming offload */
> +                                       /* for encapsulation */
in the future more features will be needed for tunneled packets (tso,
rxhash, etc..)
so I think it would make sense to add a new features variable for
tunneled packets, and the enum above will be used as is.
for example, if the driver supports checksum offloading for
encapsulated packets, then it will set the RXCSUM_BIT in that
variable:
netdev->encap_hw_features = NETIF_F_RXCSUM_BIT;
saeed

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008Ab0I0Ljh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 07:39:37 -0400
Received: from mx2.netapp.com ([216.240.18.37]:42877 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757703Ab0I0Ljg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 07:39:36 -0400
X-IronPort-AV: E=Sophos;i="4.57,243,1283756400"; 
   d="scan'208";a="458717408"
Subject: Re: [PATCH] sunrpc: prompt for RPCSEC_GSS_KRB5 even if NFS_V4 is
 enabled
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
        Neil Brown <neilb@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <1285584120-16860-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20100909181454.GB14915@pengutronix.de>
	 <1285584120-16860-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Mon, 27 Sep 2010 07:39:32 -0400
Message-ID: <1285587572.19362.2.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
X-OriginalArrivalTime: 27 Sep 2010 11:39:35.0301 (UTC) FILETIME=[A8C76350:01CB5E38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 12:41 +0200, Uwe Kleine-König wrote:
> NFS_V4 works fine without RPCSEC_GSS_KRB5 (even without CRYPTO).
> This dependency was introduced in
> 
> 	df486a2 (NFS: Fix the selection of security flavours in Kconfig)
> 
> to fix a build failure as RPCSEC_GSS_KRB5 was thought to be needed for
> NFS_V4.  The fix didn't work completely as NFS_V4 didn't enforce CRYPTO
> and so the select on RPCSEC_GSS_KRB5 didn't work in all situations (e.g.
> arm/mx1_defconfig).
> 
> This was rectified by
> 
> 	827e345 (SUNRPC: Fix the NFSv4 and RPCSEC_GSS Kconfig dependencies)
> 
> but the magic for RPCSEC_GSS_KRB5 introduced by df486a2 wasn't reverted.
> 
> Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> after Trond sent me the patch that later ended in 827e345702 I suggested
> to fold the patch below into it[1], but without reaction and success as I
> noticed just now. :-(
> 
> Best regards
> Uwe

That's because you completely fail to justify why should we change the
behaviour to suddenly make RPCSEC_GSS_KRB5 optional for NFSv4. That has
never been the case before.

Trond

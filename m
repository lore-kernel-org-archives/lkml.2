Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab2LUDKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 22:10:00 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:53515 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab2LUDJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 22:09:50 -0500
Message-ID: <1356059385.7055.11.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 4/5] net: sfc: fix return value check in
 efx_ptp_probe_channel().
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Miller <davem@davemloft.net>, <tipecaml@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        <linux-net-drivers@solarflare.com>, <netdev@vger.kernel.org>
Date: Fri, 21 Dec 2012 03:09:45 +0000
In-Reply-To: <20121212.001550.741463250196231082.davem@davemloft.net>
References: <1355271894-5284-1-git-send-email-tipecaml@gmail.com>
	 <1355271894-5284-5-git-send-email-tipecaml@gmail.com>
	 <20121212.001550.741463250196231082.davem@davemloft.net>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [88.96.1.126]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-12 at 00:15 -0500, David Miller wrote:
> From: Cyril Roelandt <tipecaml@gmail.com>
> Date: Wed, 12 Dec 2012 01:24:53 +0100
> 
> > The ptp_clock_register() returns ERR_PTR() and never returns NULL. Replace the
> > NULL check by a call to IS_ERR().
> > 
> > Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
> 
> I'll let Ben queue this up.
> 
> Probably he'll want to avoid potentially leaving an ERR_PTR
> in ptp->phc_clock even if, with this fix, that would be
> harmless.

Sorry for the delay in looking at this.  This change is fine, as the
entire structure *ptp will be freed on the failure path.

I'm now on vacation until the new year.  Cyril, please re-send your
patch with the addition of:

Acked-by: Ben Hutchings <bhutchings@solarflare.com>

so it will show up on 'patchwork' again and David can apply it from
there.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


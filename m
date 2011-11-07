Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab1KGT1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 14:27:38 -0500
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:36165 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186Ab1KGT1h convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 14:27:37 -0500
From: Bing Zhao <bzhao@marvell.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Jesper Juhl <jj@chaosbits.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 7 Nov 2011 11:27:25 -0800
Subject: RE: [PATCH] net, wireless, mwifiex: Fix mem leak in
 mwifiex_update_curr_bss_params()
Thread-Topic: [PATCH] net, wireless, mwifiex: Fix mem leak in
 mwifiex_update_curr_bss_params()
Thread-Index: Acyc0uimuDu02nrATDaoZ0SPCsylAwAr+CCQ
Message-ID: <477F20668A386D41ADCC57781B1F7043081814452B@SC-VEXCH1.marvell.com>
References: <alpine.LNX.2.00.1111062255310.5763@swampdragon.chaosbits.net>
 <4EB70920.80905@linux.vnet.ibm.com>
In-Reply-To: <4EB70920.80905@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 11/07/2011 03:28 AM, Jesper Juhl wrote:
> > If kmemdup() fails we leak the memory allocated to bss_desc.
> > This patch fixes the leak.
> > I also removed the pointless default assignment of 'NULL' to 'bss_desc'
> > while I was there anyway.
> >
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Hi Jesper,

Thanks for the patch.

> 
> Looks good to me.
> Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Hi Srivatsa,

Thanks for your review.

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> 
> Thanks,
> Srivatsa S. Bhat
> 
> > ---
> >  drivers/net/wireless/mwifiex/scan.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> >
> >  note: patch is compile tested only since I don't have the hardware.
> >
> > diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
> > index dae8dbb..8a3f959 100644
> > --- a/drivers/net/wireless/mwifiex/scan.c
> > +++ b/drivers/net/wireless/mwifiex/scan.c
> > @@ -1469,7 +1469,7 @@ mwifiex_update_curr_bss_params(struct mwifiex_private *priv, u8 *bssid,
> >  			       s32 rssi, const u8 *ie_buf, size_t ie_len,
> >  			       u16 beacon_period, u16 cap_info_bitmap, u8 band)
> >  {
> > -	struct mwifiex_bssdescriptor *bss_desc = NULL;
> > +	struct mwifiex_bssdescriptor *bss_desc;
> >  	int ret;
> >  	unsigned long flags;
> >  	u8 *beacon_ie;
> > @@ -1484,6 +1484,7 @@ mwifiex_update_curr_bss_params(struct mwifiex_private *priv, u8 *bssid,
> >
> >  	beacon_ie = kmemdup(ie_buf, ie_len, GFP_KERNEL);
> >  	if (!beacon_ie) {
> > +		kfree(bss_desc);
> >  		dev_err(priv->adapter->dev, " failed to alloc beacon_ie\n");
> >  		return -ENOMEM;
> >  	}

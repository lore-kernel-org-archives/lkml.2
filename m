Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab2FZUZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 16:25:27 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45926 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab2FZUZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 16:25:24 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6754"; a="204888572"
X-IronPort-AV: E=Sophos;i="4.77,478,1336374000"; 
   d="scan'208";a="278427159"
From: "Huang, Xiong" <xiong@qca.qualcomm.com>
To: Ben Hutchings <bhutchings@solarflare.com>,
        "Ren, Cloud" <cjren@qca.qualcomm.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>
Subject: RE: [PATCH 1/1] atl1c: fix issue of transmit queue 0 timed out
Thread-Topic: [PATCH 1/1] atl1c: fix issue of transmit queue 0 timed out
Thread-Index: AQHNU23awMaUWTNR4USicRkgHiyKw5cNgacA//+K4RA=
Date: Tue, 26 Jun 2012 20:25:21 +0000
Message-ID: <157393863283F442885425D2C454285623DB4982@NASANEXD02A.na.qualcomm.com>
References: <1340724786-3819-1-git-send-email-cjren@qca.qualcomm.com>
 <1340742224.2644.1.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1340742224.2644.1.camel@bwh-desktop.uk.solarflarecom.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.106.115.219]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5QKPclQ007505

Yes, another fix to remove netif_stop_queue when cable link is down.

-Xiong

> -----Original Message-----
> From: Ben Hutchings [mailto:bhutchings@solarflare.com]
> Sent: Wednesday, June 27, 2012 4:24
> To: Ren, Cloud
> Cc: davem@davemloft.net; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; qca-linux-team; nic-devel; Huang, Xiong
> Subject: Re: [PATCH 1/1] atl1c: fix issue of transmit queue 0 timed out
> 
> On Tue, 2012-06-26 at 12:33 -0300, Ren, Cloud wrote:
> > From: xiong <xiong@qca.qualcomm.com>
> >
> > some people report atl1c could cause system hang with following kernel
> > trace info:
> > ---------------------------------------
> > WARNING: at.../net/sched/sch_generic.c:258
> > dev_watchdog+0x1db/0x1d0()
> > ...
> > NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out ...
> > ---------------------------------------
> > This is caused by netif_stop_queue calling when cable Link is down but
> > netif_wake_queue isn't called when cable Link is resume.
> >
> > Signed-off-by: xiong <xiong@qca.qualcomm.com>
> > Signed-off-by: Cloud Ren <cjren@qca.qualcomm.com>
> > ---
> >  drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> > b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> > index 85717cb..c2736c4 100644
> > --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> > +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> > @@ -351,6 +351,8 @@ static void atl1c_common_task(struct work_struct
> *work)
> >  		atl1c_irq_disable(adapter);
> >  		atl1c_check_link_status(adapter);
> >  		atl1c_irq_enable(adapter);
> > +		if (netif_queue_stopped(netdev) && netif_carrier_ok(netdev))
> > +			netif_wake_queue(netdev);
> >  	}
> >  }
> >
> 
> Why explicitly stop/start the queue when the link changes?  That's what
> link_watch is for.
> 
> Ben.
> 
> --
> Ben Hutchings, Staff Engineer, Solarflare Not speaking for my employer; that's
> the marketing department's job.
> They asked us to note that Solarflare product names are trademarked.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

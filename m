Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab1IGViD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 17:38:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:46989 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757145Ab1IGViA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 17:38:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,347,1312182000"; 
   d="scan'208";a="14966884"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
        "magnus.damm@gmail.com" <magnus.damm@gmail.com>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "damm@opensource.se" <damm@opensource.se>
Date: Thu, 8 Sep 2011 03:07:53 +0530
Subject: Re: [PATCH] serial: sh-sci: don't filter on DMA device, use only
 channel ID
Thread-Topic: [PATCH] serial: sh-sci: don't filter on DMA device, use only
 channel ID
Thread-Index: AcxtpmadIXWI7yePQS6D3bJ+dcSVIQ==
Message-ID: <438BB0150E931F4B9CE701519A4463010871804A4F@bgsmsx502.gar.corp.intel.com>
References: <Pine.LNX.4.64.1106241354060.6014@axis700.grange>
 <1308916071.1536.4.camel@vkoul-udesk3> <20110829080047.GJ31809@linux-sh.org>
 <CANqRtoRn-Csu+Rns6dn6=cJmRqbZfLKXA9brs8Ug9rFvGRn78w@mail.gmail.com>
 <1314618931.1606.114.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1108300931220.19151@axis700.grange>
 <1314698522.1606.164.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1108301317280.19151@axis700.grange>
 <1314703426.1606.167.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1108301332190.19151@axis700.grange>
 <Pine.LNX.4.64.1109051002400.1112@axis700.grange>
 <1315228408.26251.75.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1109051532220.1112@axis700.grange>
 <1315233788.26251.163.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1109051700030.1112@axis700.grange>
 <1315235335.26251.194.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1109051716530.1112@axis700.grange>
 <438BB0150E931F4B9CE701519A4463010871804A4B@bgsmsx502.gar.corp.intel.com>
 <alpine.DEB.2.00.1109072048310.30407@axis700.grange>
In-Reply-To: <alpine.DEB.2.00.1109072048310.30407@axis700.grange>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p87LcGPh022733

On Wed, 2011-09-07 at 22:01 +0200, Guennadi Liakhovetski wrote:
> On Thu, 8 Sep 2011, Koul, Vinod wrote:
> You're seriously suggesting to export and use an additional shdma private 
> function, bypassing the dmaengine API?... That really doesn't sound like a 
> good idea to me, sorry. How about using .device_control(DMA_SLAVE_CONFIG) 
> from the filter function directly to verify channel suitability?
Yes see stedma40, coh90138 drivers
.device_control is not right place as channel is already allocated.

You are basically moving filter fn from all clients to dmac driver.

> 
> > I cant agree to the whole point of filtering in alloc
> > 
> > One channel is allocated, we should _not_ do any further filtering
> 
> Sorry, I do not understand this argumentation. Filtering and resource 
> allocation are parts of the channel-acquisition process, either of them 
> can fail, in which case the channel remains free for future requests.
DMA drivers set caps for each channel
Client requests a channel and dmaengine matches channel based on caps
and filer function is called so that additional filtering can take
place.
And .alloc_chan_resources is supposed to allocate the channel resource
and not do anything else.

--
~Vinod

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

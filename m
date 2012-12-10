Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab2LJT7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:59:14 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:2396 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab2LJT7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:59:13 -0500
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
From: "Dmitry Kravkov" <dmitry@broadcom.com>
To: "saeed bishara" <saeed.bishara@gmail.com>,
        "Joseph Gasparakis" <joseph.gasparakis@intel.com>
cc: "davem@davemloft.net" <davem@davemloft.net>,
        "shemminger@vyatta.com" <shemminger@vyatta.com>,
        "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
        "gospo@redhat.com" <gospo@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bhutchings@solarflare.com" <bhutchings@solarflare.com>,
        "Peter P Waskiewicz Jr" <peter.p.waskiewicz.jr@intel.com>,
        "Alexander Duyck" <alexander.h.duyck@intel.com>
Subject: RE: [PATCH v4 1/5] net: Add support for hardware-offloaded
 encapsulation
Thread-Topic: [PATCH v4 1/5] net: Add support for hardware-offloaded
 encapsulation
Thread-Index: AQHN1NfTCZueHEShBk21EtD9NcW/L5gSV9iAgAAfTrA=
Date: Mon, 10 Dec 2012 19:58:34 +0000
Message-ID: <504C9EFCA2D0054393414C9CB605C37F1BFC3555@SJEXCHMB06.corp.ad.broadcom.com>
References: <1354925658-24115-1-git-send-email-joseph.gasparakis@intel.com>
 <1354925658-24115-2-git-send-email-joseph.gasparakis@intel.com>
 <CAMAG_ee6xW4EnzPFt=_5+NL2+LuyUjxd52Xc242inYm2+Yhg7g@mail.gmail.com>
In-Reply-To: <CAMAG_ee6xW4EnzPFt=_5+NL2+LuyUjxd52Xc242inYm2+Yhg7g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
MIME-Version: 1.0
X-WSS-ID: 7CD8E1D13R017720185-01-01
Content-Type: text/plain;
 charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBAJxLqE007694

> -----Original Message-----
> From: saeed bishara [mailto:saeed.bishara@gmail.com]
> Sent: Monday, December 10, 2012 12:04 PM
> To: Joseph Gasparakis
> Cc: davem@davemloft.net; shemminger@vyatta.com; chrisw@sous-sol.org;
> gospo@redhat.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> Dmitry Kravkov; bhutchings@solarflare.com; Peter P Waskiewicz Jr; Alexander
> Duyck
> Subject: Re: [PATCH v4 1/5] net: Add support for hardware-offloaded
> encapsulation
> 
> > +static inline struct iphdr *inner_ip_hdr(const struct sk_buff *skb)
> > +{
> > +       return (struct iphdr *)skb_inner_network_header(skb);
> > +}
> 
> Hi,
> I'm a little bit bothered because of those inner_ functions, what
> about the following approach:
> 1. the skb will have a new state, that state can be outer (normal
> mode) and inner.
> 2. when you change the state to inner, all the helper functions such
> as ip_hdr will return the innter header.
> 
> that's ofcourse the API side. the implementation may still use the
> fields you added to the skb.
> 
> what you think?
> saeed

Some drivers will probably need both inner_ and other_ in same flow, switching between two states will consume cpu cycles. 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

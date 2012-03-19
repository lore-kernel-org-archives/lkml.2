Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302Ab2CSTRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:17:38 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:31224
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758583Ab2CSTRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:17:36 -0400
X-SpamScore: -19
X-BigFish: VS-19(zz9371I936eK542M1432N98dK4015Izz1202hzz8275dhz2fh2a8h668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC107.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Stephen Hemminger <shemminger@vyatta.com>,
        KY Srinivasan <kys@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH 1/1] net/hyperv: Fix the code handling tx busy
Thread-Topic: [PATCH 1/1] net/hyperv: Fix the code handling tx busy
Thread-Index: AQHNBfEpJGzSBBPeR0eW4jFoAPxN+ZZx2uYAgAAKSYCAAABBkIAAC4gAgAAAqWA=
Date: Mon, 19 Mar 2012 19:17:27 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC0DCEA930@TK5EX14MBXC223.redmond.corp.microsoft.com>
References: <1332176549-30960-1-git-send-email-haiyangz@microsoft.com>
	 <1332176549-30960-2-git-send-email-haiyangz@microsoft.com>
	 <1332177118.9397.32.camel@edumazet-glaptop>
	 <20120319104847.3a4c5fc0@nehalam.linuxnetplumber.net>
	 <A1F3067C9B68744AA19F6802BAB8FFDC0DCEA873@TK5EX14MBXC223.redmond.corp.microsoft.com>
 <1332181858.9397.49.camel@edumazet-glaptop>
In-Reply-To: <1332181858.9397.49.camel@edumazet-glaptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.37]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2JJHiWS029441



> -----Original Message-----
> From: Eric Dumazet [mailto:eric.dumazet@gmail.com]
> Sent: Monday, March 19, 2012 2:31 PM
> To: Haiyang Zhang
> Cc: Stephen Hemminger; KY Srinivasan; davem@davemloft.net;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org
> Subject: RE: [PATCH 1/1] net/hyperv: Fix the code handling tx busy
> 
> On Mon, 2012-03-19 at 17:50 +0000, Haiyang Zhang wrote:
> 
> > As in my previous reply to Eric --
> > We actually stop queue when the ring buffer is busy, see the code in
> > netvsc.c
> >
> > I have tested with one CPU. After NETDEV_TX_BUSY is returned, the
> > Linux guest OS continues to respond without any problem.
> 
> Then something is wrong somewhere.
> 
> Dont hide a bug adding a trick.
> 
> If you ever return NETDEV_TX_BUSY from start_xmit(), then you MUST call
> netif_tx_stop_queue() as well right before.

Yes, we called the stop_queue before returning NETDEV_TX_BUSY.

The stop_queue was called in the function netvsc_send() in file netvsc.c, then it returns to rndis_filter_send(), which returns to netvsc_start_xmit() in file netvsc_drv.c. So the NETDEV_TX_BUSY is indeed returned AFTER queue is stopped.

Thanks,
- Haiyang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

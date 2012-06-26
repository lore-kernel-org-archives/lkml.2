Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab2FZUlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 16:41:14 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9470 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab2FZUlN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 16:41:13 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6754"; a="204895747"
X-IronPort-AV: E=Sophos;i="4.77,478,1336374000"; 
   d="scan'208";a="335002065"
From: "Huang, Xiong" <xiong@qca.qualcomm.com>
To: "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
        "Ren, Cloud" <cjren@qca.qualcomm.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>
Subject: RE: [PATCH 1/1] atl1c: fix issue of transmit queue 0 timed out
Thread-Topic: [PATCH 1/1] atl1c: fix issue of transmit queue 0 timed out
Thread-Index: AQHNU23awMaUWTNR4USicRkgHiyKw5cNWmKA//+1KZA=
Date: Tue, 26 Jun 2012 20:41:11 +0000
Message-ID: <157393863283F442885425D2C454285623DB49B7@NASANEXD02A.na.qualcomm.com>
References: <1340724786-3819-1-git-send-email-cjren@qca.qualcomm.com>
 <20120626180311.GC5070@tux>
In-Reply-To: <20120626180311.GC5070@tux>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.106.115.219]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis
   It should be a stable fix, but as Ben Hutchings mentioned in another mail, 
Maybe, removing netif_stop_queue when cable link down is a better choice.

   Do you mean we need add 'cc:stable@vger.kernel.org'  just before 'some people report  ...' ?

Thanks
Xiong

> -----Original Message-----
> From: Rodriguez, Luis
> Sent: Wednesday, June 27, 2012 2:03
> To: Ren, Cloud
> Cc: davem@davemloft.net; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; qca-linux-team; nic-devel; Huang, Xiong
> Subject: Re: [PATCH 1/1] atl1c: fix issue of transmit queue 0 timed out
> 
> On Tue, Jun 26, 2012 at 12:33:06PM -0300, Ren, Cloud wrote:
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
> 
> If this fixes  a system hang then this could be a stable fix -- that is, this should
> be propagated to older stable kernels, no?
> 
> If so then please add to the commit log a line like this:
> 
> Cc: stable@vger.kernel.org [3.4]
> 
> Note: this is for the commit log! Right above the line below that has "---"
> 
>   Luis

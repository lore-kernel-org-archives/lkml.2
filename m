Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab2FZUz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 16:55:59 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19868 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2FZUz5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 16:55:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6754"; a="204900921"
X-IronPort-AV: E=Sophos;i="4.77,480,1336374000"; 
   d="scan'208";a="335007912"
From: "Huang, Xiong" <xiong@qca.qualcomm.com>
To: "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
CC: "Ren, Cloud" <cjren@qca.qualcomm.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>
Subject: RE: [PATCH 1/1] atl1c: fix issue of transmit queue 0 timed out
Thread-Topic: [PATCH 1/1] atl1c: fix issue of transmit queue 0 timed out
Thread-Index: AQHNU23awMaUWTNR4USicRkgHiyKw5cNWmKA//+1KZCAAHq8AP//ivnA
Date: Tue, 26 Jun 2012 20:55:56 +0000
Message-ID: <157393863283F442885425D2C454285623DB49DE@NASANEXD02A.na.qualcomm.com>
References: <1340724786-3819-1-git-send-email-cjren@qca.qualcomm.com>
 <20120626180311.GC5070@tux>
 <157393863283F442885425D2C454285623DB49B7@NASANEXD02A.na.qualcomm.com>
 <20120626205436.GJ5070@tux>
In-Reply-To: <20120626205436.GJ5070@tux>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.106.115.219]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Understand, thank you !

> -----Original Message-----
> From: Rodriguez, Luis
> Sent: Wednesday, June 27, 2012 4:55
> To: Huang, Xiong
> Cc: Ren, Cloud; davem@davemloft.net; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; qca-linux-team; nic-devel
> Subject: Re: [PATCH 1/1] atl1c: fix issue of transmit queue 0 timed out
> 
> On Tue, Jun 26, 2012 at 01:41:11PM -0700, Huang, Xiong wrote:
> > Luis
> >    It should be a stable fix, but as Ben Hutchings mentioned in
> > another mail, Maybe, removing netif_stop_queue when cable link down is a
> better choice.
> >
> >    Do you mean we need add 'cc:stable@vger.kernel.org'  just before 'some
> people report  ...' ?
> 
> Nope, see commit 4f7a67e2dd49fbfba002c453bc24bf00e701cc71
> as an example of how to do this. This is a random commit that has been
> marked as stable.
> 
> commit 4f7a67e2dd49fbfba002c453bc24bf00e701cc71
> Author: Ricardo Martins <rasm@fe.up.pt>
> Date:   Tue May 22 18:02:03 2012 +0100
> 
>     USB: fix PS3 EHCI systems
> 
>     After commit aaa0ef289afe9186f81e2340114ea413eef0492a "PS3 EHCI
> QH
>     read work-around", Terratec Grabby (em28xx) stopped working with AMD
>     Geode LX 800 (USB controller AMD CS5536). Since this is a PS3 only
>     fix, the following patch adds a conditional block around it.
> 
>     Signed-off-by: Ricardo Martins <rasm@fe.up.pt>
>     Acked-by: Alan Stern <stern@rowland.harvard.edu>
>     Cc: stable <stable@vger.kernel.org>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Sometimes it helps if you specify the oldest stable kernel to apply patches to,
> so for example:
> 
> commit 80b08a8d8829a58b5db14b1417151094cc28face
> Author: Felix Fietkau <nbd@openwrt.org>
> Date:   Fri Jun 15 03:04:53 2012 +0200
> 
>     ath9k: fix invalid pointer access in the tx path
> 
>     After setup_frame_info has been called, only info->control.rates is still
>     valid, other control fields have been overwritten by the ath_frame_info
>     data. Move the access to info->control.vif for checking short preamble
>     to setup_frame_info before it gets overwritten.
> 
>     This regression was introduced in commit d47a61aa
>     "ath9k: Fix multi-VIF BSS handling"
> 
>     Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>     Reported-by: Thomas Hühn <thomas@net.t-labs.tu-berlin.de>
>     Acked-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>     Cc: stable@vger.kernel.org [3.4]
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> To be clear, this is not a Cc: in the e-mail but instead a Cc line in the commit
> log entry.
> 
>   Luis

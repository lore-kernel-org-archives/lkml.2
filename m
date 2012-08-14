Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab2HNMgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 08:36:15 -0400
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:24954 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab2HNMgN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 08:36:13 -0400
From: <Sathya.Perla@Emulex.Com>
To: <shchepetkov@ispras.ru>, <yevgenyp@mellanox.co.il>
CC: <davem@davemloft.net>, <amirv@mellanox.com>, <ogerlitz@mellanox.com>,
        <alexg@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ldv-project@ispras.ru>
Subject: RE: [PATCH 3/5] net/mlx4_en: Call netif_carrier_off() after
 register_netdev()
Thread-Topic: [PATCH 3/5] net/mlx4_en: Call netif_carrier_off() after
 register_netdev()
Thread-Index: AQHNegfYrwaJEAtF5EmS57T9A8F4rpdZO+pA
Date: Tue, 14 Aug 2012 12:36:12 +0000
Message-ID: <CF9D1877D81D214CB0CA0669EFAE020C066A09@CMEXMB1.ad.emulex.com>
References: <1344940135-17079-1-git-send-email-shchepetkov@ispras.ru>
 <1344940135-17079-4-git-send-email-shchepetkov@ispras.ru>
In-Reply-To: <1344940135-17079-4-git-send-email-shchepetkov@ispras.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [138.239.142.128]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org] On
>Behalf Of Ilya Shchepetkov
>
>For carrier detection to work properly when binding the driver with a
>cable unplugged, netif_carrier_off() should be called after
>register_netdev(), not before.
>
>Calling netif_carrier_off() before register_netdev() was causing the
>network interface to miss a linkwatch pending event leading to an
>inconsistent state if the link is not up when interface is initialized.

ndo_open() may be called as soon register_netdev() completes...
When netif_carrier_off() is called *after* register_netdev(), isn't there
a possibility of a ndo_open()->netif_carrier_on() call racing this call, causing
incorrect results?

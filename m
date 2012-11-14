Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422772Ab2KNMcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 07:32:52 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:3257 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422701Ab2KNMcu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 07:32:50 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Dmitry Kravkov" <dmitry@broadcom.com>
To: "Joseph Gasparakis" <joseph.gasparakis@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "shemminger@vyatta.com" <shemminger@vyatta.com>,
        "chrisw@sous-sol.org" <chrisw@sous-sol.org>
cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Peter P Waskiewicz Jr" <peter.p.waskiewicz.jr@intel.com>
Subject: RE: [PATCH v2 3/3] ipgre: capture inner headers during
 encapsulation
Thread-Topic: [PATCH v2 3/3] ipgre: capture inner headers during
 encapsulation
Thread-Index: AQHNwIFfjS07kFqZdUGeKYYT2Lp9RZfpRtsQ
Date: Wed, 14 Nov 2012 12:32:39 +0000
Message-ID: <504C9EFCA2D0054393414C9CB605C37F1BF5CF1C@SJEXCHMB06.corp.ad.broadcom.com>
References: <1352689450-4092-1-git-send-email-joseph.gasparakis@intel.com>
In-Reply-To: <1352689450-4092-1-git-send-email-joseph.gasparakis@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
MIME-Version: 1.0
X-WSS-ID: 7CBD51711QK2429103-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
> On Behalf Of Joseph Gasparakis
> Sent: Monday, November 12, 2012 5:04 AM
> To: davem@davemloft.net; shemminger@vyatta.com; chrisw@sous-sol.org
> Cc: Joseph Gasparakis; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> Peter P Waskiewicz Jr
> Subject: [PATCH v2 3/3] ipgre: capture inner headers during encapsulation
> 
> Populating the inner header pointers of skb for ipgre
> This patch has been compile-tested only.
> 
> v2 Makes sure that checksumming does not take place if the offload flag is set in
> the skb's netdev features
> 
> Signed-off-by: Joseph Gasparakis <joseph.gasparakis@intel.com>
> Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
> ---
>  net/ipv4/ip_gre.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> index 7240f8e..e35ed52 100644
> --- a/net/ipv4/ip_gre.c
> +++ b/net/ipv4/ip_gre.c
> @@ -766,8 +766,10 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff
> *skb, struct net_device *dev
>  	int    gre_hlen;
>  	__be32 dst;
>  	int    mtu;
> +	unsigned int offset;
> 
> -	if (skb->ip_summed == CHECKSUM_PARTIAL &&
> +	if (!(skb->dev->features & NETIF_F_HW_CSUM_ENC_BIT) &&

 You should test for NETIF_F_HW_CSUM_ENC and not for NETIF_F_HW_CSUM_ENC_BIT


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0KEL7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 07:59:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:33684 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab0KEL7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 07:59:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,301,1286175600"; 
   d="scan'208";a="623842913"
From: "Rose, Gregory V" <gregory.v.rose@intel.com>
To: Joe Perches <joe@perches.com>, Jiri Kosina <trivial@kernel.org>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Wyborny, Carolyn" <carolyn.wyborny@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 5 Nov 2010 04:59:22 -0700
Subject: RE: [PATCH 26/49] drivers/net/ixgbevf: Use vzalloc
Thread-Topic: [PATCH 26/49] drivers/net/ixgbevf: Use vzalloc
Thread-Index: Act8lsj0vZseiMnVTdq6++br38O0RwASg0cQ
Message-ID: <43F901BD926A4E43B106BF17856F07550124A9DFFF@orsmsx508.amr.corp.intel.com>
References: <cover.1288925424.git.joe@perches.com>
 <79b773f5012cba15686c4048d48cbbef6a13b049.1288925425.git.joe@perches.com>
In-Reply-To: <79b773f5012cba15686c4048d48cbbef6a13b049.1288925425.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Thursday, November 04, 2010 8:08 PM
> To: Jiri Kosina
> Cc: Kirsher, Jeffrey T; Brandeburg, Jesse; Allan, Bruce W; Wyborny,
> Carolyn; Skidmore, Donald C; Rose, Gregory V; Waskiewicz Jr, Peter P;
> Duyck, Alexander H; Ronciak, John; e1000-devel@lists.sourceforge.net;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 26/49] drivers/net/ixgbevf: Use vzalloc
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/ixgbevf/ixgbevf_main.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ixgbevf/ixgbevf_main.c
> b/drivers/net/ixgbevf/ixgbevf_main.c
> index dc03c96..6aeaf54 100644
> --- a/drivers/net/ixgbevf/ixgbevf_main.c
> +++ b/drivers/net/ixgbevf/ixgbevf_main.c
> @@ -2488,10 +2488,9 @@ int ixgbevf_setup_tx_resources(struct
> ixgbevf_adapter *adapter,
>  	int size;
> 
>  	size = sizeof(struct ixgbevf_tx_buffer) * tx_ring->count;
> -	tx_ring->tx_buffer_info = vmalloc(size);
> +	tx_ring->tx_buffer_info = vzalloc(size);
>  	if (!tx_ring->tx_buffer_info)
>  		goto err;
> -	memset(tx_ring->tx_buffer_info, 0, size);
> 
>  	/* round up to nearest 4K */
>  	tx_ring->size = tx_ring->count * sizeof(union ixgbe_adv_tx_desc);
> @@ -2555,14 +2554,13 @@ int ixgbevf_setup_rx_resources(struct
> ixgbevf_adapter *adapter,
>  	int size;
> 
>  	size = sizeof(struct ixgbevf_rx_buffer) * rx_ring->count;
> -	rx_ring->rx_buffer_info = vmalloc(size);
> +	rx_ring->rx_buffer_info = vzalloc(size);
>  	if (!rx_ring->rx_buffer_info) {
>  		hw_dbg(&adapter->hw,
>  		       "Unable to vmalloc buffer memory for "
>  		       "the receive descriptor ring\n");
>  		goto alloc_failed;
>  	}
> -	memset(rx_ring->rx_buffer_info, 0, size);
> 
>  	/* Round up to nearest 4K */
>  	rx_ring->size = rx_ring->count * sizeof(union ixgbe_adv_rx_desc);
> --
> 1.7.3.1.g432b3.dirty

Acked By: Greg Rose <Gregory.v.rose@intel.com>


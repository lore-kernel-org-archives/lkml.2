Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab1HKIF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 04:05:58 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42128 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab1HKIFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 04:05:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6434"; a="109541149"
X-IronPort-AV: E=Sophos;i="4.67,353,1309762800"; 
   d="scan'208";a="97766754"
Message-ID: <4E438D56.5020801@qca.qualcomm.com>
Date: Thu, 11 Aug 2011 11:05:42 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "John W. Linville" <linville@tuxdriver.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Raja Mani <rmani@qca.qualcomm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (wireless
 & staging trees related)
References: <20110811155529.e5f47afa0504c4ddef58ab37@canb.auug.org.au>
In-Reply-To: <20110811155529.e5f47afa0504c4ddef58ab37@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.234.11.46]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 08/11/2011 08:55 AM, Stephen Rothwell wrote:
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/staging/built-in.o: In function `aggr_recv_delba_req_evt':
> (.opd+0x23a60): multiple definition of `aggr_recv_delba_req_evt'
> drivers/net/built-in.o:(.opd+0x79980): first defined here
> drivers/staging/built-in.o: In function `.wlan_node_reclaim':
> (.text+0x303360): multiple definition of `.wlan_node_reclaim'
> drivers/net/built-in.o:(.text+0xdd0618): first defined here
> drivers/staging/built-in.o: In function `aggr_init':
> (.opd+0x23a00): multiple definition of `aggr_init'
> drivers/net/built-in.o:(.opd+0x79968): first defined here
> drivers/staging/built-in.o: In function `.aggr_recv_delba_req_evt':
> (.text+0x302614): multiple definition of `.aggr_recv_delba_req_evt'
> drivers/net/built-in.o:(.text+0xdc8b60): first defined here
> drivers/staging/built-in.o: In function `.wlan_node_table_cleanup':
> (.text+0x303888): multiple definition of `.wlan_node_table_cleanup'
> drivers/net/built-in.o:(.text+0xdd0a6c): first defined here
> 
> You get the idea. :-(  So, the ath6kl driver now exists in the wireless
> tree and the staging tree.
> 
> I applied this patch for today (I have elided the part from "rm -rf
> drivers/staging/ath6kl"):

Oh man, sorry about this (again). I did compile both drivers at the same
time, but only as modules and didn't realise the conflicts also with the
staging driver.

Yes, the cleaned up version of ath6kl is now in wireless-next and the
staging version can be removed in 3.2. Greg, how do you want to handle
removal of the staging version? Should I send a patch to you removing
it? Or should I send the patch to John?

Kalle

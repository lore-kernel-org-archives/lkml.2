Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab2JOSyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 14:54:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:34969 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab2JOSyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 14:54:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,590,1344236400"; 
   d="scan'208";a="156425973"
Message-ID: <507C5BC7.1060108@intel.com>
Date: Mon, 15 Oct 2012 11:53:59 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Dmitry Fleytman <dmitry@daynix.com>
CC: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        Chris Webb <chris.webb@elastichosts.com>,
        Richard Davies <richard.davies@elastichosts.com>
Subject: Re: [PATCH] e1000 driver RX race condition fixed
References: <1350235151-11146-1-git-send-email-dmitry@daynix.com>
In-Reply-To: <1350235151-11146-1-git-send-email-dmitry@daynix.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2012 10:19 AM, Dmitry Fleytman wrote:
> There is a race condition in e1000 driver.
> It enables HW receive before RX rings initalization.
> In case of specific timing this may lead to host memory corruption
> due to DMA write to arbitrary memory location.
> Following patch fixes this issue by reordering initialization steps.
>
> Other Intel network drivers does not seem to have this issue.
>
> Dmitry Fleytman (1):
>   RX initialization sequence fixed - enable RX after corresponding ring
>     initialization only
>
>  drivers/net/ethernet/intel/e1000/e1000_ethtool.c |    9 +++++----
>  drivers/net/ethernet/intel/e1000/e1000_main.c    |   18 ++++++++++++++++--
>  2 files changed, 21 insertions(+), 6 deletions(-)
>

What device was it you saw this issue with?  The reason why I ask is
because I suspect this change should cause most of our e1000 hardware to
lock up since normally if you allocate buffers and then enable Rx it
will mean the ring was not updated and it will treat it as if there are
no buffers available.

Thanks,

Alex


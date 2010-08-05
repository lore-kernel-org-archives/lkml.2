Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417Ab0HEQsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 12:48:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:62323 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab0HEQsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 12:48:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,323,1278313200"; 
   d="scan'208";a="593293477"
Message-ID: <4C5AEB41.9050903@intel.com>
Date: Thu, 05 Aug 2010 09:48:01 -0700
From: John Fastabend <john.r.fastabend@intel.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: divya <dipraksh@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        netdev <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Subject: Re: [linux-next] build failure
References: <4C5A4CF4.4070203@linux.vnet.ibm.com>
In-Reply-To: <4C5A4CF4.4070203@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

divya wrote:
> Yestersday's linux-next(2.6.35_next_20100802) build fails with the following error on both system p and x.
> 
> 
>    drivers/net/ixgbe/ixgbe_main.c: In function 'ixgbe_select_queue':
>    drivers/net/ixgbe/ixgbe_main.c:6159: error: 'struct ixgbe_fcoe' has no member named 'up'
>    drivers/net/ixgbe/ixgbe_main.c: In function 'ixgbe_xmit_frame':
>    drivers/net/ixgbe/ixgbe_main.c:6221: error: 'struct ixgbe_fcoe' has no member named 'up'
>    make[3]: *** [drivers/net/ixgbe/ixgbe_main.o] Error 1
>    make[2]: *** [drivers/net/ixgbe] Error 2
>    make[2]: *** Waiting for unfinished jobs....
>    make[1]: *** [drivers/net] Error 2
>    make: *** [drivers] Error 2
> 
> Thanks
> Divya
> 
> 

Hi Divya,

Jeff should have a fix for this in his queue already.  This is caused by 
building with CONFIG_FCOE and without CONFIG_IXGBE_DCB.

Thanks,
John.

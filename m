Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab0GNVHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 17:07:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44218
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757967Ab0GNVHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 17:07:02 -0400
Date: Wed, 14 Jul 2010 14:07:18 -0700 (PDT)
Message-Id: <20100714.140718.115934967.davem@davemloft.net>
To: sbhatewara@vmware.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com, ronghua@vmware.com, matthieu@vmware.com
Subject: Re: [PATCH 2.6.35-rc1] net-next: vmxnet3 fixes [4/5] Do not reset
 when the device is not opened
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.00.1007131749030.32055@localhost.localdomain>
References: <alpine.LRH.2.00.1007070202080.5939@localhost.localdomain>
	<alpine.LRH.2.00.1007070229030.5939@localhost.localdomain>
	<alpine.LRH.2.00.1007131749030.32055@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreyas Bhatewara <sbhatewara@vmware.com>
Date: Tue, 13 Jul 2010 17:49:52 -0700 (PDT)

> 
> Do not reset when the device is not opened
> 
> If a reset is scheduled, and the device goes thru close and open, it
> may happen that reset and open may run in parallel.
> The reset code now bails out if the device is not opened.
>  
> Signed-off-by: Ronghua Zang <ronghua@vmware.com>
> Signed-off-by: Matthieu Bucchianeri <matthieu@vmware.com>
> Signed-off-by: Shreyas Bhatewara <sbhatewara@vmware.com>

Testing IFF_UP is just making your race hole a little smaller but
it isn't fixing the problem.

In fact, there really isn't any legitimate reason for a driver
to test the IFF_UP state bit.  netif_running() is the correct
test, and asynchronous work queue things like resets should
synchronize with open/close using the RTNL lock so that your
test of netif_running() is a stable one.

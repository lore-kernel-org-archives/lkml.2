Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab0GNVKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 17:10:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53650
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751404Ab0GNVKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 17:10:39 -0400
Date: Wed, 14 Jul 2010 14:10:54 -0700 (PDT)
Message-Id: <20100714.141054.48510602.davem@davemloft.net>
To: sbhatewara@vmware.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH 2.6.35-rc1] net-next: vmxnet3 fixes [3/5] Initialize
 link state at probe time
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.00.1007131748180.32055@localhost.localdomain>
References: <alpine.LRH.2.00.1007070125440.4652@localhost.localdomain>
	<alpine.LRH.2.00.1007070202080.5939@localhost.localdomain>
	<alpine.LRH.2.00.1007131748180.32055@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreyas Bhatewara <sbhatewara@vmware.com>
Date: Tue, 13 Jul 2010 17:48:55 -0700 (PDT)

> 
> Initialize vmxnet3 link state at probe time
> 
> This change initializes the state of link at the time when driver is
> loaded. The ethtool output for 'link detected' and 'link speed'
> is thus valid even before the interface is brought up.
> 
> Signed-off-by: Shreyas Bhatewara <sbhatewara@vmware.com>

You should never, ever, call netif_start_queue() on a device which has
not been brought up.

But that is what this patch is doing.

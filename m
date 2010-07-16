Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935231Ab0GPBb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 21:31:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51972
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935168Ab0GPBbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 21:31:55 -0400
Date: Thu, 15 Jul 2010 18:32:10 -0700 (PDT)
Message-Id: <20100715.183210.226762655.davem@davemloft.net>
To: sbhatewara@vmware.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com, ronghua@vmware.com, matthieu@vmware.com
Subject: Re: [PATCH 2.6.35-rc1] net-next: vmxnet3 fixes [4/5] Do not reset
 when the device is not opened
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.00.1007151448260.25472@localhost.localdomain>
References: <alpine.LRH.2.00.1007131749030.32055@localhost.localdomain>
	<20100714.140718.115934967.davem@davemloft.net>
	<alpine.LRH.2.00.1007151448260.25472@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreyas Bhatewara <sbhatewara@vmware.com>
Date: Thu, 15 Jul 2010 18:20:52 -0700 (PDT)

> Is this what you suggest :
> 
> ---
> 
> Hold rtnl_lock to get the right link state.

It ought to work, but make sure that it is legal to take the
RTNL semaphore in all contexts in which this code block
might be called.

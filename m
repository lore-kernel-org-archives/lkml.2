Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab0GNVET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 17:04:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44213
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756624Ab0GNVES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 17:04:18 -0400
Date: Wed, 14 Jul 2010 14:04:33 -0700 (PDT)
Message-Id: <20100714.140433.59678649.davem@davemloft.net>
To: sbhatewara@vmware.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com, ronghua@vmware.com
Subject: Re: [PATCH 2.6.35-rc1] net-next: vmxnet3 fixes [2/5] Interrupt
 control bitmap
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.00.1007131746370.32055@localhost.localdomain>
References: <alpine.LRH.2.00.1007070125440.4652@localhost.localdomain>
	<alpine.LRH.2.00.1007070222110.6105@localhost.localdomain>
	<alpine.LRH.2.00.1007131746370.32055@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreyas Bhatewara <sbhatewara@vmware.com>
Date: Tue, 13 Jul 2010 17:48:04 -0700 (PDT)

> -	__le32		reserved[3];
> +	__le32		intrCtrl;
> +	__le32		reserved[2];
>  };
>  
 ...
> +	adapter->shared->devRead.intrConf.intrCtrl &= ~VMXNET3_IC_DISABLE_ALL;
 ...
> +	adapter->shared->devRead.intrConf.intrCtrl |= VMXNET3_IC_DISABLE_ALL;
 ...
> +	devRead->intrConf.intrCtrl |= VMXNET3_IC_DISABLE_ALL;

You need to use cpu_to_le32() and similar when accessing this value.

If you run "sparse" with endianness checking enabled you'll see
warnings showing alerting you to this issue...

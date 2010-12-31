Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab0LaAW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 19:22:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57370
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750892Ab0LaAW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 19:22:58 -0500
Date: Thu, 30 Dec 2010 16:23:28 -0800 (PST)
Message-Id: <20101230.162328.104050033.davem@davemloft.net>
To: jeffm@suse.com
Cc: akpm@linux-foundation.org, error27@gmail.com, balbir@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] taskstats: Use better ifdef for alignment
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D1BCE58.4000902@suse.com>
References: <4D1BCE58.4000902@suse.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Mahoney <jeffm@suse.com>
Date: Wed, 29 Dec 2010 19:12:08 -0500

>  Commit 4be2c95d added a null field to align the taskstats structure but
>  the discussion centered around ia64. The issue exists on other platforms
>  with inefficient unaligned access and adding them piecemeal would be
>  an unmaintainable mess.
> 
>  This patch uses Dave Miller's suggestion of using a combination of
>  CONFIG_64BIT && !CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS to determine
>  whether alignment is needed.
> 
>  Note that this will cause breakage on those platforms with applications
>  like iotop which had hard-coded offsets into the packet to access the
>  taskstats structure.
> 
>  The message seen on systems without the alignment fixes looks like:
>  kernel unaligned access to 0xe000023879dca9bc, ip=0xa000000100133d10
> 
>  The addresses may vary but resolve to locations inside __delayacct_add_tsk.
> 
> Reported-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Acked-by: David S. Miller <davem@davemloft.net>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab0ERBfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 21:35:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:29262 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756228Ab0ERBfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 21:35:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,251,1272870000"; 
   d="scan'208";a="278234442"
Subject: Re: [PATCH 26/37] drivers/net/wireless/ipw2x00: Use kmemdup
From: Zhu Yi <yi.zhu@intel.com>
To: Julia Lawall <julia@diku.dk>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1005152320450.21345@ask.diku.dk>
References: <Pine.LNX.4.64.1005152320450.21345@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 09:26:52 +0800
Message-ID: <1274146012.27831.2484.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-05-16 at 05:21 +0800, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Use kmemdup when some other buffer is immediately copied into the
> allocated region.
> 
> A simplified version of the semantic patch that makes this change is
> as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression from,to,size,flag;
> statement S;
> @@
> 
> -  to = \(kmalloc\|kzalloc\)(size,flag);
> +  to = kmemdup(from,size,flag);
>    if (to==NULL || ...) S
> -  memcpy(to, from, size);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk> 

Acked-by: Zhu Yi <yi.zhu@intel.com>

Thanks,
-yi


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab0FKGM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 02:12:26 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:39648 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab0FKGMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 02:12:25 -0400
Date: Fri, 11 Jun 2010 11:41:02 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] memcg remove css_get/put per pages v2
Message-ID: <20100611061102.GF5191@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100608121901.3cab9bdf.kamezawa.hiroyu@jp.fujitsu.com>
 <20100609155940.dd121130.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100609155940.dd121130.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-06-09 15:59:40]:

> +		if (consume_stock(mem)) {
> +			/*
> +			 * It seems dagerous to access memcg without css_get().
> +			 * But considering how consume_stok works, it's not
> +			 * necessary. If consume_stock success, some charges
> +			 * from this memcg are cached on this cpu. So, we
> +			 * don't need to call css_get()/css_tryget() before
> +			 * calling consume_stock().
> +			 */
> +			rcu_read_unlock();
> +			goto done;
> +		}
> +		if (!css_tryget(&mem->css)) {

If tryget fails, can one assume that this due to a race and the mem is
about to be freed?


-- 
	Three Cheers,
	Balbir

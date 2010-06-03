Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404Ab0FCLcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 07:32:42 -0400
Received: from rcpt-mqugw.biglobe.ne.jp ([133.205.19.69]:37102 "EHLO
	rcpt-mqugw.biglobe.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0FCLck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 07:32:40 -0400
X-Greylist: delayed 3232 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jun 2010 07:32:40 EDT
X-Biglobe-Sender: <d-nishimura@mtf.biglobe.ne.jp>
Date: Thu, 3 Jun 2010 19:38:09 +0900
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 1/2] memcg clean up try_charge main loop
Message-Id: <20100603193809.9d5f6314.d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <20100603152830.8b9e5e27.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100603114837.6e6d4d0f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100603150619.4bbe61bb.nishimura@mxp.nes.nec.co.jp>
	<20100603152830.8b9e5e27.kamezawa.hiroyu@jp.fujitsu.com>
Reply-To: nishimura@mxp.nes.nec.co.jp
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more comment.

> +	ret = res_counter_charge(&mem->res, csize, &fail_res);
> +
> +	if (likely(!ret)) {
> +		if (!do_swap_account)
> +			return CHARGE_OK;
> +		ret = res_counter_charge(&mem->memsw, csize, &fail_res);
> +		if (likely(!ret))
> +			return CHARGE_OK;
> +
> +		mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
This must be mem_cgroup_from_res_counter(fail_res, memsw).
We will access to an invalid pointer, otherwise.

> +		flags |= MEM_CGROUP_RECLAIM_NOSWAP;
> +	} else
> +		mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
> +

Thanks,
Daisuke Nishimura.

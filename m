Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab0FDAbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 20:31:03 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52316 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab0FDAbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 20:31:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Jun 2010 09:26:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: nishimura@mxp.nes.nec.co.jp
Cc: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] memcg clean up try_charge main loop
Message-Id: <20100604092641.e1e5a7c1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100603193809.9d5f6314.d-nishimura@mtf.biglobe.ne.jp>
References: <20100603114837.6e6d4d0f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100603150619.4bbe61bb.nishimura@mxp.nes.nec.co.jp>
	<20100603152830.8b9e5e27.kamezawa.hiroyu@jp.fujitsu.com>
	<20100603193809.9d5f6314.d-nishimura@mtf.biglobe.ne.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010 19:38:09 +0900
Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp> wrote:

> One more comment.
> 
> > +	ret = res_counter_charge(&mem->res, csize, &fail_res);
> > +
> > +	if (likely(!ret)) {
> > +		if (!do_swap_account)
> > +			return CHARGE_OK;
> > +		ret = res_counter_charge(&mem->memsw, csize, &fail_res);
> > +		if (likely(!ret))
> > +			return CHARGE_OK;
> > +
> > +		mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
> This must be mem_cgroup_from_res_counter(fail_res, memsw).
> We will access to an invalid pointer, otherwise.
> 
ouch..ok. (my test wasn't enough..)

I'll rewrite this against the new mmotm.

Thanks,
-Kame


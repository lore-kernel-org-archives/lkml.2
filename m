Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab0FKG0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 02:26:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38526 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab0FKG0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 02:26:10 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 11 Jun 2010 15:21:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] memcg remove css_get/put per pages v2
Message-Id: <20100611152144.e53d72b3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100611061102.GF5191@balbir.in.ibm.com>
References: <20100608121901.3cab9bdf.kamezawa.hiroyu@jp.fujitsu.com>
	<20100609155940.dd121130.kamezawa.hiroyu@jp.fujitsu.com>
	<20100611061102.GF5191@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 11:41:02 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-06-09 15:59:40]:
> 
> > +		if (consume_stock(mem)) {
> > +			/*
> > +			 * It seems dagerous to access memcg without css_get().
> > +			 * But considering how consume_stok works, it's not
> > +			 * necessary. If consume_stock success, some charges
> > +			 * from this memcg are cached on this cpu. So, we
> > +			 * don't need to call css_get()/css_tryget() before
> > +			 * calling consume_stock().
> > +			 */
> > +			rcu_read_unlock();
> > +			goto done;
> > +		}
> > +		if (!css_tryget(&mem->css)) {
> 
> If tryget fails, can one assume that this due to a race and the mem is
> about to be freed?
> 
Yes. it's due to a race and "mem" will be no longer used.
This does the same thing which try_get_mem_cgrou_from_mm() does now.

Thanks,
-Kame


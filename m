Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352Ab2I1S3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:29:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48458 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757616Ab2I1S3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:29:17 -0400
Date: Fri, 28 Sep 2012 11:26:35 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 17/57] power: ab8500_bm: Added support for BATT_OVV
Message-ID: <20120928182635.GA25930@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-18-git-send-email-mathieu.poirier@linaro.org>
 <20120927033604.GH8836@lizard>
 <5065EB75.8040101@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5065EB75.8040101@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 12:24:53PM -0600, Mathieu Poirier wrote:
[...]
> >>  		/* Not yet recovered from ovv, reschedule this test */
> >>  		queue_delayed_work(di->fg_wq, &di->fg_check_hw_failure_work,
> >> -				   round_jiffies(HZ));
> >> +			HZ);
> > 
> > Why this change? I.e. round_jiffies(HZ) -> HZ?
> > 
> > Yes, it seems like round_jiffies(HZ) is not needed since HZ itself is a
> > full second.. But the change itself does not belong to this patch.
> 
> I agree with your point of view.  How do we fix it now ?  Do you think
> it's worth crafting a one-line patch ?

Yup. Or you can leave the code as is: I guess round_jiffies() is not a big
deal since it's not in some kind of hot path, so generally this doesn't
affect behaviour. It's up to you, I'm fine either way.

Thanks!

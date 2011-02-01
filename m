Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab1BAAZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 19:25:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754297Ab1BAAZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 19:25:07 -0500
Date: Mon, 31 Jan 2011 16:24:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
        balbir@linux.vnet.ibm.com, minchan.kim@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] memcg: prevent endless loop when charging huge
 pages to near-limit group
Message-Id: <20110131162448.e791f0ae.akpm@linux-foundation.org>
In-Reply-To: <20110201000455.GB19534@cmpxchg.org>
References: <1296482635-13421-1-git-send-email-hannes@cmpxchg.org>
	<1296482635-13421-3-git-send-email-hannes@cmpxchg.org>
	<20110131144131.6733aa3a.akpm@linux-foundation.org>
	<20110201000455.GB19534@cmpxchg.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011 01:04:55 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> Maybe it would be better to use res_counter_margin(cnt) >= wanted
> throughout the code.

yup.

> --- a/include/linux/res_counter.h
> +++ b/include/linux/res_counter.h
> @@ -182,6 +182,14 @@ static inline bool res_counter_check_under_limit(struct res_counter *cnt)
>  	return ret;
>  }
>  
> +/**
> + * res_counter_check_margin - check if the counter allows charging
> + * @cnt: the resource counter to check
> + * @bytes: the number of bytes to check the remaining space against
> + *
> + * Returns a boolean value on whether the counter can be charged
> + * @bytes or whether this would exceed the limit.
> + */
>  static inline bool res_counter_check_margin(struct res_counter *cnt,
>  					    unsigned long bytes)
>  {

mem_cgroup_check_margin() needs some lipstick too.

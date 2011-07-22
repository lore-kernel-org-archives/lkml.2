Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab1GVA0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 20:26:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33632 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab1GVA0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 20:26:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 22 Jul 2011 09:18:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] memcg: prevent from reclaiming if there are per-cpu
 cached charges
Message-Id: <20110722091858.f4b78e14.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110722085652.759aded2.kamezawa.hiroyu@jp.fujitsu.com>
References: <cover.1311241300.git.mhocko@suse.cz>
	<0ed59a22cc84037d6e42b258981c75e3a6063899.1311241300.git.mhocko@suse.cz>
	<20110721195411.f4fa9f91.kamezawa.hiroyu@jp.fujitsu.com>
	<20110721123012.GD27855@tiehlicka.suse.cz>
	<20110722085652.759aded2.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jul 2011 08:56:52 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 21 Jul 2011 14:30:12 +0200
> Michal Hocko <mhocko@suse.cz> wrote:
 
> Please wait until "background reclaim" stuff. I don't stop it and it will
> make this cpu-caching stuff better because we can drain before hitting
> limit.
> 
> If you cannot wait....
> 
> One idea is to have a threshold to call async "drain". For example,
> 
>  threshould = limit_of_memory - nr_online_cpu() * (BATCH_SIZE + 1)
> 
>  if (usage > threshould)
> 	drain_all_stock_async().
> 
> Then, situation will be much better.
> 

Of course, frequency of this call can be controlled by event counter.

Thanks,
-Kame



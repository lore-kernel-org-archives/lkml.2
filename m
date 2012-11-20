Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab2KTHI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:08:58 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61384 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2KTHIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:08:55 -0500
Date: Mon, 19 Nov 2012 23:08:51 -0800
From: Tejun Heo <tj@kernel.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: daniel.wagner@bmw-carit.de, srivatsa.bhat@linux.vnet.ibm.com,
        john.r.fastabend@intel.com, nhorman@tuxdriver.com, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] cgroup: add cgroup->id
Message-ID: <20121120070851.GG25790@mtj.dyndns.org>
References: <1353093624-22608-1-git-send-email-tj@kernel.org>
 <1353093624-22608-2-git-send-email-tj@kernel.org>
 <50AB086E.70901@jp.fujitsu.com>
 <20121120053112.GE25790@mtj.dyndns.org>
 <50AB2BCF.2050204@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50AB2BCF.2050204@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kamezawa.

On Tue, Nov 20, 2012 at 04:05:51PM +0900, Kamezawa Hiroyuki wrote:
> BTW, css's ID was limited to 65535 to be encoded in 2bytes.
> If we use INT, this will increase size of swap_cgroup.
> (2bytes per page => 4bytes per page) It's preallocated at swapon()
> because allocating memory dynamically when we swap a memory is not good.
> 
> Do we really need 4bytes for ID ? If so, swap_cgroup should be totally re-designed.

That's a memcg restriction which shouldn't have been imposed on cgroup
core from the beginning.  What memcg should do is rejecting to become
online from ->css_onilne() if cgrp->id is out of the range it can
handle.

Thanks.

-- 
tejun

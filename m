Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab2KTHMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:12:08 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45617 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab2KTHMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:12:06 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50AB2D2A.1040604@jp.fujitsu.com>
Date: Tue, 20 Nov 2012 16:11:38 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: daniel.wagner@bmw-carit.de, srivatsa.bhat@linux.vnet.ibm.com,
        john.r.fastabend@intel.com, nhorman@tuxdriver.com, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] cgroup: add cgroup->id
References: <1353093624-22608-1-git-send-email-tj@kernel.org> <1353093624-22608-2-git-send-email-tj@kernel.org> <50AB086E.70901@jp.fujitsu.com> <20121120053112.GE25790@mtj.dyndns.org> <50AB2BCF.2050204@jp.fujitsu.com> <20121120070851.GG25790@mtj.dyndns.org>
In-Reply-To: <20121120070851.GG25790@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/20 16:08), Tejun Heo wrote:
> Hello, Kamezawa.
>
> On Tue, Nov 20, 2012 at 04:05:51PM +0900, Kamezawa Hiroyuki wrote:
>> BTW, css's ID was limited to 65535 to be encoded in 2bytes.
>> If we use INT, this will increase size of swap_cgroup.
>> (2bytes per page => 4bytes per page) It's preallocated at swapon()
>> because allocating memory dynamically when we swap a memory is not good.
>>
>> Do we really need 4bytes for ID ? If so, swap_cgroup should be totally re-designed.
>
> That's a memcg restriction which shouldn't have been imposed on cgroup
> core from the beginning.  What memcg should do is rejecting to become
> online from ->css_onilne() if cgrp->id is out of the range it can
> handle.
>

Hmm. I'll think a little and consider a patch to remove memcg's refcnt.


Thanks,
-Kame


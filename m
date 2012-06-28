Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab2F1QG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:06:29 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35210 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab2F1QG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:06:27 -0400
MIME-Version: 1.0
In-Reply-To: <4FEC16EF.40408@jp.fujitsu.com>
References: <4FACDED0.3020400@jp.fujitsu.com>
	<20120621202043.GD4642@google.com>
	<4FE3ADDD.9060908@jp.fujitsu.com>
	<20120627175818.GM15811@google.com>
	<4FEC16EF.40408@jp.fujitsu.com>
Date: Thu, 28 Jun 2012 09:06:25 -0700
X-Google-Sender-Auth: dLK8HKw7xWgPEHGkzG2W62juCRM
Message-ID: <CAOS58YNuSMjDB00UgOPjGCSFcRx-gjvMrW+e4uW0ug8WMsuFSw@mail.gmail.com>
Subject: Re: [PATCH v3][0/6] memcg: prevent -ENOMEM in pre_destroy()
From: Tejun Heo <tj@kernel.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, KAME.

On Thu, Jun 28, 2012 at 1:33 AM, Kamezawa Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> Ooh, once memcg drops the __DEPRECATED_clear_css_refs, cgroup_rmdir()
>> will mark the cgroup dead before start calling pre_destroy() and none
>> of the above will happen.
>>
>
> Hm, threads which touches memcg should hold memcg's reference count rather
> than css.
> Right ? IIUC, one of reason is a reference from kswapd etc...hm. I'll check
> it.

Not sure I'm following. I meant that css_tryget() will always fail
once pre_destroy() calls being for the cgroup, so no new child or
reference can be created for it after that point.

Thanks.

-- 
tejun

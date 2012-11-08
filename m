Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab2KHFAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 00:00:55 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36529 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2KHFAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 00:00:53 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <509B3C72.3050904@jp.fujitsu.com>
Date: Thu, 08 Nov 2012 14:00:34 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl, linux-pm@vger.kernel.org,
        fweisbec@gmail.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 6/9] cgroup_freezer: make freezer->state mask of flags
References: <1351931915-1701-1-git-send-email-tj@kernel.org> <1351931915-1701-7-git-send-email-tj@kernel.org> <509B371E.9050005@jp.fujitsu.com> <20121108044255.GG2660@mtj.dyndns.org>
In-Reply-To: <20121108044255.GG2660@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/08 13:42), Tejun Heo wrote:
> Hello, Kame.
>
> On Thu, Nov 08, 2012 at 01:37:50PM +0900, Kamezawa Hiroyuki wrote:
>> How about
>> enum {
>>     __CGROUP_FREEZING,
>>     __CGROUP_FROZEN,
>> };
>>
>> #define CGROUP_FREEZER_STATE_MASK  0x3
>> #define CGROUP_FREEZER_STATE(state)	((state) & CGROUP_FREEZER_STATE_MASK)
>> #define CGROUP_THAW(state)	(CGROUP_FREEZER_STATE(state) == 0)
>> #define CGROUP_FREEZING(state)	(CGROUP_FREEZER_STATE(state) == __CGROUP_FREEZING)
>> #define CGROUP_FROZEN(state)\
>> 	(CGROUP_FREEZER_STATE(state) == (__CGROUP_FREEZING | __CGROUP_FROZEN))
>
> I think it's a bit overdone and we have cases where we test for
> FREEZING regardless of FROZEN and cases where test for FREEZING &&
> !FROZEN.  We can have, say, CGROUP_FREZING() and then
> CGROUP_FREEZING_BUT_NOT_FROZEN(), but it feels more like obfuscation
> than anything else.
>

Hm, then, I'm glad if I can see what combinations of flags are valid and
meanings of them in source code comments.

Anyway,
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



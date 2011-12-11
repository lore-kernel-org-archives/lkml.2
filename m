Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab1LKTLs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 14:11:48 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39353 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab1LKTLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 14:11:47 -0500
Message-ID: <4EE5006F.6070604@gmail.com>
Date: Sun, 11 Dec 2011 14:11:43 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        cgroups@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        devel@openvz.org, Linux Containers <containers@lists.osdl.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: How to draw values for /proc/stat
References: <4EDC8FB1.60407@parallels.com> <1323439411.17673.65.camel@twins> <4EE22179.5090106@parallels.com> <4EE4C350.90509@parallels.com>
In-Reply-To: <4EE4C350.90509@parallels.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> IOW a /proc namespace coupled to cgroup scope would do what you want.
>>> Now my head hurts..
>>
>> Mine too. The idea is good, but too broad. Boils down to: How do you
>> couple them? And none of the methods I thought about seemed to make any
>> sense.
>>
>> If we really want to have the values in /proc being opted-in, I think
>> Kamezawa's idea of a mount option is the winner so far.

 > diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
 > index 1b7f9d5..f0bc2e9 100644
 > --- a/include/linux/cgroup.h
 > +++ b/include/linux/cgroup.h
 > @@ -158,6 +158,7 @@ enum {
 > 	 * Clone cgroup values when creating a new child cgroup
 > 	 */
 > 	CGRP_CLONE_CHILDREN,
 > +	CGRP_PROC_OVERLAY,
 > };

I'm not cgroup expert, but I doubt it is mount option. I suspect it's
cgroup option. That's said, if we have following two directories,

/cgroup-for-virtualization
/cgroup-for-resource-management

are both directory affected the overlay flag? I don't think it is not
optimal. Why? we must care some system software (e.g. kvm, systemd) are
using cgroup internally and we expected this trend will grow more.

So, I doubt namespace issue can be solved by such tiny patch.


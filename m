Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab1LKUt3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 15:49:29 -0500
Received: from mx2.parallels.com ([64.131.90.16]:50186 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab1LKUt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 15:49:27 -0500
Message-ID: <4EE5171D.10905@parallels.com>
Date: Sun, 11 Dec 2011 21:48:29 +0100
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        <cgroups@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>, Linux Containers <containers@lists.osdl.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: How to draw values for /proc/stat
References: <4EDC8FB1.60407@parallels.com> <1323439411.17673.65.camel@twins> <4EE22179.5090106@parallels.com> <4EE4C350.90509@parallels.com> <4EE5006F.6070604@gmail.com>
In-Reply-To: <4EE5006F.6070604@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [83.149.9.224]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2011 08:11 PM, KOSAKI Motohiro wrote:
>
>>>> IOW a /proc namespace coupled to cgroup scope would do what you want.
>>>> Now my head hurts..
>>>
>>> Mine too. The idea is good, but too broad. Boils down to: How do you
>>> couple them? And none of the methods I thought about seemed to make any
>>> sense.
>>>
>>> If we really want to have the values in /proc being opted-in, I think
>>> Kamezawa's idea of a mount option is the winner so far.
>
>  > diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
>  > index 1b7f9d5..f0bc2e9 100644
>  > --- a/include/linux/cgroup.h
>  > +++ b/include/linux/cgroup.h
>  > @@ -158,6 +158,7 @@ enum {
>  > * Clone cgroup values when creating a new child cgroup
>  > */
>  > CGRP_CLONE_CHILDREN,
>  > + CGRP_PROC_OVERLAY,
>  > };
>
> I'm not cgroup expert, but I doubt it is mount option. I suspect it's
> cgroup option. That's said, if we have following two directories,

Actually, the way I proposed, you have both ways. The mount option is 
more a default value for convenience, that is effective until you change 
a file. That's the same way as clone_children already do, and I believe 
it to be a sane thing.

> /cgroup-for-virtualization
> /cgroup-for-resource-management
>
> are both directory affected the overlay flag?

It depends. The flag is per-cgroup, therefore per-directory. So even if 
you set the mount option, you can override it in an individual cgroup.

> I don't think it is not
> optimal. Why? we must care some system software (e.g. kvm, systemd) are
> using cgroup internally and we expected this trend will grow more.

As I said before, each directory has its own files, so in a standard 
system, we would be more than happy to set it to 1 in the cgroups 
corresponding to our containers, and leave the rest of the world alone.

> So, I doubt namespace issue can be solved by such tiny patch.
>
I don't fully get what you mean here

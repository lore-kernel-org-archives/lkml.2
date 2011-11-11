Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab1KKVd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 16:33:26 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35417 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab1KKVdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 16:33:24 -0500
Message-ID: <4EBD94A0.9070703@google.com>
Date: Fri, 11 Nov 2011 13:33:20 -0800
From: Paul Turner <pjt@google.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Glauber Costa <glommer@parallels.com>
CC: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, fweisbec@gmail.com,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH v2 14/14] Change CPUACCT to default n
References: <1320182360-20043-1-git-send-email-glommer@parallels.com> <1320182360-20043-15-git-send-email-glommer@parallels.com>
In-Reply-To: <1320182360-20043-15-git-send-email-glommer@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2011 02:19 PM, Glauber Costa wrote:
> Now that we're providing all cpuacct capability in cpu cgroup,
> default CPUACCT to n. We still maintain it for compatiblity for
> anyone that need an independent set of tasks to be managed by it
> relatively to cpu cgroup, but encourage the use of cpucgroup for that.
>
> Proposing schedule of deprecation for 3.5
>


I'd like to see a little more separation beyond 1 linear series here.


We're doing the following things

1. Migrating the existing cpuacct functionality into cpu
2. Deprecating cpuacct
3. Adding new functionality

I would like to consider (3) separately from 1/2 which we can and should 
accomplish immediately due to the over-head it's currently introducing.  It 
seems less than optimal to hinge resolving that on reaching agreement for the 
new bits.

It also helps that the the migrated functionality in (1) is just exporting state 
that is already being maintained by cpu so those changes end up being quite 
small and non-invasive.

- Paul

> Signed-off-by: Glauber Costa<glommer@parallels.com>
> CC: Balbir Singh<bsingharora@gmail.com>
> ---
>   Documentation/feature-removal-schedule.txt |    8 ++++++++
>   init/Kconfig                               |    1 +
>   2 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index d5ac362..91165fe 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -609,3 +609,11 @@ When:	3.5
>   Why:	The iwlagn module has been renamed iwlwifi.  The alias will be around
>   	for backward compatibility for several cycles and then dropped.
>   Who:	Don Fry<donald.h.fry@intel.com>
> +
> +----------------------------
> +
> +What:	cpuacct cgroup
> +When:	3.5
> +Why:	Same functionality is provided by the CGROUP_SCHED, with a lower
> +	footprint.
> +Who:	Glauber Costa<glommer@parallels.com>
> diff --git a/init/Kconfig b/init/Kconfig
> index 31ba0fd..d3d958b 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -626,6 +626,7 @@ config PROC_PID_CPUSET
>
>   config CGROUP_CPUACCT
>   	bool "Simple CPU accounting cgroup subsystem"
> +	default n
>   	help
>   	  Provides a simple Resource Controller for monitoring the
>   	  total CPU consumed by the tasks in a cgroup.


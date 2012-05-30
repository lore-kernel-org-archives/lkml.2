Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab2E3Kip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 06:38:45 -0400
Received: from mx2.parallels.com ([64.131.90.16]:44967 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283Ab2E3Kio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 06:38:44 -0400
Message-ID: <4FC5F82B.6030404@parallels.com>
Date: Wed, 30 May 2012 14:36:27 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <devel@openvz.org>, Paul Turner <pjt@google.com>,
        Tejun Heo <tj@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
        <handai.szj@gmail.com>, <Andrew.Phillips@lmax.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v3 2/6] account guest time per-cgroup as well.
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>  <1338371317-5980-3-git-send-email-glommer@parallels.com> <1338373947.26856.240.camel@twins>
In-Reply-To: <1338373947.26856.240.camel@twins>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 02:32 PM, Peter Zijlstra wrote:
> On Wed, 2012-05-30 at 13:48 +0400, Glauber Costa wrote:
>> >  We already track multiple tick statistics per-cgroup, using
>> >  the task_group_account_field facility. This patch accounts
>> >  guest_time in that manner as well.
> So this leaves IOWAIT and IDLE the only fields not using
> task_group_account_field(), right?

Yes, because they are essentially global, and their meaning is 
ill-defined from within a cgroup.

If you look further out in the patchset, I intend to export idle from 
cpu, instead of cpuacct, because something that can be used as idle 
value is already computed anyway from the schedstats, so I'm just using it.

iowait will be left blank for now. Me and Paul agreed last time we 
talked that it is not uber important to have iowait values per-cgroup.

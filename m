Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab2E3Kqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 06:46:47 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63273 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab2E3Kqp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 06:46:45 -0400
MIME-Version: 1.0
In-Reply-To: <4FC5F82B.6030404@parallels.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>
 <1338371317-5980-3-git-send-email-glommer@parallels.com> <1338373947.26856.240.camel@twins>
 <4FC5F82B.6030404@parallels.com>
From: Paul Turner <pjt@google.com>
Date: Wed, 30 May 2012 03:46:13 -0700
Message-ID: <CAPM31RJjMZ4ZJP_=_nGLk8AeBvzZ+PhEpjXxEb2Ko_0f7dsdgg@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] account guest time per-cgroup as well.
To: Glauber Costa <glommer@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, devel@openvz.org, Tejun Heo <tj@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, handai.szj@gmail.com,
        Andrew.Phillips@lmax.com, Serge Hallyn <serge.hallyn@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 3:36 AM, Glauber Costa <glommer@parallels.com> wrote:
> On 05/30/2012 02:32 PM, Peter Zijlstra wrote:
>>
>> On Wed, 2012-05-30 at 13:48 +0400, Glauber Costa wrote:
>>>
>>> >  We already track multiple tick statistics per-cgroup, using
>>> >  the task_group_account_field facility. This patch accounts
>>> >  guest_time in that manner as well.
>>
>> So this leaves IOWAIT and IDLE the only fields not using
>> task_group_account_field(), right?
>
>
> Yes, because they are essentially global, and their meaning is ill-defined
> from within a cgroup.
>
> If you look further out in the patchset, I intend to export idle from cpu,
> instead of cpuacct, because something that can be used as idle value is
> already computed anyway from the schedstats, so I'm just using it.
>
> iowait will be left blank for now. Me and Paul agreed last time we talked
> that it is not uber important to have iowait values per-cgroup.

Stronger:  it lacks a definition you can sanely measure without atomic
counters everywhere (similarly for group-idle).

> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

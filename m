Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab1AEPCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 10:02:33 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34551 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1AEPCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 10:02:32 -0500
MIME-Version: 1.0
In-Reply-To: <1294220650.2016.197.camel@laptop>
References: <20110105045447.GN23414@ksplice.com>
	<1294220650.2016.197.camel@laptop>
Date: Wed, 5 Jan 2011 10:02:31 -0500
Message-ID: <AANLkTi=FC27TTngERgbS95Z29CYBqLGxR4Uuw9fSTVuO@mail.gmail.com>
Subject: Re: cgroup scheduling: Adding kthreadd to a non-RT cgroup can
 deadlock the kernel
From: Nelson Elhage <nelhage@ksplice.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok. I bothered reporting this here since the kernel /does/ try to prevent you
from shooting yourself in the foot in related ways, by moving existing
SCHED_FIFO tasks into a cgroup without any RT runtime, so I figured it might
make sense to add a check here. libcgroup, for example, will try to move all
processes into a default cgroup, ignoring errors, and relies on the kernel to
prevent it from shooting itself in the foot.

It sounds like you consider that behavior a bug, though, so I'll go report this
bug there.

- Nelson

On Wed, Jan 5, 2011 at 4:44 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-01-04 at 23:54 -0500, Nelson Elhage wrote:
>> Hi,
>>
>> I've found a bug where, on CONFIG_RT_GROUP_SCHED systems, adding the kthreadd
>> task to a cgroup with cpu.rt_runtime_us = 0 (as some cgroup configuration
>> scripts do, when they move all processes into a default cgroup), can result in
>> deadlocks in the kernel.
>
> IMHO its a bug to move kthreadd into a cgroup. Simply don't do that.
>
>
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab2FLPix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:38:53 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60583 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751701Ab2FLPiv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:38:51 -0400
MIME-Version: 1.0
In-Reply-To: <1339479468-3815-1-git-send-email-zheng.z.yan@intel.com>
References: <1339479468-3815-1-git-send-email-zheng.z.yan@intel.com>
Date: Tue, 12 Jun 2012 17:38:50 +0200
Message-ID: <CABPqkBQu1hTa2R-PKsygLqOSSD9nu3+xR-79pT-8bB8Y16CBuw@mail.gmail.com>
Subject: Re: [PATCH V5 0/13] perf: Intel uncore pmu counting support
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, jolsa@redhat.com,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 7:37 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> Hi, all
>
> Here is the V5 patches to add uncore counting support for Nehalem,
> Sandy Bridge and Sandy Bridge-EP, applied on top of current tip.
> The code is based on Lin Ming's old patches.
>
> For Nehalem and Sandy Bridge-EP, A few general events are exported
> under sysfs directory:
>  /sys/bus/event_source/devices/${uncore_dev}/events/
>
On NHM, I tried:
    perf stat -a -e Uncore/CLOCKTICKS/
invalid or unsupported event: 'Uncore/CLOCKTICKS/'

I started tracking this down but gave up because it's coming
once again from the too complex parser. You are looking for
a format match (inv, edge, cmask) with the word CLOCKTICKS
instead of config.

Please fix this.

Also I don't think using upper case for the PMU name is a good idea.
Just call it uncore.


> Each file in the events directory defines an event. The content is
> a string such as:
>  config=1,config1=2
>
> You can use 'perf stat' to access to the uncore pmu. For example:
>  perf stat -a -C 0 -e 'Uncore_iMC_0/CAS_COUNT_RD/' sleep 1
>  perf stat -a -C 0 -e 'Uncore_iMC_0/event=CAS_COUNT_RD/' sleep 1
>
> Any comment is appreciated.
> Thank you
> ---
> Changes since v1:
>  - Modify perf tool to parse events from sysfs
>  - A few minor code cleanup
>
> Changes since v2:
>  - Place all events for a particular socket onto a single cpu
>  - Make the events parser in perf tool reentrantable
>  - A few code cleanup
>
> Changes since v3:
>  - Use per cpu pointer to track uncore box
>  - Rework the cpu hotplug code because topology_physical_package_id()
>   return wrong result when the cpu is offline
>  - Rework the event alias code, event terms are stored in the alias
>   structure instead events string
>
> Changes since v4:
>  - Include Jiri's uncore related changes patch set
>  - Add pmu/event=alias/ syntax support
>

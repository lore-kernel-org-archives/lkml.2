Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab2JETHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 15:07:05 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:59611 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab2JETHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 15:07:01 -0400
MIME-Version: 1.0
In-Reply-To: <506E43E0.70507@jp.fujitsu.com>
References: <506E43E0.70507@jp.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 5 Oct 2012 15:06:35 -0400
X-Google-Sender-Auth: 7o_gaewDQpMi7-EegmQ6IFq-ZOQ
Message-ID: <CAHGf_=qCZvL7xcOkea80Y995sZWkOMQLLVnuvLUto4W+qpUbWA@mail.gmail.com>
Subject: Re: [PATCH 0/10] memory-hotplug: hot-remove physical memory
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org, wency@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Known problems:
> 1. memory can't be offlined when CONFIG_MEMCG is selected.
>    For example: there is a memory device on node 1. The address range
>    is [1G, 1.5G). You will find 4 new directories memory8, memory9, memory10,
>    and memory11 under the directory /sys/devices/system/memory/.
>    If CONFIG_MEMCG is selected, we will allocate memory to store page cgroup
>    when we online pages. When we online memory8, the memory stored page cgroup
>    is not provided by this memory device. But when we online memory9, the memory
>    stored page cgroup may be provided by memory8. So we can't offline memory8
>    now. We should offline the memory in the reversed order.
>    When the memory device is hotremoved, we will auto offline memory provided
>    by this memory device. But we don't know which memory is onlined first, so
>    offlining memory may fail. In such case, you should offline the memory by
>    hand before hotremoving the memory device.

Just iterate twice. 1st iterate: offline every non primary memory
block. 2nd iterate:
offline primary (i.e. first added) memory block. It may work.

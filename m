Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab2JBIZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 04:25:48 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58457 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab2JBIZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 04:25:44 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <506AA4E2.7070302@jp.fujitsu.com>
Date: Tue, 2 Oct 2012 17:25:06 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <x86@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>
CC: <rientjes@google.com>, <liuj97@gmail.com>, <len.brown@intel.com>,
        <cl@linux.com>, <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <wency@cn.fujitsu.com>
Subject: [PATCH 0/2] memory-hotplug : notification of memoty block's state
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are trying to implement a physical memory hot removing function as
following thread.

https://lkml.org/lkml/2012/9/5/201

But there is not enough review to merge into linux kernel.

I think there are following blockades.
  1. no physical memory hot removable system
  2. huge patch-set

If you have a KVM system, we can get rid of 1st blockade. Because
applying following patch, we can create memory hot removable system
on KVM guest.

http://lists.gnu.org/archive/html/qemu-devel/2012-07/msg01389.html

2nd blockade is own problem. So we try to divide huge patch into
a small patch in each function as follows: 

 - bug fix
 - acpi framework
 - kernel core

We had already sent bug fix patches.

https://lkml.org/lkml/2012/9/27/39

And the patch fixes following bug.

remove_memory() offlines memory. And it is called by following two cases:

1. echo offline >/sys/devices/system/memory/memoryXX/state
2. hot remove a memory device

In the 1st case, the memory block's state is changed and the notification
that memory block's state changed is sent to userland after calling
offline_memory(). So user can notice memory block is changed.

But in the 2nd case, the memory block's state is not changed and the
notification is not also sent to userspcae even if calling offline_memory().
So user cannot notice memory block is changed.

We should also notify to userspace at 2nd case.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430Ab2JBVmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 17:42:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab2JBVmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 17:42:12 -0400
Date: Tue, 2 Oct 2012 14:42:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: <x86@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>, <rientjes@google.com>,
        <liuj97@gmail.com>, <len.brown@intel.com>, <cl@linux.com>,
        <minchan.kim@gmail.com>, <kosaki.motohiro@jp.fujitsu.com>,
        <wency@cn.fujitsu.com>
Subject: Re: [PATCH 0/2] memory-hotplug : notification of memoty block's
 state
Message-Id: <20121002144211.b60881a8.akpm@linux-foundation.org>
In-Reply-To: <506AA4E2.7070302@jp.fujitsu.com>
References: <506AA4E2.7070302@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2012 17:25:06 +0900
Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com> wrote:

> remove_memory() offlines memory. And it is called by following two cases:
> 
> 1. echo offline >/sys/devices/system/memory/memoryXX/state
> 2. hot remove a memory device
> 
> In the 1st case, the memory block's state is changed and the notification
> that memory block's state changed is sent to userland after calling
> offline_memory(). So user can notice memory block is changed.
> 
> But in the 2nd case, the memory block's state is not changed and the
> notification is not also sent to userspcae even if calling offline_memory().
> So user cannot notice memory block is changed.
> 
> We should also notify to userspace at 2nd case.

These two little patches look reasonable to me.

There's a lot of recent activity with memory hotplug!  We're in the 3.7
merge window now so it is not a good time to be merging new material. 
Also there appear to be two teams working on it and it's unclear to me
how well coordinated this work is?

However these two patches are pretty simple and do fix a problem, so I
added them to the 3.7 MM queue.

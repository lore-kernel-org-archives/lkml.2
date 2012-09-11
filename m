Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab2IKPD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 11:03:57 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59189 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759287Ab2IKPDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 11:03:54 -0400
Message-ID: <504F52D4.5010509@colorfullife.com>
Date: Tue, 11 Sep 2012 17:03:48 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, arnd@arndb.de,
        hughd@google.com, linux-kernel@vger.kernel.org, cmetcalf@tilera.com,
        yeohc@au1.ibm.com, linux-security-module@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, hpa@zytor.com, casey@schaufler-ca.com,
        eparis@parisplace.org, devel@openvz.org
Subject: Re: [PATCH v4 8/9] IPC: message queue copy feature introduced
References: <20120813122835.5581.70057.stgit@localhost6.localdomain6> <20120813123216.5581.34968.stgit@localhost6.localdomain6>
In-Reply-To: <20120813123216.5581.34968.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2012 02:32 PM, Stanislav Kinsbursky wrote:
> This patch is required for checkpoint/restore in userspace.
> IOW, c/r requires some way to get all pending IPC messages without deleting
> them from the queue (checkpoint can fail and in this case tasks will be resumed,
> so queue have to be valid).
> To achive this, new operation flag MSG_COPY for sys_msgrcv() system call was
> introduced. If this flag was specified, then mtype is interpreted as number of
> the message to copy.
> If MSG_COPY is set, then kernel will allocate dummy message with passed size,
> and then use new copy_msg() helper function to copy desired message (instead of
> unlinking it from the queue).
>
> Notes:
> 1) Return -ENOSYS if MSG_COPY is specified, but CONFIG_CHECKPOINT_RESTORE is
> not set.
How is CONFIG_CHECKPOINT_RESTORE set?
I'm not sure, but I think it should be added to Kconfig.

--
     Manfred


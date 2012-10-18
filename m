Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab2JRKjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:39:33 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51282 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab2JRKja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:39:30 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20121018102322.16036.86866.stgit@localhost.localdomain>
References: <20121018101543.16036.12221.stgit@localhost.localdomain> <20121018102322.16036.86866.stgit@localhost.localdomain>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 18 Oct 2012 12:39:09 +0200
Message-ID: <CAKgNAkifPthwhBYzeXk24DOuJxV93_Uqr=XjAgPbdpLDbOjELA@mail.gmail.com>
Subject: Re: [PATCH v7 09/10] IPC: message queue copy feature introduced
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, will.deacon@arm.com,
        dhowells@redhat.com, manfred@colorfullife.com, hughd@google.com,
        jmorris@namei.org, kosaki.motohiro@jp.fujitsu.com,
        paulmck@linux.vnet.ibm.com, sds@tycho.nsa.gov, devel@openvz.org,
        a.p.zijlstra@chello.nl, cmetcalf@tilera.com, linux-driver@qlogic.com,
        ron.mercer@qlogic.com, viro@zeniv.linux.org.uk, eparis@parisplace.org,
        tglx@linutronix.de, jitendra.kalsaria@qlogic.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, ebiederm@xmission.com,
        casey@schaufler-ca.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 12:23 PM, Stanislav Kinsbursky
<skinsbursky@parallels.com> wrote:
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

Stanislav,

A naive question, because I have not followed C/R closely. How do you
deal with the case that other processes may be reading from the queue?
(Or is that disabled during checkpointing?)

Thanks,

Michael

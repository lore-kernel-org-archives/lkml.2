Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab2LRUgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 15:36:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab2LRUgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 15:36:02 -0500
Date: Tue, 18 Dec 2012 12:36:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: serge.hallyn@canonical.com, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, xemul@parallels.com,
        catalin.marinas@arm.com, will.deacon@arm.com, jmorris@namei.org,
        cmetcalf@tilera.com, joe.korty@ccur.com, dhowells@redhat.com,
        dledford@redhat.com, viro@zeniv.linux.org.uk,
        kosaki.motohiro@jp.fujitsu.com, linux-api@vger.kernel.org,
        serue@us.ibm.com, tglx@linutronix.de, paulmck@linux.vnet.ibm.com,
        devel@openvz.org, mtk.manpages@gmail.com,
        Sasha Levin <sasha.levin@oracle.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [RFC PATCH v8 0/5] IPC: checkpoint/restore in userspace
 enhancements
Message-Id: <20121218123601.113a29c0.akpm@linux-foundation.org>
In-Reply-To: <20121024151555.5642.79086.stgit@localhost.localdomain>
References: <20121024151555.5642.79086.stgit@localhost.localdomain>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012 19:34:51 +0400
Stanislav Kinsbursky <skinsbursky@parallels.com> wrote:

> This respin of the patch set was significantly reworked. Most part of new API
> was replaced by sysctls (by one per messages, semaphores and shared memory),
> allowing to preset desired id for next new IPC object.
> 
> This patch set is aimed to provide additional functionality for all IPC
> objects, which is required for migration of these objects by user-space
> checkpoint/restore utils (CRIU).
> 
> The main problem here was impossibility to set up object id. This patch set
> solves the problem by adding new sysctls for preset of desired id for new IPC
> object.
> 
> Another problem was to peek messages from queues without deleting them.
> This was achived by introducing of new MSG_COPY flag for sys_msgrcv(). If
> MSG_COPY flag is set, then msgtyp is interpreted as message number.

According to my extensive records, Sasha hit a bug in
ipc-message-queue-copy-feature-introduced.patch and Fengguang found a
bug in
ipc-message-queue-copy-feature-introduced-cleanup-do_msgrcv-aroung-msg_copy-feature.patch

It's not obvious (to me) that these things have been identified and
fixed.  What's the status, please?


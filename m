Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422659Ab2JXVme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:42:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42248 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161224Ab2JXVmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:42:32 -0400
Date: Wed, 24 Oct 2012 14:42:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: serge.hallyn@canonical.com, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, xemul@parallels.com,
        catalin.marinas@arm.com, will.deacon@arm.com, jmorris@namei.org,
        cmetcalf@tilera.com, joe.korty@ccur.com, dhowells@redhat.com,
        dledford@redhat.com, viro@zeniv.linux.org.uk,
        kosaki.motohiro@jp.fujitsu.com, linux-api@vger.kernel.org,
        serue@us.ibm.com, tglx@linutronix.de, paulmck@linux.vnet.ibm.com,
        devel@openvz.org, mtk.manpages@gmail.com
Subject: Re: [RFC PATCH v8 0/5] IPC: checkpoint/restore in userspace
 enhancements
Message-Id: <20121024144230.a932f2e9.akpm@linux-foundation.org>
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

OK, thanks, I grabbed these.  They're not the worst c/r patches I've
ever seen ;)

I'm not seeing any evidence that anyone else has reviewed or tested
these?


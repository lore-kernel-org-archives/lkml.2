Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab1LETD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:03:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932204Ab1LETDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:03:55 -0500
Date: Mon, 5 Dec 2011 19:35:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com,
        ebiederm@xmission.com, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/3] PM / Sleep: Make [un]lock_system_sleep() generic
Message-ID: <20111205183502.GA30482@redhat.com>
References: <20111204200208.25620.515.stgit@srivatsabhat.in.ibm.com> <20111205171443.GB627@google.com> <4EDCFE9F.9050605@linux.vnet.ibm.com> <20111205173057.GE627@google.com> <4EDD0254.10408@linux.vnet.ibm.com> <4EDD0D35.1020907@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDD0D35.1020907@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05, Srivatsa S. Bhat wrote:
>
> I looked up in git and found that commit ba96a0c by Rafael introduced the
> count functions, to handle the vfork case. But now, we seem to have more
> uses than that. So I think we can remove that userspace restriction in the
> count functions,

Agreed.

> and in kernel/fork.c, do something like:
>
> if (current->mm)
> 	freezer_do_not_count();
> ...
> if (current->mm)
> 	freezer_count();

see http://marc.info/?l=linux-kernel&m=132033335507261

I think this is not needed, we can just remove the ->mm check.
CLONE_VFORK is not used by a freezable kthread.

Oleg.


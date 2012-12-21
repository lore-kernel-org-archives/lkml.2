Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab2LURhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 12:37:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab2LURhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 12:37:33 -0500
Date: Fri, 21 Dec 2012 18:37:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>
Subject: Re: [RFC PATCH 0/6] uprobes: return probe implementation
Message-ID: <20121221173741.GA21931@redhat.com>
References: <1356088596-17858-1-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356088596-17858-1-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21, Anton Arapov wrote:
>
>   There are RFC uretprobes implementation. I'd be grateful for any review.

Anton, I won't look at this series till Monday (at least).

But at first glance it needs a lot of cleanups and _fixes_.

If nothing else, ->return_instances logic looks very wrong (but again,
I didn't really read this series and I already had a beer ;).

Just for example. Suppose that you insert uretprobe at exit() in glibc().
IOW, handle_swbp(rp_trampoline_vaddr) never happens. Who will cleanup
utask->return_instances and kfree() return_instance's?

Or. return_consumer_del() simply removes uprobe_consumer. Again, somehow
we should free the "pending" return_instance's. Plus we should restore
the original return adresses connected to these return_instance's. Just
suppose that uretprobe_run_handlers() is called after uprobe has gone
away. In this case ri->uprobe points to nowhere.

Oleg.


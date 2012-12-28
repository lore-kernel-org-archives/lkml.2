Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab2L1SNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 13:13:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995Ab2L1SNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 13:13:34 -0500
Date: Fri, 28 Dec 2012 19:12:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] uprobes: pre-filtering
Message-ID: <20121228181252.GA6120@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On top of preparations I sent a month ago. Srikar, you still didn't
review the last 2 patches. I assume you do not care so I am going to
add them without your ack.

Initially I was going to send more patches in this series. We can add
some optimizations to avoid the unnecessary register_for_each_vma() or
even consumer->filter() if there is a consumer with ->filter == NULL.
But lets do this later, lets discuss the functional change first.

Next steps:

	- teach handler_chain() to remove the unwanted breakpoints

	- if the above is not enough, implement UPROBE_FILTER_FORK

	- implement uprobe_apply(consumer, task, is_register) ?

Ole.


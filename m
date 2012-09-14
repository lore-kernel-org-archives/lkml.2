Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598Ab2INReV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:34:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759068Ab2INReT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:34:19 -0400
Date: Fri, 14 Sep 2012 19:35:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] uprobes: Do not leak UTASK_BP_HIT if
	find_active_uprobe() fails
Message-ID: <20120914173552.GA30072@redhat.com>
References: <20120914171513.GA29599@redhat.com> <20120914171551.GA29632@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914171551.GA29632@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(additional note to simplify the review)

On 09/14, Oleg Nesterov wrote:
>
> Note
> that we do this unconditionally, see the next patch(es).

IOW, we could move it under "if (!uprobe)" branch, but we do not.

This is mostly needed for 2/5, which in turn is needed for 3/5.
If can_skip_sstep() succeeds we need to reset utask->state too.

ALternatively we could start with 4/5, but this is the "separate"
change (and it is not bug-fix) which needs your review/ack.

Oleg.


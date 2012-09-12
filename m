Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761051Ab2ILSKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:10:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761030Ab2ILSKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:10:51 -0400
Date: Wed, 12 Sep 2012 20:12:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: srikar@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org,
        gdb-patches@sourceware.org
Subject: Re: [PATCH 2/2] uprobes: add global breakpoints
Message-ID: <20120912181210.GA11122@redhat.com>
References: <1347377843-16017-1-git-send-email-bigeasy@linutronix.de> <1347377843-16017-2-git-send-email-bigeasy@linutronix.de> <20120912143010.GA1447@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912143010.GA1447@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12, Oleg Nesterov wrote:
>
> Lets start with the patch below,
> ...
>
> -	if (!(uprobe->flags & UPROBE_SKIP_SSTEP))
> +	if (!(uprobe->flags & UPROBE_SKIP_SSTEP) || (action & UPROBE_RESTART))

Hmm. This is wrong, but only because handle_swbp() is buggy.
I'll send the fix tomorrow.

Oleg.


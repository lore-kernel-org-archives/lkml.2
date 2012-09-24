Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab2IXJN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:13:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45044 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2IXJNZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:13:25 -0400
Message-ID: <1348477990.11847.11.camel@twins>
Subject: Re: [PATCH 3/4] uprobes: Kill set_orig_insn()->is_swbp_at_addr()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Date: Mon, 24 Sep 2012 11:13:10 +0200
In-Reply-To: <20120923201950.GA27456@redhat.com>
References: <20120923201950.GA27456@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-09-23 at 22:19 +0200, Oleg Nesterov wrote:

> @@ -226,6 +245,10 @@ retry:

Could you use:

$ cat ~/.gitconfig 
[diff "default"]
	xfuncname = "^[[:alpha:]$_].*[^:]$"

This avoids git-diff it using labels as function names.

>  	if (ret <= 0)
>  		return ret;
>  
> +	ret = verify_opcode(old_page, vaddr, &opcode);
> +	if (ret <= 0)
> +		goto put_old;
> +
>  	ret = -ENOMEM;
>  	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vaddr);
>  	if (!new_page)


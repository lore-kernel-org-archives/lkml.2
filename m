Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760752Ab2FDPBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:01:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46901 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760691Ab2FDPBD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:01:03 -0400
Message-ID: <1338822048.28282.59.camel@twins>
Subject: Re: [PATCH 3/3] uprobes: document uprobe_register() vs
 uprobe_mmap() race
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Jun 2012 17:00:48 +0200
In-Reply-To: <20120604145331.GC6416@redhat.com>
References: <20120604145238.GA6408@redhat.com>
	 <20120604145331.GC6416@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 16:53 +0200, Oleg Nesterov wrote:

I didn't check if its my error or not, however:

> @@ -850,6 +869,10 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
>  
>  		if (is_register) {
>  			err = install_breakpoint(uprobe, mm, vma, info->vaddr);
> +			/*
> +			 * We can race against uprobe_register(), see the

that should be uprobe_mmap(), since this is the register path ;-)

> +			 * comment near uprobe_hash().
> +			 */
>  			if (err == -EEXIST)
>  				err = 0;
>  		} else {
> @@ -1058,8 +1081,10 @@ int uprobe_mmap(struct vm_area_struct *vma)
>  			}
>  
>  			ret = install_breakpoint(uprobe, vma->vm_mm, vma, vaddr);
> -
> -			/* Ignore double add: */
> +			/*
> +			 * We can race against uprobe_register(), see the
> +			 * comment near uprobe_hash().
> +			 */
>  			if (ret == -EEXIST) {
>  				ret = 0;
>  


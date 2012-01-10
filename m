Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623Ab2AJArw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 19:47:52 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40353 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933599Ab2AJArv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 19:47:51 -0500
Subject: Re: [PATCH][RESEND] kprobes: initialize before using a hlist
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: ananth@in.ibm.com
Cc: lkml <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        stable@vger.kernel.org
In-Reply-To: <20120109082001.GE20666@in.ibm.com>
References: <20120109082001.GE20666@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Jan 2012 16:47:43 -0800
Message-ID: <1326156463.3609.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
x-cbid: 12011000-7182-0000-0000-00000083ADE4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-09 at 13:50 +0530, Ananth N Mavinakayanahalli wrote:
> From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> 
> Commit ef53d9c5e introduced a bug where we can potentially leak
> kretprobe_instances since we initialize a hlist head after having
> used it.
> 
> Initialize the hlist head before using it.
> 
> (Resent with correct email ID for -stable)
> 
> Reported by: Jim Keniston <jkenisto@us.ibm.com>
> Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: <stable@vger.kernel.org>

Acked-by: Jim Keniston <jkenisto@us.ibm.com>

> ---
>  kernel/kprobes.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-3.2/kernel/kprobes.c
> ===================================================================
> --- linux-3.2.orig/kernel/kprobes.c
> +++ linux-3.2/kernel/kprobes.c
> @@ -1077,6 +1077,7 @@ void __kprobes kprobe_flush_task(struct 
>  		/* Early boot.  kretprobe_table_locks not yet initialized. */
>  		return;
> 
> +	INIT_HLIST_HEAD(&empty_rp);
>  	hash = hash_ptr(tk, KPROBE_HASH_BITS);
>  	head = &kretprobe_inst_table[hash];
>  	kretprobe_table_lock(hash, &flags);
> @@ -1085,7 +1086,6 @@ void __kprobes kprobe_flush_task(struct 
>  			recycle_rp_inst(ri, &empty_rp);
>  	}
>  	kretprobe_table_unlock(hash, &flags);
> -	INIT_HLIST_HEAD(&empty_rp);
>  	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
>  		hlist_del(&ri->hlist);
>  		kfree(ri);



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab2KMBFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 20:05:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab2KMBFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 20:05:16 -0500
Date: Mon, 12 Nov 2012 17:05:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 7/7] fdinfo: Show sigmask for signalfd fd v2
Message-Id: <20121112170514.1ac51330.akpm@linux-foundation.org>
In-Reply-To: <20121112101846.167035815@openvz.org>
References: <20121112101440.665694060@openvz.org>
	<20121112101846.167035815@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012 14:14:47 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

>
> ...
>
> --- linux-2.6.git.orig/include/linux/proc_fs.h
> +++ linux-2.6.git/include/linux/proc_fs.h
> @@ -290,4 +290,7 @@ static inline struct net *PDE_NET(struct
>  	return pde->parent->data;
>  }
>  
> +#include <asm/signal.h>
> +
> +void render_sigset_t(struct seq_file *m, const char *header, sigset_t *set);
>  #endif /* _LINUX_PROC_FS_H */

hm.  Are you sure asm/signal.h is the way to get sigset_t?  "grep -l
sigset_t arch/*/include/asm/signal.h" is unpromising and
kernel/signal.c doesn't do it this way?


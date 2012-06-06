Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759179Ab2FFWvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 18:51:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47390 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab2FFWvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 18:51:00 -0400
Date: Wed, 6 Jun 2012 15:50:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Rob Landley <rob@landley.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W.Biederman" <ebiederm@xmission.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        James Morris <james.l.morris@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Michel Lespinasse <walken@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: Re: [PATCH v4] remove no longer use of pdflush interface
Message-Id: <20120606155056.72a6a2b5.akpm@linux-foundation.org>
In-Reply-To: <1338989888-3480-1-git-send-email-liwp.linux@gmail.com>
References: <1338989888-3480-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  6 Jun 2012 21:38:08 +0800
Wanpeng Li <liwp.linux@gmail.com> wrote:

> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> Since per-BDI flusher introduced to linux 2.6, pdflush mechanism is not
> used any more. But the old interface of pdflush exported in/proc/sys/vm/
> is still there. In order to take attention to back-compatibility issues,
> printk warning information and return -ENOSYS to notice the users the
> interface is removed.
> 
> ...
>
> +/* notice associated proc obsoleted */

This comment is pretty meaningless - I suggest simply removing it.

> +int pdflush_proc_obsolete(struct ctl_table *table, int write,
> +			void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	printk_once(KERN_WARNING "%s exported in /proc is scheduled for removal\n",
> +			table->procname);
> +	return -ENOSYS;
> +}

No, this immediately breaks /proc/sys/vm/nr_pdflush_threads users.  To
preserve back-compatibility we should copy "0\n" out to userspace and
return 2.

> +EXPORT_SYMBOL(pdflush_proc_obsolete);

This export isn't needed?

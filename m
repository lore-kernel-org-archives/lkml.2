Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328Ab2FKTLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 15:11:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab2FKTLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 15:11:33 -0400
Date: Mon, 11 Jun 2012 21:09:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: linuxppc-dev@lists.ozlabs.org, lkml <linux-kernel@vger.kernel.org>,
        michael@ellerman.id.au, antonb@thinktux.localdomain,
        Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
        Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Jim Keniston <jkenisto@us.ibm.com>
Subject: Q: a_ops->readpage() && struct file
Message-ID: <20120611190902.GA19869@redhat.com>
References: <20120608093257.GG13409@in.ibm.com> <20120611161215.GA12116@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120611161215.GA12116@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11, Oleg Nesterov wrote:
>
> Note also that we should move this !UPROBE_COPY_INSN from
> install_breakpoint() to somewhere near alloc_uprobe().

The main problem is, uprobe_register() doesn't have struct file
for read_mapping_page().

Stupid question. I'm afraid the answer is "no" but I'll ask anyway.
Is it safe to pass filp == NULL to mapping->readpage()? In fact
I do not understand why it needs "struct file*" and I do not see
any example of actual usage. Yes, I didn't try to grep very much
and I understand that the filesystem can do something special.
Say it can use file->private_data...

However. There is read_cache_page_gfp() which does use
a_ops->readpage(filp => NULL), and the comment says nothing about
the riskiness.


If not, is there any other way
uprobe_register(struct inode *inode, loff_t offset) can read the
page at this offset?



And btw, read_mapping_page() accepts "void *data". Why? it uses
filler == a_ops->readpage, it shouldn't accept anything but file
pointer?


Please help, I know nothing about vfs.

Oleg.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2GIIgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 04:36:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:44559 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab2GIIgM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 04:36:12 -0400
Message-ID: <1341822957.3462.18.camel@twins>
Subject: Re: [PATCH 4/5] uprobes: kill copy_vma()->uprobe_mmap()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Date: Mon, 09 Jul 2012 10:35:57 +0200
In-Reply-To: <20120708203008.GA18236@redhat.com>
References: <20120708203008.GA18236@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-07-08 at 22:30 +0200, Oleg Nesterov wrote:
> And why this uprobe_mmap() was added? I believe the intent was wrong.
> Note that the caller is going to do move_page_tables(), all registered
> uprobes are already faulted in, we only change the virtual addresses.
> 

I think it was because of the copy_vma + do_munmap. Since do_munmap()
should be doing a put on the uprobe, we need an extra get to balance.

That said, I cannot actually find the uprobe_munmap() from do_munmap(),
but that might be due to lack of wakefulness etc..

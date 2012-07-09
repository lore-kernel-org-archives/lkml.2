Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab2GIKNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:13:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37201 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab2GIKNv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:13:51 -0400
Message-ID: <1341828805.3462.28.camel@twins>
Subject: Re: [PATCH 2/5] uprobes: suppress uprobe_munmap() from mmput()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Date: Mon, 09 Jul 2012 12:13:25 +0200
In-Reply-To: <20120709100920.GA21163@redhat.com>
References: <20120708203003.GA18226@redhat.com>
	 <1341822602.3462.15.camel@twins> <20120709100920.GA21163@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 12:09 +0200, Oleg Nesterov wrote:
> No, mmap/munmap do not participate in uprobe refcounting. This code
> does put_uprobe() for each uprobe, yes, but only because the counter
> was incremented in build_probe_list().
> 
> uprobe_munmap() is only needed to decrement mm->uprobes_state.count,
> but nobody except uprobe_munmap() itself will use it after mmput(). 

OK, that also answers my other question.

Thanks

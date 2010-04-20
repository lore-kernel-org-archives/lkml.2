Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0DTOcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 10:32:52 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:34680 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab0DTOcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 10:32:51 -0400
Date: Tue, 20 Apr 2010 10:30:16 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Jan Kiszka <jan.kiszka@web.de>, trivial@kernel.org,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 3/5] uml: Fix warning due to missing task_struct
	declaration
Message-ID: <20100420143016.GB30011@c-98-229-117-200.hsd1.ma.comcast.net>
References: <cover.1271713955.git.jan.kiszka@web.de> <1d97cd7761a1eae73923b1adda4c6915a0647bb3.1271713955.git.jan.kiszka@web.de> <20100420100949.GB5317@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100420100949.GB5317@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 06:09:49PM +0800, Amerigo Wang wrote:
> On Mon, Apr 19, 2010 at 11:53:06PM +0200, Jan Kiszka wrote:
> >We can't pull in linux/sched.h, so just declare the struct.
> >
> 
> Did you meet any build error? If yes, please include it.

What does this patch fix, aside from being a bit cleaner?

If it built before, without having a task_struct declaration, I think
that means that the elf_core_copy_fpregs was never used.  The
task_struct * in the declaration would become a private task_struct,
known only to the declaration.  If the implementation or callers have
the regular task_struct, it will be a different one, and the
prototypes will conflict due to the different types of the first
parameter.

			Jeff

-- 
Work email - jdike at linux dot intel dot com

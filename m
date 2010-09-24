Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab0IXHvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 03:51:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55493 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab0IXHvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 03:51:20 -0400
Date: Fri, 24 Sep 2010 03:51:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-alpha@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Kentaro Takeda <takedakn@nttdata.co.jp>
Subject: Re: Tomoyo compile failure on alpha: sys_get[p]pid undefined
Message-ID: <20100924075116.GA2303@infradead.org>
References: <alpine.SOC.1.00.1009240906200.9058@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.SOC.1.00.1009240906200.9058@math.ut.ee>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 09:10:37AM +0300, Meelis Roos wrote:
> 2.6.36-rc5+git as of yesterday:
> 
>   LD      .tmp_vmlinux1
> security/built-in.o: In function `tomoyo_supervisor':(.text+0xea98): undefined reference to `sys_getpid'
> security/built-in.o: In function `tomoyo_supervisor':(.text+0xeab0): undefined reference to `sys_getpid'
> security/built-in.o: In function `tomoyo_supervisor':(.text+0xeac0): undefined reference to `sys_getppid'
> security/built-in.o: In function `tomoyo_supervisor':(.text+0xeac4): undefined reference to `sys_getppid'
> 
> Seems alpha has different mechanisms for using these syscalls from 
> inside the kernel?

The real problem is that kernel code should never call system calls.
The correct fix is to get rid of this abuse.


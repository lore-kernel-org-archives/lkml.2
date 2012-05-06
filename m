Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab2EFXck (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 19:32:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34605 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab2EFXcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 19:32:39 -0400
Date: Mon, 7 May 2012 00:32:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: hpa@zytor.com, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org
Subject: Re: [PATCH] broken TASK_SIZE for ia32_aout
Message-ID: <20120506233234.GA22082@ZenIV.linux.org.uk>
References: <4FA6BBD9.3040308@zytor.com>
 <20120506184641.GW6871@ZenIV.linux.org.uk>
 <b73ca203-c9d8-4ca3-b680-d00499f284cd@email.android.com>
 <20120506.163243.1653904376439925642.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120506.163243.1653904376439925642.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2012 at 04:32:43PM -0400, David Miller wrote:
> From: "H. Peter Anvin" <hpa@zytor.com>
> Date: Sun, 06 May 2012 11:48:15 -0700
> 
> > I would argue Sparc is not correct here but I am not a Sparc expert.
> 
> I can easily make sparc take on the x86 behavior if things like the
> input layer really need it.

BTW, in related area: take a look at syscall_get_arguments().  AFAICS,
it's rather odd -
#ifdef CONFIG_SPARC64
        if (test_tsk_thread_flag(task, TIF_32BIT))
                zero_extend = 1;
#endif
bit looks dubious.  What happens when 32bit task makes a 64bit syscall?
Do we really want to drop upper 32 bits of all arguments in the copy we
are building?

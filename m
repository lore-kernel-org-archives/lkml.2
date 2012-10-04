Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521Ab2JDRqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:46:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35426 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932214Ab2JDRq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:46:28 -0400
X-Sasl-enc: c0WjcmUD9KA3qLRBLG6oowzKjeQ1hPqtOMINLBs0M4aR 1349372788
Date: Thu, 4 Oct 2012 10:46:26 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Huacai Chen <chenhc@lemote.com>, Charles Wang <muming.wq@taobao.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Seems like "sched: Add missing call to calc_load_exit_idle()"
 should be reverted in 3.5 branch
Message-ID: <20121004174626.GB14301@kroah.com>
References: <CAAhV-H54CJdg+UekpucZ=kOgCY5r5vvYQ+v4VwAMTCv+mCedXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAhV-H54CJdg+UekpucZ=kOgCY5r5vvYQ+v4VwAMTCv+mCedXA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 12:11:01PM +0800, Huacai Chen wrote:
> Hi, Greg
> 
> I found that Linux-3.5.5 accept this commit "sched: Add missing call
> to calc_load_exit_idle()" but I think this isn't needed. Because
> "5167e8d5417b sched/nohz: Rewrite and fix load-avg computation --
> again not fully applied" is true for 3.6 branch, but not for 3.5
> branch.

But 5167e8d5417b is in 3.5, so shouldn't this commit still be necessary?

> In 3.5 branch, calc_load_exit_idle() is already called in
> tick_nohz_idle_exit(), it doesn't need to be called at
> tick_nohz_update_jiffies() again. In 3.6 branch, some code of
> tick_nohz_idle_exit() is splitted to tick_nohz_restart_sched_tick()
> and calc_load_exit_idle() is missing by accident, so commit "sched:
> Add missing call to calc_load_exit_idle()" is needed.

So this really should be dropped from 3.5?  Charles, Peter, Ingo, any
thoughts here?

thanks,

greg k-h

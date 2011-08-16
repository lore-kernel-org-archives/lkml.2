Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab1HPVvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 17:51:07 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:43510 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753107Ab1HPVvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 17:51:05 -0400
Subject: Re: [PATCH 41/41] exit: Use __set_task_blocked()
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110816180644.GJ29190@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
	 <1313071035-12047-42-git-send-email-matt@console-pimps.org>
	 <20110816180644.GJ29190@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Aug 2011 22:51:03 +0100
Message-ID: <1313531463.3436.219.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-16 at 20:06 +0200, Oleg Nesterov wrote:
> On 08/11, Matt Fleming wrote:
> >
> > As described in e6fa16ab ("signal: sigprocmask() should do
> > retarget_shared_pending()") the modification of current->blocked is
> > incorrect as we need to check whether the signal we're about to block
> > is pending in the shared queue.
> 
> Yes. but in this case the code is correct. First of all, unblocking
> is always fine. Also, this should be used by kthreads only, and they
> are single-threaded.
> 
> But there are other reasons why I don't like this change, even if we
> ignore the fact the patched exit.c can't be compiled (__set_task_blocked
> is not exported ;).

OK, I've dropped this patch from the series.

-- 
Matt Fleming, Intel Open Source Technology Center


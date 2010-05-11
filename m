Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab0EKB2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 21:28:05 -0400
Received: from mail.windriver.com ([147.11.1.11]:54663 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab0EKB2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 21:28:01 -0400
Date: Tue, 11 May 2010 09:27:56 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: May the worker function free its struct_work (plus container)?
Message-ID: <20100511012756.GB18062@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <AANLkTikTPkLID3e8HpT1jMeiF9tQ6-7oJWQBfiRF7xUN@mail.gmail.com>
 <20100510045252.GC3387@windriver.com>
 <AANLkTimOrMLWXV8L0V6LQuZLa4QO-adOlxNH190YyU6u@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTimOrMLWXV8L0V6LQuZLa4QO-adOlxNH190YyU6u@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 May 2010 01:27:58.0817 (UTC) FILETIME=[308D0D10:01CAF0A9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 12:18:38PM +0200, Leon Woestenberg wrote:
> Thanks. Is there API documentation or source code documentation that
> confirms this is the case?

static void run_workqueue(struct cpu_workqueue_struct *cwq)
{
	....

#ifdef CONFIG_LOCKDEP
		/*
		 * It is permissible to free the struct work_struct
		 * from inside the function that is called from it,
		 * this we need to take into account for lockdep too.
		 * To avoid bogus "held lock freed" warnings as well
		 * as problems when looking into work->lockdep_map,
		 * make a copy and use that here.
		 */
		struct lockdep_map lockdep_map = work->lockdep_map;
#endif
	....
}

I think the above comments in run_workqueue() can reflect that
from a certain point.

Thanks,
Yong

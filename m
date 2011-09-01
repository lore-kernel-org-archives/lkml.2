Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab1IAL5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 07:57:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:40740 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab1IAL46 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 07:56:58 -0400
Subject: Re: [PATCH 1/1] fs-writeback: Using spin_lock to check for
 work_list empty
From: Peter Zijlstra <peterz@infradead.org>
To: Rajan Aggarwal <rajan.aggarwal85@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 01 Sep 2011 13:56:54 +0200
In-Reply-To: <1314767509-17862-1-git-send-email-rajan.aggarwal85@gmail.com>
References: <1314767509-17862-1-git-send-email-rajan.aggarwal85@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314878214.11566.8.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-31 at 10:41 +0530, Rajan Aggarwal wrote:
> 
> If the list is not empty, and if an interrupt happens before we
> set the current->state to TASK_RUNNING then we could be stuck in
> a schedule() due to kernel preemption. 

No, look at PREEMPT_ACTIVE use in kernel/sched.c

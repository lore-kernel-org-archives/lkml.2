Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab2HMQcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:32:35 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:62895 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab2HMQce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:32:34 -0400
Date: Mon, 13 Aug 2012 09:32:19 -0700
From: Tejun Heo <tj@kernel.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] workqueue: change value of lcpu in
 queue_delayed_work_on()
Message-ID: <20120813163219.GA9180@google.com>
References: <Yes>
 <1344874672-6257-1-git-send-email-js1304@gmail.com>
 <1344874672-6257-2-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344874672-6257-2-git-send-email-js1304@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 14, 2012 at 01:17:49AM +0900, Joonsoo Kim wrote:
> We assign cpu id into work struct in queue_delayed_work_on().
> In current implementation, when work is come in first time,
> current running cpu id is assigned.
> If we do queue_delayed_work_on() with CPU A on CPU B,
> __queue_work() invoked in delayed_work_timer_fn() go into sub-optimal path
> in case of WQ_NON_REENTRANT.
> Change it to cpu argument is prevent to go into sub-optimal path.

Which part is suboptimal?  Also, what if @cpu is WQ_UNBOUND?

Thanks.

-- 
tejun

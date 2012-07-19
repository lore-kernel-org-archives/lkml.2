Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab2GSRHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 13:07:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37619 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2GSRHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 13:07:38 -0400
Date: Thu, 19 Jul 2012 10:07:34 -0700
From: Tejun Heo <tj@kernel.org>
To: Round Robinjp <roundrobinjp@yahoo.co.jp>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: workqueue and kworker
Message-ID: <20120719170734.GQ24336@google.com>
References: <877727.54297.qm@web100708.mail.kks.yahoo.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <877727.54297.qm@web100708.mail.kks.yahoo.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jul 20, 2012 at 01:01:34AM +0900, Round Robinjp wrote:
> It seems that even if you create a dedicated workqueue
> in your driver, it does not give you a dedicated
> kworker thread. Is this normal behaviour?

Yes.

> If so, then what is the difference between using
> generic workqueue and dedicated workqueue?

Please read Documentation/workqueue.txt.

> I need to set the priority of my kworker thread high
> (a specific value). For that I called sched_setscheduler()
> in my workqueue handler. But I found that other
> workqueues are also being executed on my high priority
> kworker thread which is unexpected.
> How do I give high priority to my kworker thread
> without affecting the behaviour of other workqueues?

If you want a dedicated worker thread, please use kthread_worker in
include/linux/kthread.h.  Or all you want is just higher nice value,
3.6 is reimplemnting WQ_HIGHPRI so that highpri tasks are executed w/
-20 nice value.

Thanks.

-- 
tejun

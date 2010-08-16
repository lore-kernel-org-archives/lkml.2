Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab0HPHrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 03:47:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:48732 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769Ab0HPHrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 03:47:46 -0400
Message-ID: <4C68EC76.70903@kernel.org>
Date: Mon, 16 Aug 2010 09:44:54 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Tao Ma <tao.ma@oracle.com>
CC: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH] CMWQ: Set workqueue name before we process one work.
References: <1281944355-4379-1-git-send-email-tao.ma@oracle.com>
In-Reply-To: <1281944355-4379-1-git-send-email-tao.ma@oracle.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 16 Aug 2010 07:47:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2010 09:39 AM, Tao Ma wrote:
> Now in CMWQ, workqueue threads are named as 'kworker/*'. So it is
> a little boring to see in the 'top'(below) and actually it isn't
> meaningful for the users.
> 12606 root      20   0     0    0    0 S    2  0.0   0:03.22 kworker/u:0
> 12607 root      20   0     0    0    0 S    1  0.0   0:03.69 kworker/u:4
> 
> So this patch just try to set the proper workqueue name if it does
> exist. Yes, workqueue now is a thread pool and the data may be not
> accurate but I think it is better(below) than the 'kworker*' stuff.
> And if there is something block the workqueue, we can find the caller
> easily.
> 12606 root      20   0     0    0    0 D    2  0.0   0:02.90 dlm_wq
> 12607 root      20   0     0    0    0 D    0  0.0   0:03.21 ocfs2_wq
> 
> What's more, in ocfs2, we sometimes want to print some debug info in
> the system log and we use 'current->comm' to print the thread and this
> change also does help.
> 
> The only thing I am not clear is that do we need [gs]et_task_comm?
> I guess not and this patch just try to use strlcpy without task_lock.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>

I thought about the same thing but this doesn't provide any more
information than stack traces for debugging and for run time tracking
implementing tracing API (scheduled to be added in this devel cycle)
is the right approach.  Also, I don't think it's wise to constantly
change program name.  It will confuse more than help.  So, unless
there are other reasons for doing this, I don't think I'm gonna take
this one.

Thanks.

-- 
tejun

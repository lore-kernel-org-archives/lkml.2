Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab1EREPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 00:15:21 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:46094 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab1EREPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 00:15:20 -0400
Subject: Re: [PATCH 0/3] v4 Improve task->comm locking situation
From: John Stultz <john.stultz@linaro.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: tytso@mit.edu, mina86@mina86.com, jirislaby@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, dave@linux.vne,
        linux-kernel@vger.kernel.org
In-Reply-To: <201105180316.p4I3G6f2094560@www262.sakura.ne.jp>
References: <1305580757-13175-1-git-send-email-john.stultz@linaro.org>
	 <201105180316.p4I3G6f2094560@www262.sakura.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 21:15:09 -0700
Message-ID: <1305692109.2915.139.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 12:16 +0900, Tetsuo Handa wrote:
> What about replacing
> 	char comm[TASK_COMM_LEN];
> with
> 	char *rcu_commname;
> and switching it atomically using RCU?

So I think this approach is definitely worth trying. However, I think
converting to RCU will be much easier once we've first converted all
current comm users to making use of the get_task_comm accessor
functions. In this way my hope is my current proposal will serve as a
cleanup step before further optimizations can be done.

thanks
-john



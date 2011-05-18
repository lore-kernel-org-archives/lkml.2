Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814Ab1ERELG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 00:11:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37650 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab1ERELF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 00:11:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DD346C4.5030200@jp.fujitsu.com>
Date: Wed, 18 May 2011 13:10:44 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: penguin-kernel@I-love.SAKURA.ne.jp
CC: john.stultz@linaro.org, tytso@mit.edu, mina86@mina86.com,
        jirislaby@gmail.com, rientjes@google.com, dave@linux.vne,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] v4 Improve task->comm locking situation
References: <1305580757-13175-1-git-send-email-john.stultz@linaro.org> <201105180316.p4I3G6f2094560@www262.sakura.ne.jp>
In-Reply-To: <201105180316.p4I3G6f2094560@www262.sakura.ne.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/18 12:16), Tetsuo Handa wrote:
> What about replacing
> 	char comm[TASK_COMM_LEN];
> with
> 	char *rcu_commname;
> and switching it atomically using RCU?
> 
> Advantages:
>    Readers can use RCU read lock rather than spinlock.
>    Makes task_struct smaller.
> 
> Disadvantages:
>    Need to allocate TASK_COMM_LEN bytes upon dup_task_struct() and set_task_comm().
>    Need to rewrite all task_struct.comm readers (steps shown below).
> 
> Steps to rewrite task_struct.comm readers
> 
> (1) Introduce a temporary accessor (say, task_comm).
> 
>      #define task_comm(tsk) (tsk)->comm
> 
> (2) Rewrite all tsk->comm users to task_comm(tsk).
> 
> (3) Replace sizeof(tsk->comm) with TASK_COMM_LEN.

The problem is, they aren't a few. But if you have a enough brave,
you can rewrite all. I'm not against it.





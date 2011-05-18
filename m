Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab1ERA2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 20:28:48 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54431 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab1ERA2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 20:28:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DD312B4.7060008@jp.fujitsu.com>
Date: Wed, 18 May 2011 09:28:36 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: john.stultz@linaro.org
CC: linux-kernel@vger.kernel.org, tytso@mit.edu, rientjes@google.com,
        dave@linux.vnet.ibm.com, akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] comm: Introduce comm_lock seqlock to protect task->comm
 access
References: <1305580757-13175-1-git-send-email-john.stultz@linaro.org> <1305580757-13175-2-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1305580757-13175-2-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/17 6:19), John Stultz wrote:
> The implicit rules for current->comm access being safe without locking
> are no longer true. Accessing current->comm without holding the task
> lock may result in null or incomplete strings (however, access won't
> run off the end of the string).
> 
> In order to properly fix this, I've introduced a comm_lock spinlock
> which will protect comm access and modified get_task_comm() and
> set_task_comm() to use it.
> 
> Since there are a number of cases where comm access is open-coded
> safely grabbing the task_lock(), we preserve the task locking in
> set_task_comm, so those users are also safe.
> 
> With this patch, users that access current->comm without a lock
> are still prone to null/incomplete comm strings, but it should
> be no worse then it is now.
> 
> The next step is to go through and convert all comm accesses to
> use get_task_comm(). This is substantial, but can be done bit by
> bit, reducing the race windows with each patch.
> 
> CC: Ted Ts'o<tytso@mit.edu>
> CC: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> CC: David Rientjes<rientjes@google.com>
> CC: Dave Hansen<dave@linux.vnet.ibm.com>
> CC: Andrew Morton<akpm@linux-foundation.org>
> CC: linux-mm@kvack.org
> Acked-by: David Rientjes<rientjes@google.com>
> Signed-off-by: John Stultz<john.stultz@linaro.org>

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




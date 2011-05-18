Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab1ERAcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 20:32:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58888 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab1ERAcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 20:32:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DD31397.1090603@jp.fujitsu.com>
Date: Wed, 18 May 2011 09:32:23 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: john.stultz@linaro.org
CC: linux-kernel@vger.kernel.org, tytso@mit.edu, rientjes@google.com,
        dave@linux.vnet.ibm.com, akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] printk: Add %ptc to safely print a task's comm
References: <1305580757-13175-1-git-send-email-john.stultz@linaro.org> <1305580757-13175-3-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1305580757-13175-3-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/17 6:19), John Stultz wrote:
> Accessing task->comm requires proper locking. However in the past
> access to current->comm could be done without locking. This
> is no longer the case, so all comm access needs to be done
> while holding the comm_lock.
> 
> In my attempt to clean up unprotected comm access, I've noticed
> most comm access is done for printk output. To simplify correct
> locking in these cases, I've introduced a new %ptc format,
> which will print the corresponding task's comm.
> 
> Example use:
> printk("%ptc: unaligned epc - sending SIGBUS.\n", current);
> 
> CC: Ted Ts'o<tytso@mit.edu>
> CC: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> CC: David Rientjes<rientjes@google.com>
> CC: Dave Hansen<dave@linux.vnet.ibm.com>
> CC: Andrew Morton<akpm@linux-foundation.org>
> CC: linux-mm@kvack.org
> Signed-off-by: John Stultz<john.stultz@linaro.org>

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




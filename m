Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab0K2Nzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 08:55:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:34012 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab0K2Nzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 08:55:38 -0500
Message-ID: <4CF3B0C8.7080200@kernel.org>
Date: Mon, 29 Nov 2010 14:55:20 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "@sisk.plpavel@ucw.cz"@htj.dyndns.org,
        "Jan Kratochvil \"" <jan.kratochvil@redhat.com>
Subject: Re: [PATCH 14/14] ptrace: remove the extra wake_up_process() from
 ptrace_detach()
References: <1290768569-16224-1-git-send-email-tj@kernel.org> <1290768569-16224-15-git-send-email-tj@kernel.org> <20101128204435.GE12896@redhat.com>
In-Reply-To: <20101128204435.GE12896@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 29 Nov 2010 13:55:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/28/2010 09:44 PM, Oleg Nesterov wrote:
> Today I lost the concentration at 13/14 ;)
> 
> Will continue tomorrow. As for this patch,

Eh, well, you've already found enough holes in the patchset.  It's
like a swiss cheese.  I'll update and repost.

> On 11/26, Tejun Heo wrote:
>>
>> This wake_up_process() has a turbulent history.  This is a remnant
>> from ancient ptrace implementation and patently wrong.  Commit
>> 95a3540d (ptrace_detach: the wrong wakeup breaks the ERESTARTxxx
>> logic) removed it
> 
> Yes. This obviously means I personally like this change. In fact,
> I never understood this wakeup, and I was glad to find the reason
> to send the patch.

Another thing is that the use of wake_up_process() in ptrace is rather
scary even in ptrace_resume().  It will wake up even uninterruptible
sleeps.  Is there any reason it's not just waking up
TASK_INTERRUPTIBLE | STOPPED | TRACED?

Thanks.

-- 
tejun

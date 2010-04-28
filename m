Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122Ab0D1HT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 03:19:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:38865 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab0D1HTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 03:19:25 -0400
Message-ID: <4BD7E144.6050608@kernel.org>
Date: Wed, 28 Apr 2010 09:18:28 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
CC: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>, Oleg Nesterov <oleg@redhat.com>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 6/8] PM: Add suspend blocking work.
References: <1272429119-12103-1-git-send-email-arve@android.com>	 <1272429119-12103-2-git-send-email-arve@android.com>	 <1272429119-12103-3-git-send-email-arve@android.com>	 <1272429119-12103-4-git-send-email-arve@android.com>	 <1272429119-12103-5-git-send-email-arve@android.com>	 <1272429119-12103-6-git-send-email-arve@android.com>	 <1272429119-12103-7-git-send-email-arve@android.com>	 <4BD7D948.4080406@kernel.org> <i2vd6200be21004280002tde778c02h1586b4c06de2a89a@mail.gmail.com>
In-Reply-To: <i2vd6200be21004280002tde778c02h1586b4c06de2a89a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 28 Apr 2010 07:18:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/28/2010 09:02 AM, Arve Hjønnevåg wrote:
>> Maybe work->active can be an atomic_t and the lock can be removed?
> 
> I need the spinlock to prevent the work from getting re-queued before
> suspend_unblock.

OIC.

> I'm not sure what the best terminology is here, but cancel_work_sync()
> only waits for work running on all the cpu-workqueues of the last
> workqueue. So, if the caller queued the work on more than one
> workqueue, suspend_blocking_work_destroy does not ensure that the
> suspend_blocking_work structure is not still in use (it should trigger
> the WARN_ON though).

Right, I was thinking about different cpu_workqueues and yeah, the
terminology gets pretty confusing.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

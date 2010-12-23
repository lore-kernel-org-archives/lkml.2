Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab0LWCLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 21:11:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53723 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab0LWCLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 21:11:50 -0500
Message-ID: <4D12B04A.3030705@cn.fujitsu.com>
Date: Thu, 23 Dec 2010 10:13:30 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <peterz@infradead.org>, John Kacur <jkacur@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] plist: shrink struct plist_head
References: <4D107982.9090700@cn.fujitsu.com>
In-Reply-To: <4D107982.9090700@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-23 10:11:40,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-23 10:11:41,
	Serialize complete at 2010-12-23 10:11:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2010 05:55 PM, Lai Jiangshan wrote:
> struct plist_head is big, and the field prio_list
> in the struct plist_head is used seldom. So it can be
> removed and we use the first plist_node's prio_list
> when needed.
> 
> The size of struct plist_head is decreased a half after shinked.
> The size of struct rtmutex and struct task_struct are
> also decreased after struct plist_head shrinked.
> 
> Signed-off-by:  Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  include/linux/plist.h |   47 ++++++++++++++++++++++---------------------
>  lib/plist.c           |   54 ++++++++++++++++++++++++++++++++------------------
>  2 files changed, 59 insertions(+), 42 deletions(-)
> 

Hi, Ingo, Thomas, Steven,

Any comments about this patch?

Thanks,
Lai

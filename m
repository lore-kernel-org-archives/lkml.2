Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934212Ab0D3S6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:58:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:60359 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757340Ab0D3RE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:04:27 -0400
Message-ID: <4BDA700C.3050509@kernel.org>
Date: Fri, 30 Apr 2010 07:52:12 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
CC: Oleg Nesterov <oleg@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 2/2] workqueues: export keventd_wq
References: <1272429119-12103-1-git-send-email-arve@android.com>	 <20100428194028.GA16389@redhat.com> <4BD89922.1040306@kernel.org>	 <201004282308.10751.rjw@sisk.pl> <20100429185851.GA13862@redhat.com>	 <20100429194447.GA17280@redhat.com>	 <20100429194545.GC17280@redhat.com> <4BDA67C1.7050709@kernel.org> <t2gd6200be21004292239r582b8a43l2409491b8d32ef1b@mail.gmail.com>
In-Reply-To: <t2gd6200be21004292239r582b8a43l2409491b8d32ef1b@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 30 Apr 2010 05:52:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2010 07:39 AM, Arve Hjønnevåg wrote:
> On Thu, Apr 29, 2010 at 10:16 PM, Tejun Heo <tj@kernel.org> wrote:
>> Hello,
>>
>> On 04/29/2010 09:45 PM, Oleg Nesterov wrote:
>>> -static struct workqueue_struct *keventd_wq __read_mostly;
>>> +struct workqueue_struct *keventd_wq __read_mostly;
>>> +EXPORT_SYMBOL(keventd_wq);
>>
>> Umm... does it have to be EXPORTed?  Suspend block API can't be built
>> as a module, right?
> 
> The suspend block api cannot be built as a module, but if
> schedule_suspend_blocking_work will just call
> queue_suspend_blocking_work(keventd_wq, work) it may as well be an
> inline function which would require the export.

I think it would be better to keep the thing inside the kernel, at
least for now.  It's not like we need to save cpu cycles spent on a
function call here (in block suspend API and in workqueue general).

Thanks.

-- 
tejun

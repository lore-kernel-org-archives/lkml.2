Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab0D3RLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:11:23 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:64703 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758558Ab0D3RLH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:11:07 -0400
MIME-Version: 1.0
In-Reply-To: <4BDA67C1.7050709@kernel.org>
References: <1272429119-12103-1-git-send-email-arve@android.com>
	 <20100428194028.GA16389@redhat.com> <4BD89922.1040306@kernel.org>
	 <201004282308.10751.rjw@sisk.pl> <20100429185851.GA13862@redhat.com>
	 <20100429194447.GA17280@redhat.com>
	 <20100429194545.GC17280@redhat.com> <4BDA67C1.7050709@kernel.org>
Date: Thu, 29 Apr 2010 22:39:02 -0700
Message-ID: <t2gd6200be21004292239r582b8a43l2409491b8d32ef1b@mail.gmail.com>
Subject: Re: [PATCH 2/2] workqueues: export keventd_wq
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 10:16 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On 04/29/2010 09:45 PM, Oleg Nesterov wrote:
>> -static struct workqueue_struct *keventd_wq __read_mostly;
>> +struct workqueue_struct *keventd_wq __read_mostly;
>> +EXPORT_SYMBOL(keventd_wq);
>
> Umm... does it have to be EXPORTed?  Suspend block API can't be built
> as a module, right?

The suspend block api cannot be built as a module, but if
schedule_suspend_blocking_work will just call
queue_suspend_blocking_work(keventd_wq, work) it may as well be an
inline function which would require the export.

-- 
Arve Hjønnevåg

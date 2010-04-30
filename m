Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745Ab0D3Ra1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:30:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932952Ab0D3R3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:29:54 -0400
Date: Fri, 30 Apr 2010 19:26:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100430172618.GA9043@redhat.com>
References: <1272429119-12103-1-git-send-email-arve@android.com> <201004282250.44200.rjw@sisk.pl> <l2yd6200be21004282037rc063266by91db7f732ceaa529@mail.gmail.com> <201004292316.14524.rjw@sisk.pl> <4BDA5B8B.50004@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BDA5B8B.50004@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30, Tejun Heo wrote:
>
> On 04/29/2010 11:16 PM, Rafael J. Wysocki wrote:
> >>> Also, we already have one PM workqueue.  It is used for runtime PM, but I guess
> >>> it may be used just as well for the opportunistic suspend.  It is freezable,
> >>> but would it hurt?
> >>
> > Freezable workqueues have to be singlethread or else there will be unfixable
> > races, so you can safely assume things will stay as they are in this respect.
>
> Rafael, can you elaborate a bit more on this?  Just in case I missed
> something while doing cmwq as it currently doesn't have such limit.

Currently _cpu_down() can't flush and/or stop the frozen cwq->thread.

IIRC this is fixable, but needs the nasty complications. We should
thaw + stop the frozen cwq->thread, then move the pending works to
another CPU.

Oleg.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab0HTCAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 22:00:42 -0400
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:43771 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab0HTCAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 22:00:39 -0400
Date: Thu, 19 Aug 2010 22:00:27 -0400
From: Nick Orlov <bugfixer@list.ru>
Subject: Re: 2.6.34.4: BUG: sleeping function called from invalid context at
 mm/rmap.c:119
In-reply-to: <20100818003802.GA3555@nickolas.homeunix.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Mail-followup-to: linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <20100820020027.GA3062@nickolas.homeunix.com>
MIME-version: 1.0
Content-type: text/plain; charset=koi8-r
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <20100818003802.GA3555@nickolas.homeunix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 08:38:02PM -0400, Nick Orlov wrote:
> All,
> 
> Starting with 2.6.34.4 I'm getting bunch of
> 
> Aug 15 19:00:01 xxx kernel: Freeing unused kernel memory: 1636k freed
> Aug 15 19:00:01 xxx kernel: BUG: sleeping function called from invalid
> context at mm/rmap.c:119
> Aug 15 19:00:01 xxx kernel: in_atomic(): 1, irqs_disabled(): 0, pid: 1,
> name: swapper
> Aug 15 19:00:01 xxx kernel: 1 lock held by swapper/1:
> Aug 15 19:00:01 xxx kernel:  #0:  (&p->cred_guard_mutex){+.+.+.}, at:
> [<c10abf05>] prepare_bprm_creds+0x25/0x70
> Aug 15 19:00:01 xxx kernel: Pid: 1, comm: swapper Not tainted
> 2.6.34.4-1.swp #1
> Aug 15 19:00:01 xxx kernel: Call Trace:
> Aug 15 19:00:01 xxx kernel:  [<c12c7e84>] ? printk+0x18/0x1c
> Aug 15 19:00:01 xxx kernel:  [<c102a419>] __might_sleep+0x109/0x130
> Aug 15 19:00:01 xxx kernel:  [<c109a705>] anon_vma_prepare+0x25/0x130
> Aug 15 19:00:01 xxx kernel:  [<c105ad85>] ?
> lock_release_holdtime+0xa5/0x1a0
> Aug 15 19:00:01 xxx kernel:  [<c1096228>] expand_downwards+0x18/0x180
> Aug 15 19:00:01 xxx kernel:  [<c1022f5c>] ? kmap_atomic_prot+0x7c/0xe0
> Aug 15 19:00:01 xxx kernel:  [<c1096398>] expand_stack+0x8/0x10
> Aug 15 19:00:01 xxx kernel:  [<c109303a>] handle_mm_fault+0x80a/0x840
> Aug 15 19:00:01 xxx kernel:  [<c109318a>] __get_user_pages+0x11a/0x370

[[ skipped ]]

> 
> I'm actually surprised noone have reported it yet ....

Sincere apologies, I should have done my homework better ...

> Is it a known issue? Is there a patch I can try?

I'd like to confirm first patch queued for 2.6.34.5 (aka
11ac552477e32835cb6970bf0a70c210807f5673) does the trick for me too

-- 
With best wishes,
	Nick Orlov.


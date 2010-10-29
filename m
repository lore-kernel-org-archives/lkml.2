Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934113Ab0J2QHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 12:07:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34560 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932898Ab0J2QHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 12:07:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:references:date:in-reply-to:message-id:
	user-agent:mime-version:content-type;
	b=NNQfLlUxXQzQFnxplG6NtmmlKwoUM4sBuqNyBdYbF1lac92btcH/oy/PTR451djgu
	KpgmFRH7XwnE/jknl6Q5w==
From: Greg Thelen <gthelen@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH v4 11/11] memcg: check memcg dirty limits in page writeback
References: <1288336154-23256-1-git-send-email-gthelen@google.com>
	<1288336154-23256-12-git-send-email-gthelen@google.com>
	<20101029164835.06eef3cf.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 29 Oct 2010 09:06:33 -0700
In-Reply-To: <20101029164835.06eef3cf.kamezawa.hiroyu@jp.fujitsu.com>
	(KAMEZAWA Hiroyuki's message of "Fri, 29 Oct 2010 16:48:35 +0900")
Message-ID: <xr93eib9nfue.fsf@ninji.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> On Fri, 29 Oct 2010 00:09:14 -0700
> Greg Thelen <gthelen@google.com> wrote:
>
>> If the current process is in a non-root memcg, then
>> balance_dirty_pages() will consider the memcg dirty limits
>> as well as the system-wide limits.  This allows different
>> cgroups to have distinct dirty limits which trigger direct
>> and background writeback at different levels.
>> 
>> Signed-off-by: Andrea Righi <arighi@develer.com>
>> Signed-off-by: Greg Thelen <gthelen@google.com>
>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> Ideally, I think some comments in the code for "why we need double-check system's
> dirty limit and memcg's dirty limit" will be appreciated.

I will add to the balance_dirty_pages() comment.  It will read:
/*
 * balance_dirty_pages() must be called by processes which are generating dirty
 * data.  It looks at the number of dirty pages in the machine and will force
 * the caller to perform writeback if the system is over `vm_dirty_ratio'.
 * If we're over `background_thresh' then the writeback threads are woken to
 * perform some writeout.  The current task may have per-memcg dirty
 * limits, which are also checked.
 */

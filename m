Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340Ab2KEV4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 16:56:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933223Ab2KEV4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 16:56:30 -0500
Date: Mon, 5 Nov 2012 13:56:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Tony Luck <tony.luck@intel.com>, Andi Kleen <andi.kleen@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2 v2] HWPOISON: fix action_result() to print out
 dirty/clean
Message-Id: <20121105135628.db79602c.akpm@linux-foundation.org>
In-Reply-To: <1351873993-9373-2-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1351873993-9373-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1351873993-9373-2-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Nov 2012 12:33:12 -0400
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> action_result() fails to print out "dirty" even if an error occurred on a
> dirty pagecache, because when we check PageDirty in action_result() it was
> cleared after page isolation even if it's dirty before error handling. This
> can break some applications that monitor this message, so should be fixed.
> 
> There are several callers of action_result() except page_action(), but
> either of them are not for LRU pages but for free pages or kernel pages,
> so we don't have to consider dirty or not for them.
> 
> Note that PG_dirty can be set outside page locks as described in commit
> 554940dc8c1e, so this patch does not completely closes the race window,
> but just narrows it.

I can find no commit 554940dc8c1e.  What commit are you referring to here?

This is one of the reasons why we ask people to refer to commits by
both hash and by name, using the form

078de5f706ece3 ("userns: Store uid and gid values in struct cred with
kuid_t and kgid_t types")

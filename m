Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab2KFWwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 17:52:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39823 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab2KFWwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 17:52:22 -0500
Date: Tue, 6 Nov 2012 14:52:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Tony Luck <tony.luck@intel.com>, Andi Kleen <andi.kleen@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2 v2] mm: print out information of file affected by
 memory error
Message-Id: <20121106145220.52a52829.akpm@linux-foundation.org>
In-Reply-To: <1352241905-4657-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <20121106121220.d14696ac.akpm@linux-foundation.org>
	<1352241905-4657-1-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  6 Nov 2012 17:45:05 -0500
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> > "should be" and "unlikely" aren't very reassuring things to hear! 
> > Emitting a million lines into syslog is pretty poor behaviour and
> > should be reliably avoided.
> 
> So capping maximum lines of messages per some duration (a hour or a day)
> is a possible option. BTW, even if we don't apply this patch, the kernel
> can emit million lines of messages in the above-mentioned situation because
> each memory error event emits a message like "MCE 0x3f57f4: dirty LRU page
> recovery: Ignored" on syslog. If it's also bad, we need to do capping
> also over existing printk()s, right?

Yes, that sounds like a bug report waiting to happen.

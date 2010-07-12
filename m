Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab0GLWXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 18:23:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755272Ab0GLWXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 18:23:49 -0400
Date: Mon, 12 Jul 2010 15:22:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        Martin Bligh <mbligh@google.com>, Michael Rubin <mrubin@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] writeback: merge for_kupdate and !for_kupdate cases
Message-Id: <20100712152254.2071ba5f.akpm@linux-foundation.org>
In-Reply-To: <20100712155239.GC30222@localhost>
References: <20100711020656.340075560@intel.com>
	<20100711021749.303817848@intel.com>
	<20100712020842.GC25335@dastard>
	<20100712155239.GC30222@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010 23:52:39 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> > Also, I'd prefer that the
> > comments remain somewhat more descriptive of the circumstances that
> > we are operating under. Comments like "retry later to avoid blocking
> > writeback of other inodes" is far, far better than "retry later"
> > because it has "why" component that explains the reason for the
> > logic. You may remember why, but I sure won't in a few months time....

me2 (of course).  This code is waaaay too complex to be scrimping on comments.

> Ah yes the comment is too simple. However the redirty_tail() is not to
> avoid blocking writeback of other inodes, but to avoid eating 100% CPU
> on busy retrying a dirty inode/page that cannot perform writeback for
> a while. (In theory redirty_tail() can still busy retry though, when
> there is only one single dirty inode.) So how about
> 
>         /*
>          * somehow blocked: avoid busy retrying
>          */

That's much too short.  Expand on the "somehow" - provide an example,
describe the common/expected cause.  Fully explain what the "busy"
retry _is_ and how it can come about.


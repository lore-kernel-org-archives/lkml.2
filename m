Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab2IXS2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 14:28:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44926 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247Ab2IXS2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 14:28:41 -0400
Date: Mon, 24 Sep 2012 11:28:37 -0700
From: Tejun Heo <tj@kernel.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Dubov <oakad@yahoo.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memstick: add support for legacy memorysticks
Message-ID: <20120924182837.GI7694@google.com>
References: <1348060743-6295-1-git-send-email-maximlevitsky@gmail.com>
 <1348060743-6295-2-git-send-email-maximlevitsky@gmail.com>
 <20120919145228.80f72f59.akpm@linux-foundation.org>
 <1348113942.16096.18.camel@maxim-laptop>
 <20120920175340.GE28934@google.com>
 <1348498747.618.4.camel@maxim-laptop>
 <1348499363.618.6.camel@maxim-laptop>
 <20120924180516.GF7694@google.com>
 <1348510768.618.16.camel@maxim-laptop>
 <1348511077.618.19.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348511077.618.19.camel@maxim-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Sep 24, 2012 at 08:24:37PM +0200, Maxim Levitsky wrote:
> Should have looked through the source. Understand now.
> Just one quick question, should I create my own workqueue or use
> schedule_work? if I use the later and my work function sleeps, will it
> harmfully affect other users of this function?

If memstick can be in memory reclaim path (most block devices are),
you would want to create a dedicated workqueue w/ rescuer.  For
details, please read Documentation/workqueue.txt.

Thanks.

-- 
tejun

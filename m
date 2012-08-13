Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab2HMXhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 19:37:33 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44137 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750Ab2HMXhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 19:37:32 -0400
Date: Mon, 13 Aug 2012 16:37:27 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mingo@redhat.com, akpm@linux-foundation.org,
        tglx@linutronix.de, peterz@infradead.org, davem@davemloft.net,
        tomi.valkeinen@ti.com
Subject: Re: [PATCHSET] workqueue: use irqsafe timer in delayed_work
Message-ID: <20120813233727.GH25632@google.com>
References: <1344461882-10149-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344461882-10149-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Aug 08, 2012 at 02:37:55PM -0700, Tejun Heo wrote:
> This patchset makes delayed_work use the irqsafe timer added by the
> pending "timer: clean up initializers and implement irqsafe timers"
> patchset[1].  This enables try_to_grab_pending() to be used from any
> context which in turn makes mod_delayed_work() usable from IRQ
> handlers.  cancel_delayed_work() is reimplemented using
> try_to_grab_pending() so that it also can be used from IRQ handlers
> and its behavior is consitent with other canceling operations.
> __cancel_delayed_work() is no longer necessary and deprecated.

I'll soon push this to linux-next through wq/for-3.7 together with
irqsafe timer patchset.  Plese scream if you don't like that.

Thanks.

-- 
tejun

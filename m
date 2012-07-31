Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab2GaRLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 13:11:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63847 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab2GaRLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 13:11:51 -0400
Date: Tue, 31 Jul 2012 10:11:46 -0700
From: Tejun Heo <tj@kernel.org>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, padovan@profusion.mobi, marcel@holtmann.org,
        peterz@infradead.org, mingo@redhat.com, davem@davemloft.net,
        dougthompson@xmission.com, ibm-acpi@hmh.eng.br, cbou@mail.ru,
        rui.zhang@intel.com, Jens Axboe <axboe@kernel.dk>,
        Jiri Kosina <jkosina@suse.cz>, Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH 15/15] workqueue: deprecate __cancel_delayed_work()
Message-ID: <20120731171146.GA21292@google.com>
References: <1343433308-26614-1-git-send-email-tj@kernel.org>
 <1343433308-26614-16-git-send-email-tj@kernel.org>
 <1343739939.2633.34.camel@deskari>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343739939.2633.34.camel@deskari>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 04:05:39PM +0300, Tomi Valkeinen wrote:
> > Use cancel_delayed_work() instead of __cancel_delayed_work() and mark
> > the latter deprecated.
> 
> I used __cancel_delayed_work() in drivers/video/omap2/dss/dsi.c as the
> cancel is done in an interrupt handler. Is it safe to use
> cancel_delayed_work() in atomic context? I presume not, as it uses
> del_timer_sync().

Ah, you're right.  __cancel_delayed_work() invoked from irq context
can't be converted to cancel_delayed_work() or mod_delayed_work().
I'll skip those from the previous patch and drop this patch.  I really
hope this could be solved somehow tho.  :(

Thank you.

-- 
tejun

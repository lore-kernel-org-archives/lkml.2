Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab2DYFJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 01:09:27 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:55451 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab2DYFJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 01:09:24 -0400
Date: Tue, 24 Apr 2012 22:09:19 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: twl4030 power button: don't lose presses on resume
Message-ID: <20120425050919.GB27843@core.coreip.homeip.net>
References: <20120425122139.512c6890@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425122139.512c6890@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On Wed, Apr 25, 2012 at 12:21:39PM +1000, NeilBrown wrote:
> 
> If we press and release the power button before the press interrupt is
> handled - as can happen on resume - we lose the press event so the
> release event is ignored and we don't know what happened to cause the
> wakeup.

What kind of latency do you observe?

> 
> So make sure that each interrupt handled does generate an event.
> Because twl4030 queues interrupt events we will see two interrupts
> for a press-release even if we handle the first one later.  This means
> that such a sequence will be reported as two button presses.  This
> is unfortunate but is better than no button presses.
> Possibly we could set the PENDDIS_MASK to disable queuing of
> interrupts, but that might adversely affect other interrupt sources.
>

It looks like we'd have to modify every driver to ensure consistent
behavior as we do not have any guarantees on how long resume takes.
Maybe this is something that input core needs to implement?

Thanks.


-- 
Dmitry

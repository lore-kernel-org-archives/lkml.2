Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab1FCKXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 06:23:37 -0400
Received: from mail4.comsite.net ([205.238.176.238]:60118 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1FCKXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 06:23:35 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Stefan Bigler <stefan.bigler@keymile.com>,
        Toby Gray <toby.gray@realvnc.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: tty breakage in X (Was: tty vs workqueue oddities)
Date: Fri, 03 Jun 2011 05:23:12 -0500
X-Originating-IP: 71.22.127.106
Message-ID: <1307096592_10534@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[not on list so made up cc list]

On Fri Jun 03 2011 about 05:37:52 EST, Linus wrote:
> On Fri, Jun 3, 2011 at 3:56 PM, Benjamin Herrenschmidt wrote:
> > So I think my theory stands that flush_to_ldisc constantly reschedule
> > itself causing the worker thread to eat all CPU and starve the consumer
> > of the PTY. I won't have time to dig much deeper today nor probably this
> > week-end so I'm sending this email for others who want to look.
> 
> Gaah - that commit is total and utter crap.
> 
> I *removed* the whole "reschedule the work queue again" crap. It was
> totally wrong. See commit a5660b41af6a.
> 
> But then commit b1c43f82c5aa added the crap right back in.
> 
> So does it all work if you just remove the broken schedule_work() line
> from flush_to_ldisc?
> 
> Otherwise we'll need to just revert it. The commit is clearly totally broken.

Its further broken in that the recieve_buf functions return -ERRORS
but the callers don't check for negative values.

milton

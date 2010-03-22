Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab0CVD3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 23:29:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39510 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab0CVD3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 23:29:11 -0400
To: "Zhu, Yijun (NSN - CN/Beijing)" <yijun.zhu@nsn.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Subject: Re: Questions about SMP bootup control
From: Andi Kleen <andi@firstfloor.org>
References: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
	<1269155601-18247-7-git-send-email-yinghai@kernel.org>
	<1269225435.8599.70.camel@pasglop>
	<2234BBB33B4B2048B28E3B3ACFC9795C01B53251@CNBEEXC007.nsn-intra.net>
Date: Mon, 22 Mar 2010 04:29:05 +0100
In-Reply-To: <2234BBB33B4B2048B28E3B3ACFC9795C01B53251@CNBEEXC007.nsn-intra.net> (Yijun Zhu's message of "Mon, 22 Mar 2010 10:46:32 +0800")
Message-ID: <87tys9dofy.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Zhu, Yijun (NSN - CN/Beijing)" <yijun.zhu@nsn.com> writes:

> Hi All:
>
> I want to do some modification on the SMP architecture.
>
> Purpose:
> Only the first CPU is running the linux OS, while others do some private
> services processing.
>
> My solution:
> In the end of the start_secondary() function, I try to schedu the slave
> cpu to call my private endless loop instead of cpu_idle();
>
> Result:
> The system can NOT up, there is no interactive cli.
>
> Question:
> Is there some wrong with my modification or I go to the wrong way?

Presumably you're doing this to own that CPU exclusively.

Hooking at cpu_idle is not very useful then because interrupts will be
already enabled and the system participate in IPIs etc, so you can't
simply disable them, the others will miss them.

You would rather need to prevent them from being started in the
first place, e.g. by exluding them with maxcpus=..

A better alternative might be to use isolcpus=... and schedule
a standard program.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

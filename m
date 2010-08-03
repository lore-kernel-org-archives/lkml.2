Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab0HCIIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:08:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41861 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab0HCIII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:08:08 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: CPU Hotplug add/remove optimizations
References: <4C5742FE.5040907@codeaurora.org>
Date: Tue, 03 Aug 2010 10:07:58 +0200
In-Reply-To: <4C5742FE.5040907@codeaurora.org> (Rohit Vaswani's message of
	"Mon, 02 Aug 2010 15:13:18 -0700")
Message-ID: <87y6codspt.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rohit Vaswani <rvaswani@codeaurora.org> writes:

>  Hi,
>
> We are trying to use cpu hotplug to turn off a cpu when it is not in
> use to improve power management.

It might not be a big issue on smaller systems, but CPU hotunplug
involves stop_machine() and that is a very costly thing
to do as systems become larger.


> I am trying to optimize the cpu
> hotplug add and cpu hotplug remove timings. Currently cpu hotplug add
> takes around 250ms and cpu hotplug remove takes 190 ms. For the
> current purposes we want to assume that we are removing and adding the
> same core. It seems that since we are actually not replacing the core
> – there could be a lot of initialization overhead that could be
> saved and restored instead of calibrating the entire core again.
> One such thing we have been looking at is that once a core is powered
> up during cpu hotplug add, it runs the calibrate_delay routine to
> calculate the value of loops_per_jiffy. In such a case could we bypass
> the calibrate_delay function and just save and restore the value of
> loops_per_jiffy?
> Does this approach seem wrong to anyone?

It's wrong on a system that supports socket hotplug. The CPU you're
power up again might not be the same.

In theory you could have some low level interface that distingushes
these two cases, but right now that's not there.

> Can we safely assume that the core will start at the same clock speed
> at which the value was stored and then restored?

That neither.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

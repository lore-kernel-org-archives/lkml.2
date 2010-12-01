Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab0LAL2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 06:28:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:58156 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab0LAL2U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 06:28:20 -0500
Subject: Re: perf hw  in kexeced kernel broken in tip
From: Peter Zijlstra <peterz@infradead.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Wessel <jason.wessel@windriver.com>,
        Don Zickus <dzickus@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>
In-Reply-To: <4CF60095.1020900@kernel.org>
References: <4CF60095.1020900@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Dec 2010 12:27:47 +0100
Message-ID: <1291202867.4023.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 00:00 -0800, Yinghai Lu wrote:
> First kernel:
> [    1.139418] calling  init_hw_perf_events+0x0/0xb77 @ 1
> [    1.159111] Performance Events: PEBS fmt1+, Nehalem events, Intel PMU
> driver.
> [    1.159567] ... version:                3
> [    1.179121] ... bit width:              48
> [    1.179353] ... generic registers:      4
> [    1.179593] ... value mask:             0000ffffffffffff
> [    1.199211] ... max period:             000000007fffffff
> [    1.199554] ... fixed-purpose events:   3
> [    1.219108] ... event mask:             000000070000000f
> [    1.219454] initcall init_hw_perf_events+0x0/0xb77 returned 0 after
> 11719 usecs
> 
> .....
> [   20.220997] checking TSC synchronization [CPU#0 -> CPU#11]: passed.
> [   20.260818] NMI watchdog enabled, takes one hw-pmu counter.
> 
> kexeced kernel.
> 
> 
> [    1.169470] calling  init_hw_perf_events+0x0/0xb77 @ 1
> [    1.189265] Performance Events: PEBS fmt1+, Nehalem events, Broken
> PMU hardware detected, software events only.
> ...
> [   21.010407] NMI watchdog failed to create perf event on cpu14:
> fffffffffffffffe
> 
> caused by:

*sigh*, and people ask me why kexec/kdump are such bad ideas..

apparently kexec doesn't properly shut down the first kernel and leaves
a counter running, then when we write and read the counter value they
don't match because its still running and voila, crap happens.

I've CC'ed the kexec people, maybe they got clue as to how to sort this.



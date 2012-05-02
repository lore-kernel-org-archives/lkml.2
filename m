Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab2EBAJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 20:09:22 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:37492 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab2EBAJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 20:09:20 -0400
Message-ID: <4FA07B27.70501@gmail.com>
Date: Tue, 01 May 2012 20:09:11 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ulrich Drepper <drepper@akkadia.org>
CC: arnd@arndb.de, davem@davemloft.net, hch@infradead.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        mchehab@redhat.com, kosaki.motohiro@gmail.com
Subject: Re: [PATCH] [RESEND] Install kernel-page-flags.h
References: <201204291404.q3TE4vfN023826@drepperk.user.openhosting.com>
In-Reply-To: <201204291404.q3TE4vfN023826@drepperk.user.openhosting.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/29/12 10:04 AM), Ulrich Drepper wrote:
> No one has definitely commented on this patch nor is it applied.  Christoph at first said it shouldn't be done but I think he had to retract his objection.  The interface is already out there.  It's also IMO the right choice to go with a binary interface since there is so much data involved and the format is not tied directly to kernel-internal data structures.
> 
> Could either the patch please be applied or a reason given why not?
> 
> 
> Signed-off-by: Ulrich Drepper<drepper@gmail.com>
> 

linux/Documentation/vm/page-type.c has redundant definition of KPF_*. then, this exporting will solve it.
I'm going to ack if you can fix two things.
 1) your current changelog looks like a chat log style. Please write formal changelog.
 2) Please fix page-type.c too.

and pelase cc Wu Fengguang <fengguang.wu@intel.com>. His last commit explicitly says kernel-page-flags.h
was intentionally made for user space tools. see below.


commit 1a9b5b7fe0c5dad8a635288882d36785dea742f9
Author: Wu Fengguang <fengguang.wu@intel.com>
Date:   Wed Dec 16 12:19:59 2009 +0100

    mm: export stable page flags
    
    Rename get_uflags() to stable_page_flags() and make it a global function
    for use in the hwpoison page flags filter, which need to compare user
    page flags with the value provided by user space.
    
    Also move KPF_* to kernel-page-flags.h for use by user space tools.
    
    Acked-by: Matt Mackall <mpm@selenic.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    CC: Nick Piggin <npiggin@suse.de>
    CC: Christoph Lameter <cl@linux-foundation.org>
    Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>


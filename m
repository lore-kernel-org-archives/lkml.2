Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab1GTTME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:12:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:33402 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab1GTTMC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:12:02 -0400
Subject: Re: sched: fix/optimise some issues
From: Peter Zijlstra <peterz@infradead.org>
To: stephan.baerwolf@tu-ilmenau.de
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        ncrao@google.com
In-Reply-To: <4E26DB41.9070002@tu-ilmenau.de>
References: <4E26DB41.9070002@tu-ilmenau.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Jul 2011 21:11:40 +0200
Message-ID: <1311189100.29152.75.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-20 at 15:42 +0200, Stephan Bärwolf wrote:
> 
> The function "check_preempt_wakeup" (kernel/sched_fair.c:1885)
> will preempt idle-task (for non-idle task), even if WAKEUP_PREEMPT
> is not featured (because of a too late checking the feature).
> This patches moves the checking of WAKEUP_PREEMT in front of
> idle-preemtion. 

That's actually on purpose, the WAKE_PREEMPT feature is supposed to only
affect preemption between SCHED_OTHER tasks.

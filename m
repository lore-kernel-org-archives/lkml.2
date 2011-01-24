Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab1AXWXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 17:23:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:55046 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab1AXWXR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 17:23:17 -0500
Subject: Re: [PATCH 01/18] move do_timer() from kernel/timer.c into
 kernel/time/timekeeping.c
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>, Torben Hohn <torbenh@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>, hch@infradead.org,
        yong.zhang0@gmail.com
In-Reply-To: <alpine.LFD.2.00.1101242254420.31804@localhost6.localdomain6>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
	 <1295651224-29823-2-git-send-email-torbenh@gmx.de>
	 <1295901169.4845.29.camel@work-vm>
	 <alpine.LFD.2.00.1101242254420.31804@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 24 Jan 2011 23:21:12 +0100
Message-ID: <1295907672.2274.44.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 23:10 +0100, Thomas Gleixner wrote:
> The call to calc_global_load() is there for hysterical raisins and we
> really should get rid of it sooner than later. I'm quite sure that it
> could be run from a timer callback as well. Peter ?

calc_global_load() wants to be called on just one cpu, do we have a
better place for that?

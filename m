Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032699Ab2CPKNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 06:13:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:32791 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964842Ab2CPKNU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 06:13:20 -0400
Message-ID: <1331892788.18960.227.camel@twins>
Subject: cpu_active vs pcrypt & padata
From: Peter Zijlstra <peterz@infradead.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 16 Mar 2012 11:13:08 +0100
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steffen,

I found cpu_active usage in crypto/pcrypt.c and was wondering what
that's doing there. I would really like to contain that thing to as
narrow a piece of kernel as I possible can (sched/cpuset/hotplug) but it
appears to be spreading.

Also, wth is all this kernel/padata.c stuff? There's next to no useful
comment in there and the only consumer seems to be pcrypt, does that
really need to be in kernel/ ?

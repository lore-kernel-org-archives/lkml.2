Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab1IZQHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 12:07:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:41622 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab1IZQHn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 12:07:43 -0400
Subject: Re: [PATCH 4/7] nohz: Allow rcu extended quiescent state handling
 seperately from tick stop
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulmck@linux.vnet.ibm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Date: Mon, 26 Sep 2011 18:06:47 +0200
In-Reply-To: <20110926160205.GB2399@linux.vnet.ibm.com>
References: <1317032352-25571-1-git-send-email-fweisbec@gmail.com>
	 <1317032352-25571-5-git-send-email-fweisbec@gmail.com>
	 <1317033884.9084.79.camel@twins> <20110926160205.GB2399@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317053207.1763.30.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-26 at 09:02 -0700, Paul E. McKenney wrote:
> Would your readability concerns be addressed by something like the
> following?
> 
> #define RCU_NO_HZ_LATER 0
> #define RCU_NO_HZ_NOW   1
> 
> Then we would have one of the following:
> 
>         tick_nohz_idle_enter(RCU_NO_HZ_LATER);
>         tick_nohz_idle_enter(RCU_NO_HZ_NOW); 

That certainly is a lot better, except for the two different ways of
collating NO HZ in that one line.

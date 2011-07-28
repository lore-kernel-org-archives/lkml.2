Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab1G1IYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 04:24:54 -0400
Received: from lvk-gate.cmc.msu.ru ([212.192.248.233]:59632 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754547Ab1G1IYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 04:24:48 -0400
X-Spam-ASN: 
From: "Nikita V. Youshchenko" <yoush@cs.msu.su>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.0-rt4
Date: Thu, 28 Jul 2011 12:24:41 +0400
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jason Wessel <jason.wessel@windriver.com>, lasaine@lvk.cs.msu.su
References: <alpine.LFD.2.02.1107272222420.2660@ionos> <201107281133.09107@zigzag.lvk.cs.msu.su> <alpine.LFD.2.02.1107280945080.2660@ionos>
In-Reply-To: <alpine.LFD.2.02.1107280945080.2660@ionos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107281224.44323@zigzag.lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 28 Jul 2011, Nikita V. Youshchenko wrote:
> > > The list of disabled config option is now:
> > >
> > >  - CONFIG_HIGHMEM [ see the mess it created in 33-rt ]
> >
> > Could someone please point me to information on this?
> >
> > In our setup, we do use PREEMPT_RT + HIGHMEM, on .33 for now (but want
> > to upgrade because of new hardware support issues with .33).  Up to
> > now, we did not face any issues related to PREEMPT_RT + HIGHMEM
> > combination.
>
> Yes, it works in 33-rt, but the way it's implemented is a horrible
> hack. I had not enough capacity to implement that cleanly for 3.0-rt,
> so I simply dropped it for now. The preliminary patches are there
> (mainly distangling the disable_pagefault logic), so it should not be
> that hard.

Thanks Thomas.

Since we do need PREEMPT_RT + HIGHMEM for our use case (*), I can ask one 
of our engineers to look into this. But for that, I need to get better 
understanding of what the issue is. Could you please explain in a few 
sentences, or point me to some information from where I could get the 
picture?

Nikita

(*) we need >1G of memory for data buffers, and have too much legacy 
software components so moving to 64bit system is not practical within 
available resource

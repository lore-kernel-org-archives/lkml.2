Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab1FFK1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 06:27:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45355 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab1FFK1U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 06:27:20 -0400
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
From: Peter Zijlstra <peterz@infradead.org>
To: Arne Jansen <lists@die-jansens.de>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <4DECA525.7030503@die-jansens.de>
References: <20110605151323.GA30590@elte.hu>
	 <20110605152641.GA31124@elte.hu> <20110605153218.GA31471@elte.hu>
	 <4DEBA9CC.4090503@die-jansens.de> <4DEBB05C.8090506@die-jansens.de>
	 <4DEBB3DA.8060001@die-jansens.de> <20110605172052.GA1036@elte.hu>
	 <4DEBBFF9.2030101@die-jansens.de> <20110605185957.GA3452@elte.hu>
	 <4DEBD95B.6030901@die-jansens.de> <20110605194419.GA12965@elte.hu>
	 <4DEBE3DF.70104@die-jansens.de> <1307350909.2353.7408.camel@twins>
	 <4DECA525.7030503@die-jansens.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Jun 2011 12:26:57 +0200
Message-ID: <1307356017.2353.7511.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 12:00 +0200, Arne Jansen wrote:
> As expected this apparently fixes the problem. But are we confident
> enough this is the true source? If it's really that simple, printk
> calling into the scheduler, why am I the only one seeing this?

Right, so apparently you have contention on console_sem and the up()
actually does a wakeup. I'm still trying to figure out how to do that.



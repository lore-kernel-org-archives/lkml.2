Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab1FFSPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:15:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:54806 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab1FFSPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:15:36 -0400
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20110606180733.GA20123@elte.hu>
References: <1307372989.2322.136.camel@twins>
	 <1307375227.2322.161.camel@twins> <20110606155236.GA7374@elte.hu>
	 <1307376039.2322.164.camel@twins> <20110606160810.GA16636@elte.hu>
	 <1307376771.2322.168.camel@twins> <20110606161749.GA22157@elte.hu>
	 <1307378649.2322.198.camel@twins> <20110606171153.GE2391@elte.hu>
	 <4DED1519.2020803@die-jansens.de>  <20110606180733.GA20123@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 20:19:09 +0200
Message-ID: <1307384349.2497.732.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 20:07 +0200, Ingo Molnar wrote:

>  - The first one that minimally removes the lockdep_off()/on() dance 
>    and fixes the regression: the patch that i sent earlier today.
>    I *think* that should fix the crash.
> 
>    3.0 material.

I think the lock_is_held() fix is the urgent one, all the others are
make printk() suck less patches, ie. not so very important.

Without that lock_is_held() thing all lockdep_off() sites, inc ntfs will
still be able to trigger this problem.


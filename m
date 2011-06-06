Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab1FFRMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:12:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:36509 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab1FFRMD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:12:03 -0400
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arne Jansen <lists@die-jansens.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20110606170725.GD2391@elte.hu>
References: <20110606145827.GD30348@elte.hu>
	 <1307372989.2322.136.camel@twins> <1307375227.2322.161.camel@twins>
	 <20110606155236.GA7374@elte.hu> <1307376039.2322.164.camel@twins>
	 <20110606160810.GA16636@elte.hu> <1307376771.2322.168.camel@twins>
	 <20110606161749.GA22157@elte.hu> <4DED0292.1040605@die-jansens.de>
	 <4DED0423.4050904@die-jansens.de>  <20110606170725.GD2391@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Jun 2011 19:11:51 +0200
Message-ID: <1307380311.2322.223.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 19:07 +0200, Ingo Molnar wrote:
> * Arne Jansen <lists@die-jansens.de> wrote:
> 
> > > As long as it doesn't scramble the order of the messages, the 
> > > delay imho doesn't matter even in very printk-heavy debugging 
> > > sessions.
> > 
> > And, as important, doesn't reduce the throughput of printk. Having 
> > only 100 wakeups/s sounds like the throughput is limited to 
> > 100xsizeof(ring buffer).
> 
> Nah.
> 
> I for example *always* kill klogd during such printk based debugging 
> sessions, because it's *already* very easy to overflow its buffering 
> abilities. Also, klogd often interferes with debugging.

Also, klogd is completely irrelevant, klogd doesn't do anything useful.
Writing things to the actual console otoh is very useful (you get to see
them on the screen/serial line).

Delaying the console_sem release will delay anything touching the
console_sem, including userland stuffs.

Delaying the console_sem acquire+release will delay showing important
printk() lines on your serial.

Both suck.

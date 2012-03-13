Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab2CMNub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:50:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55078 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab2CMNu3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:50:29 -0400
Message-ID: <1331646604.18960.76.camel@twins>
Subject: Re: [PATCH 0/5] Persist printk buffer across reboots.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Miller <davem@davemloft.net>
Cc: apenwarr@gmail.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        paulmck@linux.vnet.ibm.com, mingo@elte.hu, fdinitto@redhat.com,
        hannes@cmpxchg.org, olaf@aepfle.de, paul.gortmaker@windriver.com,
        tj@kernel.org, hpa@linux.intel.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Tue, 13 Mar 2012 14:50:04 +0100
In-Reply-To: <20120312.225302.488696931454771146.davem@davemloft.net>
References: <1331617001-20906-1-git-send-email-apenwarr@gmail.com>
	 <20120312.225302.488696931454771146.davem@davemloft.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 22:53 -0700, David Miller wrote:
> From: Avery Pennarun <apenwarr@gmail.com>
> Date: Tue, 13 Mar 2012 01:36:36 -0400
> 
> > The last patch in this series implements a new CONFIG_PRINTK_PERSIST option
> > that, when enabled, puts the printk buffer in a well-defined memory location
> > so that we can keep appending to it after a reboot.  The upshot is that,
> > even after a kernel panic or non-panic hard lockup, on the next boot
> > userspace will be able to grab the kernel messages leading up to it.  It
> > could then upload the messages to a server (for example) to keep crash
> > statistics.
> 
> On some platforms there are formal ways to reserve areas of memory
> such that the bootup firmware will know to not touch it on soft resets
> no matter what.  For example, on Sparc there are OpenFirmware calls to
> set aside such an area of soft-reset preserved memory.
> 
> I think some formal agreement with the system firmware is a lot better
> when available, and should be explicitly accomodated in these changes
> so that those of us with such facilities can very easily hook it up.

Shouldn't this all be near the pstore effort? I know pstore and the
soft-reset stuff aren't quite the same, but if that's the best Sparc can
do, then why not?

OTOH if Sparc can actually do pstore too, then it might make sense.

What I guess I'm saying is that we should try and minimize the duplicate
efforts here.. and it seems to me that writing a soft reset x86 backend
to pstore for those machines that don't actually have the acpi flash
crap might be more useful and less duplicative.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab0HDIe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 04:34:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:41374 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895Ab0HDIeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 04:34:23 -0400
Subject: Re: [PATCH 1/3] Input: sysrq - drop tty argument from sysrq ops
 handlers
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>, David Miller <davem@davemloft.net>,
        Fenghua Yu <fenghua.yu@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>
In-Reply-To: <20100804075900.30647.46910.stgit@localhost.localdomain>
References: <20100804075602.30647.91462.stgit@localhost.localdomain>
	 <20100804075900.30647.46910.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 18:33:50 +1000
Message-ID: <1280910830.1902.144.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 00:59 -0700, Dmitry Torokhov wrote:
> Noone is using tty argument so let's get rid of it.

While talking about sysrq...

I noticed that serial drivers call sysrq with the uart lock held.

I've seen deadlocks caused by that, for example, when entering the
debugger, it waits forever for a CPU which is itself waiting on the UART
lock.

I have a patch to drop the lock in serial_core.h, I'll post that
tomorrow hopefully, just checking if there's any objection there ? The
serial drivers might need to be audited a bit to make sure they cope
with the lock being dropped and re-acquired around the sysrq call.

Cheers,
Ben.
 


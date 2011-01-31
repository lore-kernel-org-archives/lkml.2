Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab1AaXUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:20:10 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46239 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab1AaXUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 18:20:08 -0500
Subject: Re: kswapd hung tasks in 2.6.38-rc1
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: CAI Qian <caiqian@redhat.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110131231301.GP16981@random.random>
References: <1150342867.83404.1295513748640.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
	 <1296507528.7797.4609.camel@nimitz> <1296513616.7797.4929.camel@nimitz>
	 <20110131231301.GP16981@random.random>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Mon, 31 Jan 2011 15:20:03 -0800
Message-ID: <1296516003.7797.5061.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 00:13 +0100, Andrea Arcangeli wrote:
> On Mon, Jan 31, 2011 at 02:40:16PM -0800, Dave Hansen wrote:
> > Still not a very good data point, but I ran a heavy swap load for an
> > hour or so without reproducing this.  But, it happened again after I
> > enabled transparent huge pages.  I managed to get a sysrq-t dump out of
> > it:
> > 
> > 	http://sr71.net/~dave/ibm/2.6.38-rc2-hang-0.txt
> > 
> > khugepaged is one of the three running tasks.  Note, I set both its
> > sleep timeouts to zero to stress it out a bit.
> 
> sysrq+l? sysrq+t doesn't provide interesting info for running tasks.

I'll try to get a sysrq-l dump.

> > I'll keep trying to reproduce without THP.
> 
> BTW, do you have prove locking enabled? With recent git I get a
> deadlock inside _raw_spin_unlock_irq with prove locking enabled and it
> goes away when I disable it.

Nope:

$ grep PROVE ../mhp-build/x86_64-elm3b82/.config
# CONFIG_PROVE_LOCKING is not set

Full .config is here

	http://sr71.net/~dave/ibm/config-v2.6.38-rc2

-- Dave


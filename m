Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab2FCLkT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 07:40:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49831 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab2FCLkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 07:40:17 -0400
Date: Sun, 3 Jun 2012 12:39:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Richard Kuo <rkuo@codeaurora.org>, David Howells <dhowells@redhat.com>,
        Bob Liu <lliubbo@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        Richard Weinberger <richard@nod.at>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Matt Turner <mattst88@gmail.com>, nikunj@linux.vnet.ibm.com
Subject: Re: [PATCH 01/27] smpboot: Provide a generic method to boot
	secondary processors
Message-ID: <20120603113948.GC15354@n2100.arm.linux.org.uk>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091008.31979.93586.stgit@srivatsabhat.in.ibm.com> <4FC8B0F7.3060705@linux.vnet.ibm.com> <20120603085359.GE16829@zhy> <4FCB4B9E.3090508@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCB4B9E.3090508@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 03, 2012 at 05:03:50PM +0530, Srivatsa S. Bhat wrote:
> That's a good point! But unfortunately we can't do that just yet.
> Because, some architectures have explicit comments that say that
> irqs must be enabled at a certain point in time, or have something
> special than just a local_irq_enable(), and hence fall under the
> __cpu_post_online() function when converted to this model.
> 
> Examples: ARM (patch 26) and ia64 (patch 15)
> 
> Unless the maintainers give a go-ahead to change them, I don't
> think it would be safe.. (I have added the Notes section to each
> patch to get the attention of the maintainers to such issues).

I have no intention of touching ARMs SMP bringup any more than is
absolutely necessary - this code is extremely fragile, and it's taken
a long time to get it to where it presently is, where most people are
happy with it.

Especially problematical is stuff like where we enable interrupts in
relation to other activities.

It's probably best to describe the code not as "mostly bug free" but
as "causes the least pain" because I don't think there is a solution
which satisfies all the constraints placed upon this code path by
the various parts of the kernel.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965608Ab0COSIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 14:08:12 -0400
Received: from mga05.intel.com ([192.55.52.89]:39172 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933721Ab0COSIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 14:08:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,644,1262592000"; 
   d="scan'208";a="780967125"
Date: Mon, 15 Mar 2010 17:43:59 +0000
From: Alan Cox <alan@linux.intel.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Jan Beulich <JBeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: pcmcia's use of IRQ_NOAUTOEN
Message-ID: <20100315174359.7fa53d4b@linux.intel.com>
In-Reply-To: <20100308194757.GB17628@isilmar.linta.de>
References: <4B94DCB7020000780003337B@vpn.id2.novell.com>
	<20100308194757.GB17628@isilmar.linta.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Mar 2010 20:47:57 +0100
Dominik Brodowski <linux@dominikbrodowski.net> wrote:

> Hey,
> 
> On Mon, Mar 08, 2010 at 10:17:11AM +0000, Jan Beulich wrote:
> > (re-sending to correct Alan's email address)
> > 
> > Commit 635416ef393e8cec5a89fc6c1de710ee9596a51e introduced
> > this, but I can't see how it can take effect - the argument passed
> > to request_irq() only affects action->flags (IRQF_*), whereas the
> > flag in question is a desc->status one (IRQ_*). Am I overlooking
> > something? If not, while currently this just should not work as
> > expected, it's latently more significant (as soon as the IRQF_*
> > definitions make use of the bit used by IRQ_NOAUTOEN).
> 
> You're right, it seems to make no sense. Or less than that.
> 
> Alan, what do you think?

It should be setting the correct NOAUTOEN bits so that the IRQ isn't
randomly enabled as some hardware then crashes. How it ended up wrong
upstream I don't know as it was tested and fixed the bug, so presumably
the right version got tested or it happened to work back on the old irq
code by luck.

I don't think you are overlooking anything - there is no deep magic
involved.

Alan

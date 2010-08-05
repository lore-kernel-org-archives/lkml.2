Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635Ab0HECDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 22:03:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:36540 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759439Ab0HECD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 22:03:29 -0400
Subject: Re: [PATCH 1/3] Input: sysrq - drop tty argument from sysrq ops
 handlers
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        David Miller <davem@davemloft.net>, Fenghua Yu <fenghua.yu@intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>
In-Reply-To: <4C59570F.7040201@windriver.com>
References: <20100804075602.30647.91462.stgit@localhost.localdomain>
	 <20100804075900.30647.46910.stgit@localhost.localdomain>
	 <1280910830.1902.144.camel@pasglop>  <4C59570F.7040201@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 12:03:05 +1000
Message-ID: <1280973785.1902.167.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 07:03 -0500, Jason Wessel wrote:
> The usb serial has the same kind of problem with all sorts of locks.
> I
> had resorted to using a tasklet or workqueue to get the sysrq to
> execute
> just outside the usb serial driver context.  This work never made it
> upstream because it was part of another series, but the reference is:
> http://lkml.org/lkml/2010/3/9/17
> 
> For the standard serial you might be able to get away with dropping
> the
> lock for the sysrq.
> 
> Did you have a particular way to trigger the problem or was it just
> completely random, because I don't know that I have observed this
> behavior with the typical 8250 driver.

Yes, I do actually :-) A 64-way machine and a bunch of processes
flooding the console will do it just fine :-)

Cheers,
Ben.



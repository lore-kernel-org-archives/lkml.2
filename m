Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab0HDI4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 04:56:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40119 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757151Ab0HDI4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 04:56:38 -0400
Date: Wed, 4 Aug 2010 10:09:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        David Miller <davem@davemloft.net>, Fenghua Yu <fenghua.yu@intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 1/3] Input: sysrq - drop tty argument from sysrq ops
 handlers
Message-ID: <20100804100926.3f24f5e5@lxorguk.ukuu.org.uk>
In-Reply-To: <1280910830.1902.144.camel@pasglop>
References: <20100804075602.30647.91462.stgit@localhost.localdomain>
	<20100804075900.30647.46910.stgit@localhost.localdomain>
	<1280910830.1902.144.camel@pasglop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have a patch to drop the lock in serial_core.h, I'll post that
> tomorrow hopefully, just checking if there's any objection there ? The

Fundamentally - no. However the impact it has on a lot of the drivers
will be significant and you'll be submitting a huge patch pile to fix up
all the locking assumptions (for one it means port->tty might change
across any call that ends up in sysrq)

> serial drivers might need to be audited a bit to make sure they cope
> with the lock being dropped and re-acquired around the sysrq call.

Architecturally I think it would make more sense to add a new sysrq
helper which merely sets a flag, and check that flag at the end of the IRQ
when dropping the lock anyway.

Otherwise it'll be a huge amount of work to even build test all those
consoles.

Alan

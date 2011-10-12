Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab1JLNxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 09:53:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56435 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752329Ab1JLNxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 09:53:19 -0400
Date: Wed, 12 Oct 2011 14:51:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: monstr@monstr.eu
Cc: linux-serial@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: Using serial driver 16550A in poll mode without interrupt
 connected
Message-ID: <20111012145153.5490b592@lxorguk.ukuu.org.uk>
In-Reply-To: <4E95902B.7080204@monstr.eu>
References: <4E95902B.7080204@monstr.eu>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Driver is probed with no IRQ (NO_IRQ = -1 on Microblaze)
> 83e00000.serial: ttyS0 at MMIO 0x83e01003 (irq = -1) is a 16550A

Zero means no IRQ. NO_IRQ is a legacy internal thing for the old IDE code
so not something other code should be using. Setting the IRQ to -1 is
bogus and will confuse the rest of the kernel.

> Is it possible to use serial driver without IRQ - or blocking IRQ, etc.?

Within limits - it kills your power management and data rates because of
the continual polling.

Alan

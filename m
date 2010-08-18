Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab0HRL2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 07:28:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50204 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752645Ab0HRL2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 07:28:34 -0400
Date: Wed, 18 Aug 2010 12:44:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pascal GREGIS <pgs@synerway.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ata_sff_drain_fifo
Message-ID: <20100818124412.4652eaea@lxorguk.ukuu.org.uk>
In-Reply-To: <20100818094313.GA3333@gaiman.synerway.com>
References: <20100818094313.GA3333@gaiman.synerway.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> so I guess when status is 0xD0, ATA_DRQ is not set but ATA_BUSY is.
> It would explain why in my case it doesn't drain anything before trying to reset.
> 
> Would it be of any interest to drain the fifo also when the ATA_BUSY flag is on, not only the ATA_DRQ ?

If the drive has the busy flag set it is busy, all we can do is wait for
it and if that fails try to reset it. The FIFO drain handles a specific
case where the two ends disagree about the amount of data expected, and
often lets us avoid a reset.

Alan

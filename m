Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab2ARLhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 06:37:13 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60345 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab2ARLhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 06:37:12 -0500
Date: Wed, 18 Jan 2012 11:38:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Simon J. Rowe" <srowe@mose.org.uk>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] libata: blacklist NCQ on WDC WD740ADFD-00NLR4
Message-ID: <20120118113826.7fc60f12@pyramind.ukuu.org.uk>
In-Reply-To: <201201181038.30271.srowe@mose.org.uk>
References: <201201181038.30271.srowe@mose.org.uk>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jan 16 21:17:08 gilraen kernel: ata5: SError: { UnrecovData Handshk }
> Jan 16 21:17:08 gilraen kernel: ata5.00: failed command: WRITE DMA EXT
> Jan 16 21:17:08 gilraen kernel: ata5.00: cmd 
> 35/00:68:6f:5d:9a/00:01:00:00:00/e0 tag 0 dma 184320 out
> Jan 16 21:17:08 gilraen kernel:         res 
> 50/00:00:66:5d:9a/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
> Jan 16 21:17:08 gilraen kernel: ata5.00: status: { DRDY }
> Jan 16 21:17:08 gilraen kernel: ata5: hard resetting link
> Jan 16 21:17:08 gilraen kernel: ata5: SATA link up 1.5 Gbps (SStatus 113 
> SControl 300)
> Jan 16 21:17:08 gilraen kernel: ata5.00: configured for UDMA/133
> Jan 16 21:17:08 gilraen kernel: ata5: EH complete
> 
> Googling revealed that this is often caused by faulty cabling. I moved the 
> power and SATA cables and the problem has now gone but I think the disk should 
> still be added to the blacklist,

We add things to the NCQ blacklist because we have multiple clear cases
showing NCQ problems and preferably vendor confirmation. You have neither
and as you said yourself when you fixed the cables it went away.

Your drive is report UnrecovData Handshk, and its' reporting it on a non
NCQ command in your second example. You had a cable problem.

So NAK this patch

Alan



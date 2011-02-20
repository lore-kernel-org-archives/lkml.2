Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab1BTTLv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 14:11:51 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50418 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752991Ab1BTTLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 14:11:50 -0500
Date: Sun, 20 Feb 2011 19:13:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/et131x: fix et131x_rx_dma_disable halt_status
 usage
Message-ID: <20110220191307.07faacda@lxorguk.ukuu.org.uk>
In-Reply-To: <20110220190334.GA3825@joi.lan>
References: <20110220190334.GA3825@joi.lan>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Feb 2011 20:03:34 +0100
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> Commit 1bd751c1abc1029e8a0ae63ef4f19357c735a2a3
> ("Staging: et131x: Clean up rxdma_csr") changed csr from bitfield to
> u32, but failed to convert 2 uses of halt_status bit. It did:
> 
> - if (csr.bits.halt_status != 1)
> + if ((csr & 0x00020000) != 1)
> 
> which is wrong, because second version is always true.
> Fix it.
> 
> This bug was found by coccinelle (http://coccinelle.lip6.fr/).
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Alan Cox <alan@linux.intel.com>

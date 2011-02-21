Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab1BUL5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 06:57:10 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59225 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755246Ab1BUL5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 06:57:07 -0500
Date: Mon, 21 Feb 2011 11:58:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/20] ata_piix: unify code for programming PIO and
 MWDMA timings
Message-ID: <20110221115839.2048e8fe@lxorguk.ukuu.org.uk>
In-Reply-To: <4D624EBD.4080400@ru.mvista.com>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
	<20110208122346.19110.8441.sendpatchset@linux-mhg7.site>
	<4D6118DC.80505@ru.mvista.com>
	<20110220185958.364df4cc@lxorguk.ukuu.org.uk>
	<4D617CC8.3020108@ru.mvista.com>
	<20110220210731.0c774fa7@lxorguk.ukuu.org.uk>
	<4D624EBD.4080400@ru.mvista.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011 14:38:37 +0300
Sergei Shtylyov <sshtylyov@mvista.com> wrote:

> Hello.
> 
> On 21-02-2011 0:07, Alan Cox wrote:
> 
> >>      PIO mode is setup by different code, and it takes care of the IORDY
> >> setting according to the PIO rules (and it gets called). DMA mode setup should
> >> just ignore the IORDY setting as in all other sane drivers.
> 
> > Well it can't ignore it - but if you mean just keep the bit as is then
> 
>     Yes, I mean this.
> 
> > that sounds sensible, have to see what the docs say happens if you ever
> > set MWDMA without IORDY.
> 
>     Don't think they say anything on this matter but I can't imagine that 
> IORDY matters for DMA.

Sure - but it does matter for an ATAPI transaction with then has a DMA
phase because those timings will be used for the command transfer which
is PIO.

Alan

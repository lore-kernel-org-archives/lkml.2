Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab1J0Hxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 03:53:38 -0400
Received: from [85.13.70.251] ([85.13.70.251]:63672 "EHLO
	localhost.localdomain" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752353Ab1J0Hxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 03:53:36 -0400
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Oct 2011 03:53:36 EDT
Date: Thu, 27 Oct 2011 08:43:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Schilling <paul.s.schilling@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, "David S. Miller" <davem@davemloft.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 02/15] ATA : vortex86 : fix vortex86dx/sx hardware CRC
 bug.
Message-ID: <20111027084310.2b7da753@pyx>
In-Reply-To: <1319602564-19162-1-git-send-email-paul.s.schilling@gmail.com>
References: <fix vortex86>
	<1319602564-19162-1-git-send-email-paul.s.schilling@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Oct 2011 23:16:04 -0500
Paul Schilling <paul.s.schilling@gmail.com> wrote:

> This fixes a DMA issue related to a CRC bug on
> the RDC pata peripherial found on the vortex86sx and vortex86dx.

What is the RDC erratum reference for this ? Also it seems to make no
sense


>  	static const struct ata_port_info info_rdc_11 = {
>  		.flags = ATA_FLAG_SLAVE_POSS,
>  		.pio_mask = ATA_PIO4,
> -		.mwdma_mask = ATA_MWDMA2,
> +		.mwdma_mask = 0,
> +		.udma_mask = 0,

MWDMA is not part of the CRC hardware anyway

Are you sure these newer variants are simply not using a different set of
timing parameters thus showing bugs on your system ?

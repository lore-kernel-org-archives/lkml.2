Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab1J1S1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 14:27:21 -0400
Received: from [85.13.70.251] ([85.13.70.251]:34308 "EHLO
	localhost.localdomain" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754037Ab1J1S1U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 14:27:20 -0400
Date: Fri, 28 Oct 2011 19:27:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Schilling <paul.s.schilling@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, "David S. Miller" <davem@davemloft.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 02/15] ATA : vortex86 : fix vortex86dx/sx hardware CRC
 bug.
Message-ID: <20111028192710.361093ea@pyx>
In-Reply-To: <CAC=G6sz9tpLnxWN7_Ts+rcNf-YQZw-4VQUNo6vKNeHOnOPOHVA@mail.gmail.com>
References: <1319602564-19162-1-git-send-email-paul.s.schilling@gmail.com>
	<20111027084310.2b7da753@pyx>
	<CAC=G6sz9tpLnxWN7_Ts+rcNf-YQZw-4VQUNo6vKNeHOnOPOHVA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Oct 2011 13:55:21 -0500
Paul Schilling <paul.s.schilling@gmail.com> wrote:

> The Vortex86dx uses RDC IDE peripheral integrated into the SOC.  The
> CRC design is
> broken in the Vortex86dx and sx.  The original reference can be found
> in the Linux kernel itself.
> 
> The Vortex86sx uses the RDC D1010.
> The Vortex86dx uses the RDC D1011.
> Both of which have broken CRC hardware which breaks DMA.

CRC hardware is only used for *UDMA* yet your change also disabled MWDMA.


> >>       static const struct ata_port_info info_rdc_11 = {
> >>               .flags = ATA_FLAG_SLAVE_POSS,
> >>               .pio_mask = ATA_PIO4,
> >> -             .mwdma_mask = ATA_MWDMA2,
> >> +             .mwdma_mask = 0,
> >> +             .udma_mask = 0,

Why ?

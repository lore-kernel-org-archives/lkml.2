Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934660Ab1JaTHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 15:07:48 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56966 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934573Ab1JaTHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 15:07:46 -0400
MIME-Version: 1.0
In-Reply-To: <20111027084310.2b7da753@pyx>
References: <1319602564-19162-1-git-send-email-paul.s.schilling@gmail.com>
	<20111027084310.2b7da753@pyx>
Date: Mon, 31 Oct 2011 14:07:45 -0500
Message-ID: <CAC=G6sz=PkDoODYh4beT_eRhkm+ZhUxtLnrBXPPuFJW3n+6Vcg@mail.gmail.com>
Subject: Re: [PATCH 02/15] ATA : vortex86 : fix vortex86dx/sx hardware CRC bug.
From: Paul Schilling <paul.s.schilling@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jgarzik@pobox.com>, "David S. Miller" <davem@davemloft.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When I developed this patch for the Vortex86dx.  I recall trying many
combinations of udma and mwdma.  At the time I developed it, I came
to the conclusion that both udma and mwdma both failed with CRC
errors being reported.  I am not readily set-up to redo the testing to
see if mwdma is indeed also affected by the errata.  It will be a couple
of weeks before I can re-test this patch on the hardware with mwdma
turned on.

Thanks,
Paul

On Thu, Oct 27, 2011 at 2:43 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Tue, 25 Oct 2011 23:16:04 -0500
> Paul Schilling <paul.s.schilling@gmail.com> wrote:
>
>> This fixes a DMA issue related to a CRC bug on
>> the RDC pata peripherial found on the vortex86sx and vortex86dx.
>
> What is the RDC erratum reference for this ? Also it seems to make no
> sense
>
>
>>       static const struct ata_port_info info_rdc_11 = {
>>               .flags = ATA_FLAG_SLAVE_POSS,
>>               .pio_mask = ATA_PIO4,
>> -             .mwdma_mask = ATA_MWDMA2,
>> +             .mwdma_mask = 0,
>> +             .udma_mask = 0,
>
> MWDMA is not part of the CRC hardware anyway
>
> Are you sure these newer variants are simply not using a different set of
> timing parameters thus showing bugs on your system ?
>

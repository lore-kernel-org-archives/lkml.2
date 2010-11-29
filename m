Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab0K2Kju (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 29 Nov 2010 05:39:50 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43050 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab0K2Kjs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 05:39:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=twUfbmGPtUyVSgxq+piOiZRdKQtPVNNpBW9f/fxWw3/RkH8vXU42Lo+L2VrfxipkLt
         LBKSUOfrTiRLSneqjByskpXY/uBz8C6iNadyBM6wR7H9icymtxc8RCTa2bNP3P1e9deI
         Pq3dEkm1AJnFCIl5Ix5tT0QCgVMZKfldCC1uU=
MIME-Version: 1.0
In-Reply-To: <4CF0DC95.2050501@gmail.com>
References: <AANLkTinSigE4JPsFByPCkFd-+_oXQwR-V9=AsSH9Warz@mail.gmail.com>
	<1290755809.2678.14.camel@edumazet-laptop>
	<AANLkTi=8nWFHeJ0Z-WhprNqZMGprMRG5LQ+b3wKoMWWv@mail.gmail.com>
	<AANLkTi=bELgtgcWcy59KCvKwWWiuVZBb7e_hTSBHZ4cH@mail.gmail.com>
	<20101126073805.GB14282@liondog.tnic>
	<AANLkTikBgxBsGudfiN-xnN-KRNaanFrPpwOH_EMJ-oic@mail.gmail.com>
	<4CEFEEC6.20900@gmail.com>
	<AANLkTi=W2swi_5r=wMrORA5xkXq1aU5KRD-rE9f0mxxP@mail.gmail.com>
	<4CF0DC95.2050501@gmail.com>
Date: Mon, 29 Nov 2010 11:39:47 +0100
Message-ID: <AANLkTikyd5hN6msKhzd42Ahr=S+_xK2MODthME8pfd_W@mail.gmail.com>
Subject: Re: Message
From: Alessandro Tagliapietra <tagliapietra.alessandro@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org, linux-ide <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/27 Tejun Heo <htejun@gmail.com>:
> So, it's a different controller.  1b4b:91a3 instead of 1b4b:9123.
> Hmm... why did they switch vendor id from 11ab?  I currently don't
> have access to the datasheets but does the following blind patch work
> by any chance?
>
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 3288263..0c39fbb 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -380,6 +380,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
>        { PCI_VDEVICE(MARVELL, 0x6121), board_ahci_mv },        /* 6121 */
>        { PCI_DEVICE(0x1b4b, 0x9123),
>          .driver_data = board_ahci_yes_fbs },                  /* 88se9128 */
> +       { PCI_DEVICE(0x1b4b, 0x91a3),
> +         .driver_data = board_ahci_yes_fbs },
>
>        /* Promise */
>        { PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },   /* PDC42819 */
>
> --
> tejun


Yeah it works fine. I've patched and compiled both 2.6.37-rc3 and 2.6.36.1.
I can see the hdd and use them.
When this patch is applied to the kernel?
So i can use it on daily natty build instead of changing the livecd
that's quite hard for me.

Best Regards and thanks for help

Alessandro

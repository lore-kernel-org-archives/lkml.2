Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2LEAAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 19:00:35 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:36972 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab2LEAAd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 19:00:33 -0500
MIME-Version: 1.0
In-Reply-To: <1353437939-29210-1-git-send-email-betty.dall@hp.com>
References: <1353437939-29210-1-git-send-email-betty.dall@hp.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 4 Dec 2012 17:00:11 -0700
Message-ID: <CAErSpo7fCxir6bRVzx-mHYZeqy_qgYxeyS4WvffnuFooZ87J1g@mail.gmail.com>
Subject: Re: [PATCH] PCI: add PCIe 8.0 GT/s supported link speed define
To: Betty Dall <betty.dall@hp.com>
Cc: jbarnes@virtuousgeek.org, alex.williamson@redhat.com,
        wangyijing@huawei.com, ddutile@redhat.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 11:58 AM, Betty Dall <betty.dall@hp.com> wrote:
> Add a new define for the 8.0 GT/s supported link speed added in the PCI
> 3.0 specification.  This is used to identify a device's current link speed
> (PCI_EXP_CLS).
>
> Here is the section of the PCI 3.0 specification:
> "Supported Link Speeds Vector – This field indicates the
> supported Link speed(s) of the associated Port. For each bit, a
> value of 1b indicates that the corresponding Link speed is
> supported; otherwise, the Link speed is not supported.
> Bit definitions within this field are:
> Bit 0 2.5 GT/s
> Bit 1 5.0 GT/s
> Bit 2 8.0 GT/s
> Bits 6:3 RsvdP
> Multi-Function devices associated with an Upstream Port must
> report the same value in this field for all Functions."
>
> Signed-off-by: Betty Dall <betty.dall@hp.com>
> ---
>  include/uapi/linux/pci_regs.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
> index 20ae747..0cf8abb 100644
> --- a/include/uapi/linux/pci_regs.h
> +++ b/include/uapi/linux/pci_regs.h
> @@ -469,6 +469,7 @@
>  #define  PCI_EXP_LNKSTA_CLS    0x000f  /* Current Link Speed */
>  #define  PCI_EXP_LNKSTA_CLS_2_5GB 0x01 /* Current Link Speed 2.5GT/s */
>  #define  PCI_EXP_LNKSTA_CLS_5_0GB 0x02 /* Current Link Speed 5.0GT/s */
> +#define  PCI_EXP_LNKSTA_CLS_8_0GB 0x04 /* Current Link Speed 8.0GT/s */

This isn't right, is it?  The Link Status Current Link Speed field is
a four-bit field that's encoded.  The currently defined values are 1-7
(not 1, 2, 4, 8).  So I think you would want to add this instead:

#define  PCI_EXP_LNKSTA_CLS_8_0GB 0x03 /* Current Link Speed 8.0GT/s */

That corresponds to bit 2 in the Supported Link Speeds Vector in the
Link Capabilities 2 register:

#define  PCI_EXP_LNKCAP2_SLS_8_0GB 0x04 /* Supported Link Speed 8.0GT/s */

This whole mess looks like potential off-by-one errors everywhere, and
I could be mistaken about this :)

While you're here, can you fix the typo ("Nogotiated") in the line below?

>  #define  PCI_EXP_LNKSTA_NLW    0x03f0  /* Nogotiated Link Width */
>  #define  PCI_EXP_LNKSTA_NLW_SHIFT 4    /* start of NLW mask in link status */
>  #define  PCI_EXP_LNKSTA_LT     0x0800  /* Link Training */
> --
> 1.7.7.6
>

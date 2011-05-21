Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab1EUQro (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 12:47:44 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:47287 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750868Ab1EUQrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 12:47:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=LYFxiZBe8M+km/BLAXCoAFusvnn46gmE8k87brx4Om3ne1h4wBENW1NTWA8rhxEJpKisoK+LKAfFxDlV6fOI/Y4pMJS0oibPK4o8RuPrfsk1XkCcSHJZgcBu7ZT2fWQU;
Date: Sat, 21 May 2011 09:47:39 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] PCI: Don't use dmi_name_in_vendors in quirk
Message-ID: <20110521094739.0770bbc9@jbarnes-e6510>
In-Reply-To: <20110515181346.23a9273c@endymion.delvare>
References: <20110515181346.23a9273c@endymion.delvare>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 May 2011 18:13:46 +0200
Jean Delvare <khali@linux-fr.org> wrote:

> Don't use the costly dmi_name_in_vendors() when we know the string we
> are looking for can only be in the DMI board name field. This is more
> robust and, more importantly, much faster.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---
>  drivers/pci/quirks.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.39-rc7.orig/drivers/pci/quirks.c	2011-05-14
> 13:07:14.000000000 +0200 +++
> linux-2.6.39-rc7/drivers/pci/quirks.c	2011-05-15
> 14:42:02.000000000 +0200 @@ -2349,8 +2349,11 @@
> DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_A */ static void __devinit
> nvenet_msi_disable(struct pci_dev *dev) {
> -	if (dmi_name_in_vendors("P5N32-SLI PREMIUM") ||
> -	    dmi_name_in_vendors("P5N32-E SLI")) {
> +	const char *board_name = dmi_get_system_info(DMI_BOARD_NAME);
> +
> +	if (board_name &&
> +	    (strstr(board_name, "P5N32-SLI PREMIUM") ||
> +	     strstr(board_name, "P5N32-E SLI"))) {
>  		dev_info(&dev->dev,
>  			 "Disabling msi for MCP55 NIC on
> P5N32-SLI\n"); dev->no_msi = 1;
> 
> 

Applied, thanks.

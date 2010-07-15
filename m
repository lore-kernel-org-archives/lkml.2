Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934362Ab0GOVow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 17:44:52 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:36836 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934092Ab0GOVov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 17:44:51 -0400
Subject: Re: [PATCH 24/25] video/ivtv: Convert pci_table entries to
 PCI_VDEVICE (if PCI_ANY_ID is used)
From: Andy Walls <awalls@md.metrocast.net>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ian Armstrong <ian@iarmst.demon.co.uk>,
        Douglas Schilling Landgraf <dougsland@redhat.com>,
        Steven Toth <stoth@kernellabs.com>, ivtv-devel@ivtvdriver.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <201007152108.27175.PeterHuewe@gmx.de>
References: <201007152108.27175.PeterHuewe@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Jul 2010 17:43:20 -0400
Message-ID: <1279230200.7920.23.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-07-15_05:2010-07-15,2010-07-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1007150110
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-15 at 21:08 +0200, Peter Huewe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> This patch converts pci_table entries, where .subvendor=PCI_ANY_ID and
> .subdevice=PCI_ANY_ID, .class=0 and .class_mask=0, to use the
> PCI_VDEVICE macro, and thus improves readability.

Hi Peter,

I have to disagree.  The patch may improve typesetting, but it degrades
clarity and maintainability from my perspective.

a. PCI_ANY_ID indicates to the reader a wildcard match is being
performed.  The PCI_VDEVICE() macro hides that to some degree.

b. PCI_VENDOR_ID_ICOMP clearly indicates that ICOMP is a vendor.
"ICOMP" alone does not hint to the reader that is stands for a company
(the now defunct "Internext Compression, Inc.").


IMO, macros, for things other than named constants, should only be used
for constructs that the C language does not express clearly or compactly
in the context.  This structure initialization being done in file scope,
where white space and line feeds are cheap, will only be obfuscated by
macros, not clarified.

So I'm going to NAK this for ivtv, unless someone can help me understand
any big picture benefit that I may not see from my possibly myopic
perspective.


BTW, I have not seen a similar patch come in my mailbox for
cx18-driver.c.  Why propose the change for ivtv and not cx18?

Regards,
Andy

> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  drivers/media/video/ivtv/ivtv-driver.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
> index 90daa6e..8e73ab9 100644
> --- a/drivers/media/video/ivtv/ivtv-driver.c
> +++ b/drivers/media/video/ivtv/ivtv-driver.c
> @@ -69,10 +69,8 @@ int ivtv_first_minor;
>  
>  /* add your revision and whatnot here */
>  static struct pci_device_id ivtv_pci_tbl[] __devinitdata = {
> -	{PCI_VENDOR_ID_ICOMP, PCI_DEVICE_ID_IVTV15,
> -	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> -	{PCI_VENDOR_ID_ICOMP, PCI_DEVICE_ID_IVTV16,
> -	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> +	{PCI_VDEVICE(ICOMP, PCI_DEVICE_ID_IVTV15), 0},
> +	{PCI_VDEVICE(ICOMP, PCI_DEVICE_ID_IVTV16), 0},
>  	{0,}
>  };
>  



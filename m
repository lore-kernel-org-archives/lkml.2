Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab0LGP5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:57:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38921 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab0LGP5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:57:15 -0500
Subject: Re: [PATCH 1/3] [SCSI] dpt_i2o: fix compiler warning on dptids
From: James Bottomley <James.Bottomley@suse.de>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adaptec OEM Raid Solutions <aacraid@adaptec.com>
In-Reply-To: <1291735896-14541-1-git-send-email-namhyung@gmail.com>
References: <1291735896-14541-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 09:57:01 -0600
Message-ID: <1291737421.17668.5.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 00:31 +0900, Namhyung Kim wrote:
> Annotate dptids as '__used' to fix following warning:
> 
>   CC      drivers/scsi/dpt_i2o.o
> drivers/scsi/dpt_i2o.c:183: warning: ‘dptids’ defined but not used
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
> ---
>  drivers/scsi/dpt_i2o.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
> index cffcb10..b276077 100644
> --- a/drivers/scsi/dpt_i2o.c
> +++ b/drivers/scsi/dpt_i2o.c
> @@ -180,7 +180,7 @@ static u8 adpt_read_blink_led(adpt_hba* host)
>   *============================================================================
>   */
>  
> -static struct pci_device_id dptids[] = {
> +static struct pci_device_id dptids[] __used = {
>  	{ PCI_DPT_VENDOR_ID, PCI_DPT_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,},
>  	{ PCI_DPT_VENDOR_ID, PCI_DPT_RAPTOR_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,},
>  	{ 0, }

Um so this is definitely used in the MODULE_DEVICE_TABLE just below.

I deduce you have some type of config which causes that to be a nop
(say !CONFIG_MODULE)?  In which case, surely the correct fix is in
module.h?

James




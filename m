Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab2DVSNO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 14:13:14 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56690 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab2DVSNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 14:13:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120420150732.10596.9085.stgit@beardog.cce.hp.com>
References: <20120420150349.10596.73732.stgit@beardog.cce.hp.com> <20120420150732.10596.9085.stgit@beardog.cce.hp.com>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Sun, 22 Apr 2012 14:12:40 -0400
X-Google-Sender-Auth: md46UXqSlG2gDKVHMiY52NIvmvc
Message-ID: <CAP=VYLpOyBuvZ3+Nfw1u0dojOX8kt-1TDJA+v-EWQuKPdh0A1w@mail.gmail.com>
Subject: Re: [PATCH 14/17] hpsa: use new IS_ENABLED macro
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, matthew.gates@hp.com,
        stephenmcameron@gmail.com, thenzl@redhat.com,
        akpm@linux-foundation.org, mikem@beardog.cce.hp.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 11:07 AM, Stephen M. Cameron
<scameron@beardog.cce.hp.com> wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>

You've not written a commit log, so I'm left guessing what the
intended rationale is here.  COMPAT, X86 and PCI_MSI are
I believe all bool, so why make this change?  To me it gives
a misleading message that some level of modular awareness
is needed here, when there really isn't any such need.

Thanks,
Paul.
---

> ---
>  drivers/scsi/hpsa.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 2e01583..67a0ad0 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -139,7 +139,7 @@ static irqreturn_t do_hpsa_intr_msi(int irq, void *dev_id);
>  static int hpsa_ioctl(struct scsi_device *dev, int cmd, void *arg);
>  static void start_io(struct ctlr_info *h);
>
> -#ifdef CONFIG_COMPAT
> +#if IS_ENABLED(COMPAT)
>  static int hpsa_compat_ioctl(struct scsi_device *dev, int cmd, void *arg);
>  #endif
>
> @@ -513,7 +513,7 @@ static struct scsi_host_template hpsa_driver_template = {
>        .ioctl                  = hpsa_ioctl,
>        .slave_alloc            = hpsa_slave_alloc,
>        .slave_destroy          = hpsa_slave_destroy,
> -#ifdef CONFIG_COMPAT
> +#if IS_ENABLED(COMPAT)
>        .compat_ioctl           = hpsa_compat_ioctl,
>  #endif
>        .sdev_attrs = hpsa_sdev_attrs,
> @@ -2721,7 +2721,7 @@ static void cmd_special_free(struct ctlr_info *h, struct CommandList *c)
>                            c, (dma_addr_t) (c->busaddr & DIRECT_LOOKUP_MASK));
>  }
>
> -#ifdef CONFIG_COMPAT
> +#if IS_ENABLED(COMPAT)
>
>  static int hpsa_ioctl32_passthru(struct scsi_device *dev, int cmd, void *arg)
>  {
> @@ -3972,7 +3972,7 @@ static int find_PCI_BAR_index(struct pci_dev *pdev, unsigned long pci_bar_addr)
>
>  static void __devinit hpsa_interrupt_mode(struct ctlr_info *h)
>  {
> -#ifdef CONFIG_PCI_MSI
> +#if IS_ENABLED(PCI_MSI)
>        int err, i;
>        struct msix_entry hpsa_msix_entries[MAX_REPLY_QUEUES];
>
> @@ -4013,7 +4013,7 @@ static void __devinit hpsa_interrupt_mode(struct ctlr_info *h)
>                        dev_warn(&h->pdev->dev, "MSI init failed\n");
>        }
>  default_int_mode:
> -#endif                         /* CONFIG_PCI_MSI */
> +#endif /* PCI_MSI enabled */
>        /* if we get here we're going to use the default interrupt mode */
>        h->intr[h->intr_mode] = h->pdev->irq;
>  }
> @@ -4187,7 +4187,7 @@ static inline bool hpsa_CISS_signature_present(struct ctlr_info *h)
>  /* Need to enable prefetch in the SCSI core for 6400 in x86 */
>  static inline void hpsa_enable_scsi_prefetch(struct ctlr_info *h)
>  {
> -#ifdef CONFIG_X86
> +#if IS_ENABLED(X86)
>        u32 prefetch;
>
>        prefetch = readl(&(h->cfgtable->SCSI_Prefetch));
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

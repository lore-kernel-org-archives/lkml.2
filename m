Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab2G3RiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:38:22 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65379 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab2G3RiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:38:18 -0400
MIME-Version: 1.0
In-Reply-To: <1342725552-14407-1-git-send-email-lance.ortiz@hp.com>
References: <1342725552-14407-1-git-send-email-lance.ortiz@hp.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 30 Jul 2012 11:37:56 -0600
Message-ID: <CAErSpo6Qc2mw_UpGo0SX=85VOaizpZM_Qx6pDzN1=Vz04bpS3g@mail.gmail.com>
Subject: Re: [PATCH] aerdrv: Enable AER completion notice
To: Lance Ortiz <lance.ortiz@hp.com>
Cc: ying.huang@intel.com, jbarnes@virtuousgeek.org, rusty@rustcorp.com.au,
        mchehab@redhat.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 1:19 PM, Lance Ortiz <lance.ortiz@hp.com> wrote:
> When an AER event occurs not all of the print notifications are at the
> same log level.  This can cause an incomplete AER log from the users
> point of view when monitoring the console output.
>
> The completion message in do_recovery() is currently set to KERN_DEBUG
> (log level 7) while the starting message in aer_port_info() uses
> KERN_INFO(log level 6). The completion message should be set to
> KERN_INFO so it is consistent with the starting message in the log.
>
> The message has also been re-worded to make it more clear.  This patch
> will enable the AER log on the console output to be book-ended by a
> clear and consistent starting and completion message.
>
> Signed-off-by: Lance Ortiz <lance.ortiz@hp.com>
> ---
>  drivers/pci/pcie/aer/aerdrv_core.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
> index 0ca0535..164bab5 100644
> --- a/drivers/pci/pcie/aer/aerdrv_core.c
> +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> @@ -540,14 +540,14 @@ static void do_recovery(struct pci_dev *dev, int severity)
>                                 "resume",
>                                 report_resume);
>
> -       dev_printk(KERN_DEBUG, &dev->dev,
> -               "AER driver successfully recovered\n");
> +       dev_printk(KERN_INFO, &dev->dev,
> +               "AER: Device recovery successful\n");
>         return;
>
>  failed:
>         /* TODO: Should kernel panic here? */
> -       dev_printk(KERN_DEBUG, &dev->dev,
> -               "AER driver didn't recover\n");
> +       dev_printk(KERN_INFO, &dev->dev,
> +               "AER: Device recovery failed\n");
>  }
>
>  /**

I applied this with minor tweaks (using dev_info() rather than
dev_printk(KERN_INFO)).

It won't appear in my "next" branch until I rebuild it after the merge
window closes.

Thanks!

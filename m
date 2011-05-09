Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab1EIO5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 10:57:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44070 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1EIO5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 10:57:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VgfjdcjFqv9PpbhlW67LDRDS4hrnQz/PgLFO/vVVaCYbousZbKvnpl9cCsIDOvsivj
         lxiuLRGxQAPXmsASPTi8QiKm/igOSWHurvzhLna68NwPJb2p1/+bxQz6XokfEErCqT3m
         24edsCXoXQtmjrv9q4uVHEKxjp2rNoSMOaAQo=
MIME-Version: 1.0
In-Reply-To: <1304949119-8250-1-git-send-email-pajot.stephane@gmail.com>
References: <1304949119-8250-1-git-send-email-pajot.stephane@gmail.com>
Date: Mon, 9 May 2011 17:57:30 +0300
Message-ID: <BANLkTik2=pezgunre5QC2HyADbuFP=H1zg@mail.gmail.com>
Subject: Re: [PATCH] Staging: comedi: fix brace coding style issue in
 jr3_pci.c This is a patch to the jr3_pci.c file that fixes up a brace warning
 found by the checkpatch.pl tool Signed-off-by: Stephane Pajot <pajot.stephane@gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Stephane Pajot <pajot.stephane@gmail.com>
Cc: gregkh@suse.de, arun.thomas@gmail.com, ruben.smits@mech.kuleuven.be,
        abbotti@mev.co.uk, ext-andriy.shevchenko@nokia.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p49EvfFu025069

On Mon, May 9, 2011 at 4:51 PM, Stephane Pajot <pajot.stephane@gmail.com> wrote:

Please, split the subject and description with Signed-off-by lines.

> ---
>  drivers/staging/comedi/drivers/jr3_pci.c |   27 +++++++++------------------
>  1 files changed, 9 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
> index 5c6c727..d96140c 100644
> --- a/drivers/staging/comedi/drivers/jr3_pci.c
> +++ b/drivers/staging/comedi/drivers/jr3_pci.c
> @@ -193,9 +193,8 @@ static void set_transforms(volatile struct jr3_channel *channel,
>                set_s16(&channel->transforms[num].link[i].link_amount,
>                        transf.link[i].link_amount);
>                udelay(1);
> -               if (transf.link[i].link_type == end_x_form) {
> +               if (transf.link[i].link_type == end_x_form)
>                        break;
> -               }
>        }
>  }
>
> @@ -460,9 +459,8 @@ static int jr3_download_firmware(struct comedi_device *dev, const u8 * data,
>                                unsigned int count, addr;
>                                more = more
>                                    && read_idm_word(data, size, &pos, &count);
> -                               if (more && count == 0xffff) {
> +                               if (more && count == 0xffff)
>                                        break;
> -                               }
>                                more = more
>                                    && read_idm_word(data, size, &pos, &addr);
>                                printk("Loading#%d %4.4x bytes at %4.4x\n", i,
> @@ -793,9 +791,8 @@ static int jr3_pci_attach(struct comedi_device *dev,
>        }
>
>        result = alloc_private(dev, sizeof(struct jr3_pci_dev_private));
> -       if (result < 0) {
> +       if (result < 0)
>                return -ENOMEM;
> -       }
>        card = NULL;
>        devpriv = dev->private;
>        init_timer(&devpriv->timer);
> @@ -851,9 +848,8 @@ static int jr3_pci_attach(struct comedi_device *dev,
>        }
>
>        result = comedi_pci_enable(card, "jr3_pci");
> -       if (result < 0) {
> +       if (result < 0)
>                return -EIO;
> -       }
>
>        devpriv->pci_enabled = 1;
>        devpriv->iobase = ioremap(pci_resource_start(card, 0),
> @@ -922,9 +918,8 @@ static int jr3_pci_attach(struct comedi_device *dev,
>        result = comedi_load_firmware(dev, "jr3pci.idm", jr3_download_firmware);
>        printk("Firmare load %d\n", result);
>
> -       if (result < 0) {
> +       if (result < 0)
>                goto out;
> -       }
I guess it better to leave blank line here.

>  /*
>  * TODO: use firmware to load preferred offset tables. Suggested
>  * format:
> @@ -973,21 +968,17 @@ static int jr3_pci_detach(struct comedi_device *dev)
>                del_timer_sync(&devpriv->timer);
>
>                if (dev->subdevices) {
> -                       for (i = 0; i < devpriv->n_channels; i++) {
> +                       for (i = 0; i < devpriv->n_channels; i++)
>                                kfree(dev->subdevices[i].private);
> -                       }
>                }
>
> -               if (devpriv->iobase) {
> +               if (devpriv->iobase)
>                        iounmap((void *)devpriv->iobase);
> -               }
> -               if (devpriv->pci_enabled) {
> +               if (devpriv->pci_enabled)
>                        comedi_pci_disable(devpriv->pci_dev);
> -               }
>
> -               if (devpriv->pci_dev) {
> +               if (devpriv->pci_dev)
>                        pci_dev_put(devpriv->pci_dev);
> -               }
>        }
>        return 0;
>  }
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
With Best Regards,
Andy Shevchenko
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�

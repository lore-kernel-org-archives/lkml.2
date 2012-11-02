Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab2KBNFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:05:34 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53343 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab2KBNFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 09:05:32 -0400
MIME-Version: 1.0
In-Reply-To: <1351846129-19432-1-git-send-email-yamanetoshi@gmail.com>
References: <1351846129-19432-1-git-send-email-yamanetoshi@gmail.com>
Date: Fri, 2 Nov 2012 14:05:31 +0100
Message-ID: <CA+MoWDpRDHXUj7jn38FFbew5X1T=ZqbjZu4OzTV736Z8Bu=2pg@mail.gmail.com>
Subject: Re: [PATCH] staging/media: Use dev_ printks in cxd2099/cxd2099.[ch]
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        linux-media <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 9:48 AM, YAMANE Toshiaki <yamanetoshi@gmail.com> wrote:
> fixed below checkpatch warnings.
> - WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
> - WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> - WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...
>
> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
Tested-by: Peter Senna Tschudin <peter.senna@gmail.com>
> ---
>  drivers/staging/media/cxd2099/cxd2099.c |   29 +++++++++++++++--------------
>  drivers/staging/media/cxd2099/cxd2099.h |    2 +-
>  2 files changed, 16 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
> index 0ff1972..822c487 100644
> --- a/drivers/staging/media/cxd2099/cxd2099.c
> +++ b/drivers/staging/media/cxd2099/cxd2099.c
> @@ -66,8 +66,9 @@ static int i2c_write_reg(struct i2c_adapter *adapter, u8 adr,
>         struct i2c_msg msg = {.addr = adr, .flags = 0, .buf = m, .len = 2};
>
>         if (i2c_transfer(adapter, &msg, 1) != 1) {
> -               printk(KERN_ERR "Failed to write to I2C register %02x@%02x!\n",
> -                      reg, adr);
> +               dev_err(&adapter->dev,
> +                       "Failed to write to I2C register %02x@%02x!\n",
> +                       reg, adr);
>                 return -1;
>         }
>         return 0;
> @@ -79,7 +80,7 @@ static int i2c_write(struct i2c_adapter *adapter, u8 adr,
>         struct i2c_msg msg = {.addr = adr, .flags = 0, .buf = data, .len = len};
>
>         if (i2c_transfer(adapter, &msg, 1) != 1) {
> -               printk(KERN_ERR "Failed to write to I2C!\n");
> +               dev_err(&adapter->dev, "Failed to write to I2C!\n");
>                 return -1;
>         }
>         return 0;
> @@ -94,7 +95,7 @@ static int i2c_read_reg(struct i2c_adapter *adapter, u8 adr,
>                                    .buf = val, .len = 1} };
>
>         if (i2c_transfer(adapter, msgs, 2) != 2) {
> -               printk(KERN_ERR "error in i2c_read_reg\n");
> +               dev_err(&adapter->dev, "error in i2c_read_reg\n");
>                 return -1;
>         }
>         return 0;
> @@ -109,7 +110,7 @@ static int i2c_read(struct i2c_adapter *adapter, u8 adr,
>                                  .buf = data, .len = n} };
>
>         if (i2c_transfer(adapter, msgs, 2) != 2) {
> -               printk(KERN_ERR "error in i2c_read\n");
> +               dev_err(&adapter->dev, "error in i2c_read\n");
>                 return -1;
>         }
>         return 0;
> @@ -277,7 +278,7 @@ static void cam_mode(struct cxd *ci, int mode)
>  #ifdef BUFFER_MODE
>                 if (!ci->en.read_data)
>                         return;
> -               printk(KERN_INFO "enable cam buffer mode\n");
> +               dev_info(&ci->i2c->dev, "enable cam buffer mode\n");
>                 /* write_reg(ci, 0x0d, 0x00); */
>                 /* write_reg(ci, 0x0e, 0x01); */
>                 write_regm(ci, 0x08, 0x40, 0x40);
> @@ -524,7 +525,7 @@ static int slot_reset(struct dvb_ca_en50221 *ca, int slot)
>                         msleep(10);
>  #if 0
>                         read_reg(ci, 0x06, &val);
> -                       printk(KERN_INFO "%d:%02x\n", i, val);
> +                       dev_info(&ci->i2c->dev, "%d:%02x\n", i, val);
>                         if (!(val&0x10))
>                                 break;
>  #else
> @@ -542,7 +543,7 @@ static int slot_shutdown(struct dvb_ca_en50221 *ca, int slot)
>  {
>         struct cxd *ci = ca->data;
>
> -       printk(KERN_INFO "slot_shutdown\n");
> +       dev_info(&ci->i2c->dev, "slot_shutdown\n");
>         mutex_lock(&ci->lock);
>         write_regm(ci, 0x09, 0x08, 0x08);
>         write_regm(ci, 0x20, 0x80, 0x80); /* Reset CAM Mode */
> @@ -578,10 +579,10 @@ static int campoll(struct cxd *ci)
>
>         if (istat&0x40) {
>                 ci->dr = 1;
> -               printk(KERN_INFO "DR\n");
> +               dev_info(&ci->i2c->dev, "DR\n");
>         }
>         if (istat&0x20)
> -               printk(KERN_INFO "WC\n");
> +               dev_info(&ci->i2c->dev, "WC\n");
>
>         if (istat&2) {
>                 u8 slotstat;
> @@ -597,7 +598,7 @@ static int campoll(struct cxd *ci)
>                         if (ci->slot_stat) {
>                                 ci->slot_stat = 0;
>                                 write_regm(ci, 0x03, 0x00, 0x08);
> -                               printk(KERN_INFO "NO CAM\n");
> +                               dev_info(&ci->i2c->dev, "NO CAM\n");
>                                 ci->ready = 0;
>                         }
>                 }
> @@ -634,7 +635,7 @@ static int read_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
>         campoll(ci);
>         mutex_unlock(&ci->lock);
>
> -       printk(KERN_INFO "read_data\n");
> +       dev_info(&ci->i2c->dev, "read_data\n");
>         if (!ci->dr)
>                 return 0;
>
> @@ -687,7 +688,7 @@ struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
>         u8 val;
>
>         if (i2c_read_reg(i2c, cfg->adr, 0, &val) < 0) {
> -               printk(KERN_INFO "No CXD2099 detected at %02x\n", cfg->adr);
> +               dev_info(&i2c->dev, "No CXD2099 detected at %02x\n", cfg->adr);
>                 return NULL;
>         }
>
> @@ -705,7 +706,7 @@ struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
>         ci->en = en_templ;
>         ci->en.data = ci;
>         init(ci);
> -       printk(KERN_INFO "Attached CXD2099AR at %02x\n", ci->cfg.adr);
> +       dev_info(&i2c->dev, "Attached CXD2099AR at %02x\n", ci->cfg.adr);
>         return &ci->en;
>  }
>  EXPORT_SYMBOL(cxd2099_attach);
> diff --git a/drivers/staging/media/cxd2099/cxd2099.h b/drivers/staging/media/cxd2099/cxd2099.h
> index 19c588a..0eb607c 100644
> --- a/drivers/staging/media/cxd2099/cxd2099.h
> +++ b/drivers/staging/media/cxd2099/cxd2099.h
> @@ -43,7 +43,7 @@ struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
>  static inline struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
>                                         void *priv, struct i2c_adapter *i2c)
>  {
> -       printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> +       dev_warn(&i2c->dev, "%s: driver disabled by Kconfig\n", __func__);
>         return NULL;
>  }
>  #endif
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
Peter

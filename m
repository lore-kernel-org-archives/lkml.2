Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab1HLImw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:42:52 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:40426 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab1HLIms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:42:48 -0400
X-ASG-Debug-ID: 1313138566-01de281ca6011f0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E44E782.7090309@fusionio.com>
Date: Fri, 12 Aug 2011 10:42:42 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONTRACTOR]" 
	<asamymuthupa@micron.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Moyer <jmoyer@redhat.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 2/3] drivers/block/mtip32xx: Adding source for hardware
  related operations
References: <22A973199D2C2F46933448F6E7990A3002C80026@ntxboimbx31.micron.com>
X-ASG-Orig-Subj: Re: [PATCH v3 2/3] drivers/block/mtip32xx: Adding source for hardware
  related operations
In-Reply-To: <22A973199D2C2F46933448F6E7990A3002C80026@ntxboimbx31.micron.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1313138566
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.50
X-Barracuda-Spam-Status: No, SCORE=0.50 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_RULE7568M
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.71535
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.50 BSF_RULE7568M          Custom Rule 7568M
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-11 20:52, Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONTRACTOR] wrote:
> +#define HW_CMD_TBL_HDR_SZ      0x80
> +#define HW_RX_FIS_SZ           0x100
> +#define HW_CMD_SLOT_SZ         (MTIP_MAX_COMMAND_SLOTS * 32)
> +#define HW_CMD_TBL_SZ          (HW_CMD_TBL_HDR_SZ + (MTIP_MAX_SG * 16))
> +#define HW_CMD_TBL_AR_SZ       (HW_CMD_TBL_SZ * MTIP_MAX_COMMAND_SLOTS)
> +#define HW_PORT_PRIV_DMA_SZ \
> +               (HW_CMD_SLOT_SZ + HW_CMD_TBL_AR_SZ + HW_RX_FIS_SZ)
> +
> +#define HBA_CAPS               0x00
> +#define        HOST_CTRL               0x04
> +#define HOST_IRQ_STAT          0x08
> +#define PORTS_IMPL             0x0c
> +#define VERSION                        0x10
> +#define CCCC                   0x14
> +#define CCCP                   0x18
> +#define        EML                     0x1c
> +#define        EMC                     0x20
> +#define        EX_HOST_CAP             0x24
> +
> +#define HOST_CAP_64            (1 << 31)
> +#define        HOST_IRQ_EN             (1 << 1)
> +#define        HOST_RESET              (1 << 0)
> +#define HOST_HSORG             0xFC
> +#define HSORG_DISABLE_SLOTGRP_INTR (1<<24)
> +#define HSORG_DISABLE_SLOTGRP_PXIS (1<<16)
> +#define HSORG_HWREV            0xFF00
> +#define HSORG_STYLE            0x8
> +#define HSORG_SLOTGROUPS       0x7
> +
> +#define PORT_LST_ADDR          0x00
> +#define PORT_LST_ADDR_HI       0x04
> +#define PORT_FIS_ADDR          0x08
> +#define PORT_FIS_ADDR_HI       0x0c
> +#define PORT_IRQ_STAT          0x10
> +#define PORT_IRQ_EN            0x14
> +#define PORT_CMD               0x18
> +#define PORT_TFDATA            0x20
> +#define PORT_SCR_STAT          0x28
> +#define PORT_SCR_CTL           0x2c
> +#define PORT_SCR_ERR           0x30
> +#define PORT_SACTIVE           0x34
> +#define PORT_COMMAND_ISSUE     0x38
> +#define PORT_SCR_NTF           0x3c
> +#define PORT_SDBV              0x7C
> +
> +#define PORT_CMD_ICC_ACTIVE    (1 << 28)
> +#define PORT_CMD_LIST_ON       (1 << 15)
> +#define PORT_CMD_FIS_RX                (1 << 4)
> +#define PORT_CMD_CLO           (1 << 3)
> +#define PORT_CMD_START         (1 << 0)
> +#define PORT_OFFSET            0x100
> +#define PORT_MEM_SIZE          0x80
> +#define        RX_FIS_D2H_REG          0x40
> +#define        RX_FIS_PIO              0x20
> +
> +#define        PORT_IRQ_COLD_PRES      (1 << 31)
> +#define        PORT_IRQ_TF_ERR         (1 << 30)
> +#define        PORT_IRQ_HBUS_ERR       (1 << 29)
> +#define        PORT_IRQ_HBUS_DATA_ERR  (1 << 28)
> +#define        PORT_IRQ_IF_ERR         (1 << 27)
> +#define        PORT_IRQ_IF_NONFATAL    (1 << 26)
> +#define        PORT_IRQ_OVERFLOW       (1 << 24)
> +#define        PORT_IRQ_BAD_PMP        (1 << 23)
> +#define        PORT_IRQ_PHYRDY         (1 << 22)
> +#define        PORT_IRQ_DEV_ILCK       (1 << 7)
> +#define        PORT_IRQ_CONNECT        (1 << 6)
> +#define        PORT_IRQ_DPS            (1 << 5)
> +#define        PORT_IRQ_UNK_FIS        (1 << 4)
> +#define        PORT_IRQ_SDB_FIS        (1 << 3)
> +#define        PORT_IRQ_DMAS_FIS       (1 << 2)
> +#define        PORT_IRQ_PIOS_FIS       (1 << 1)
> +#define        PORT_IRQ_D2H_REG_FIS    (1 << 0)

Again lots of things that should be shared with ahci.

> +/*
> + * Obtain an empty command slot.
> + *
> + * This function needs to be reentrant since it could be called
> + * at the same time on multiple CPUs. The allocation of the
> + * command slot must be atomic.
> + *
> + * @port Pointer to the port data structure.
> + *
> + * return value
> + *     >= 0    Index of command slot obtained.
> + *     -1      No command slots available.
> + */
> +static int get_slot(struct mtip_port *port)
> +{
> +       int slot, i;
> +       unsigned int num_command_slots = port->dd->slot_groups * 32;
> +
> +       /*
> +        * Try 10 times, because there is a small race here.
> +        *  that's ok, because it's still cheaper than a lock.
> +        */

Might want to expand on what that race is.

> +static irqreturn_t mtip_irq_handler(int irq, void *instance)
> +{
> +       struct driver_data *dd = instance;
> +#ifdef MTIP_USE_TASKLET
> +       tasklet_schedule(&dd->tasklet);
> +       return IRQ_HANDLED;
> +#else
> +       return mtip_handle_irq(dd);
> +#endif
> +}

Have you experimented with blk-iopoll?

> +/*
> + * Byte-swap ATA ID strings.
> + *
> + * ATA identify data contains strings in byte-swapped 16-bit words.
> + * They must be swapped (on all architectures) to be usable as C
> strings.
> + * This function swaps bytes in-place.
> + *
> + * @buf The buffer location of the string
> + * @len The number of bytes to swap
> + *
> + * return value
> + *     None
> + */
> +static inline void ata_swap_string(u16 *buf, unsigned int len)
> +{
> +       int i;
> +       for (i = 0; i < (len/2); i++)
> +               be16_to_cpus(&buf[i]);
> +}

I'm pretty sure we have the exact same thing in IDE and libata, so lets
put this somewhere we they can all use it.

Overall looks very clean. If you take care of the little things
mentioned by me and Christoph, I don't see anything stopping this from
being merged for 3.2.

-- 
Jens Axboe


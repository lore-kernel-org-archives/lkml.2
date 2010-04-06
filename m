Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab0DFPQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 11:16:31 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:26413 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0DFPQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:16:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=slTZDGUQN1uyPpqA9JBMRrG3k/zlBSADf4fcPLunIvKTzWVidnX/EjvuLQongeHSsP
         8hsY1Y99EQn7nKRT0G3B+3BCB93B/9ZMNusvXkgwIYaZuy5AroS0fbeDO7BbdmITVp/k
         xr7EyHV8UdhmIqNcvAAYM+xC6aBuhmZQmpnMc=
Message-ID: <4BBB5045.5020004@pobox.com>
Date: Tue, 06 Apr 2010 11:16:21 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Rupjyoti Sarmah <rsarmah@amcc.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, sr@denx.de,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] 460EX on-chip SATA driver<kernel 2.6.33> < resubmission
 : 02>
References: <201004061141.o36BfTsr028163@amcc.com>
In-Reply-To: <201004061141.o36BfTsr028163@amcc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 07:41 AM, Rupjyoti Sarmah wrote:

General comment:  remove "inline" and let the compiler select those 
functions that need it.


> +struct sata_dwc_host_priv {
> +
> +	void __iomem *scr_addr_sstatus;
> +	u32 sata_dwc_sactive_issued;
> +	u32 sata_dwc_sactive_queued;
> +	u32 dma_interrupt_count;
> +	struct ahb_dma_regs *sata_dma_regs;
> +	struct device *dwc_dev;
> +
> +};

use proper indentation (separate type from member name with tabs)


> +struct sata_dwc_host_priv host_pvt;
> +
> +/*
> + * Prototypes
> + */
> +static void sata_dwc_bmdma_start_by_tag(struct ata_queued_cmd *qc, u8 tag);
> +static int sata_dwc_qc_complete(struct ata_port *ap, struct ata_queued_cmd *qc,
> +				u32 check_status);
> +static void sata_dwc_dma_xfer_complete(struct ata_port *ap, u32 check_status);
> +static void sata_dwc_port_stop(struct ata_port *ap);
> +static void sata_dwc_clear_dmacr(struct sata_dwc_device_port *hsdevp, u8 tag);
> +
> +static int dma_dwc_init(struct sata_dwc_device *hsdev, int irq);
> +static void dma_dwc_exit(struct sata_dwc_device *hsdev);
> +static int dma_dwc_xfer_setup(struct scatterlist *sg, int num_elems,
> +			      struct lli *lli, dma_addr_t dma_lli,
> +			      void __iomem *addr, int dir);
> +static void dma_dwc_xfer_start(int dma_ch);
> +
> +static const char *dir_2_txt(enum dma_data_direction dir)
> +{
> +	switch (dir) {
> +	case DMA_BIDIRECTIONAL:
> +		return "bi";
> +	case DMA_FROM_DEVICE:
> +		return "from";
> +	case DMA_TO_DEVICE:
> +		return "to";
> +	case DMA_NONE:
> +		return "none";
> +	default:
> +		return "err";
> +	}
> +}
> +
> +static const char *prot_2_txt(enum ata_tf_protocols protocol)
> +{
> +	switch (protocol) {
> +	case ATA_PROT_UNKNOWN:
> +		return "unknown";
> +	case ATA_PROT_NODATA:
> +		return "nodata";
> +	case ATA_PROT_PIO:
> +		return "pio";
> +	case ATA_PROT_DMA:
> +		return "dma";
> +	case ATA_PROT_NCQ:
> +		return "ncq";
> +	case ATAPI_PROT_PIO:
> +		return "atapi pio";
> +	case ATAPI_PROT_NODATA:
> +		return "atapi nodata";
> +	case ATAPI_PROT_DMA:
> +		return "atapi dma";
> +	default:
> +		return "err";
> +	}
> +}
> +
> +inline const char *ata_cmd_2_txt(const struct ata_taskfile *tf)
> +{
> +	switch (tf->command) {
> +	case ATA_CMD_CHK_POWER:
> +		return "ATA_CMD_CHK_POWER";
> +	case ATA_CMD_EDD:
> +		return "ATA_CMD_EDD";
> +	case ATA_CMD_FLUSH:
> +		return "ATA_CMD_FLUSH";
> +	case ATA_CMD_FLUSH_EXT:
> +		return "ATA_CMD_FLUSH_EXT";
> +	case ATA_CMD_ID_ATA:
> +		return "ATA_CMD_ID_ATA";
> +	case ATA_CMD_ID_ATAPI:
> +		return "ATA_CMD_ID_ATAPI";
> +	case ATA_CMD_FPDMA_READ:
> +		return "ATA_CMD_FPDMA_READ";
> +	case ATA_CMD_FPDMA_WRITE:
> +		return "ATA_CMD_FPDMA_WRITE";
> +	case ATA_CMD_READ:
> +		return "ATA_CMD_READ";
> +	case ATA_CMD_READ_EXT:
> +		return "ATA_CMD_READ_EXT";
> +	case ATA_CMD_READ_NATIVE_MAX_EXT:
> +		return "ATA_CMD_READ_NATIVE_MAX_EXT";
> +	case ATA_CMD_VERIFY_EXT:
> +		return "ATA_CMD_VERIFY_EXT";
> +	case ATA_CMD_WRITE:
> +		return "ATA_CMD_WRITE";
> +	case ATA_CMD_WRITE_EXT:
> +		return "ATA_CMD_WRITE_EXT";
> +	case ATA_CMD_PIO_READ:
> +		return "ATA_CMD_PIO_READ";
> +	case ATA_CMD_PIO_READ_EXT:
> +		return "ATA_CMD_PIO_READ_EXT";
> +	case ATA_CMD_PIO_WRITE:
> +		return "ATA_CMD_PIO_WRITE";
> +	case ATA_CMD_PIO_WRITE_EXT:
> +		return "ATA_CMD_PIO_WRITE_EXT";
> +	case ATA_CMD_SET_FEATURES:
> +		return "ATA_CMD_SET_FEATURES";
> +	case ATA_CMD_PACKET:
> +		return "ATA_CMD_PACKET";
> +	default:
> +		return "ATA_CMD_???";
> +	}

use ata_get_cmd_descript() rather than duplicating it

> +static irqreturn_t dma_dwc_interrupt(int irq, void *hsdev_instance)
> +{
> +	int chan;
> +	u32 tfr_reg, err_reg;
> +
> +	struct sata_dwc_device *hsdev =
> +		(struct sata_dwc_device *) hsdev_instance;
> +	struct ata_host *host = (struct ata_host *) hsdev->host;
> +	struct ata_port *ap;
> +	struct sata_dwc_device_port *hsdevp;
> +	u8 tag = 0;
> +	unsigned int port = 0;
> +	struct sata_dwc_host_priv *hp;
> +	hp = kmalloc(sizeof(*hp), GFP_KERNEL);

1) interrupt is not GFP_KERNEL

2) you must failure kmalloc failure

3) it is not clear to me where you initialize this structure???


> +	spin_lock(&host->lock);
> +
> +	ap = host->ports[port];
> +	hsdevp = HSDEVP_FROM_AP(ap);
> +	tag = ap->link.active_tag;
> +
> +	tfr_reg = in_le32(&(host_pvt.sata_dma_regs->interrupt_status.tfr.low));
> +	err_reg = in_le32(&(host_pvt.sata_dma_regs->  \
> +					interrupt_status.error.low));
> +
> +	dev_dbg(ap->dev, "eot=0x%08x err=0x%08x pending=%d active port=%d\n",
> +		tfr_reg, err_reg, hsdevp->dma_pending[tag], port);
> +
> +	for (chan = 0; chan<  DMA_NUM_CHANS; chan++) {
> +		/* Check for end-of-transfer interrupt. */
> +		if (tfr_reg&  DMA_CHANNEL(chan)) {
> +			/* Each DMA command produces 2 interrupts.  Only
> +			 * complete the command after both interrupts have been
> +			 * seen. (See sata_dwc_isr())
> +			 */
> +			hp->dma_interrupt_count++;
> +
> +			sata_dwc_clear_dmacr(hsdevp, tag);
> +
> +			if (hsdevp->dma_pending[tag] ==
> +			    SATA_DWC_DMA_PENDING_NONE) {
> +				dev_err(ap->dev, "DMA not pending eot=0x%08x "
> +					"err=0x%08x tag=0x%02x pending=%d\n",
> +					tfr_reg, err_reg, tag,
> +					hsdevp->dma_pending[tag]);
> +			}
> +
> +			if ((hp->dma_interrupt_count) % 2 == 0)
> +				sata_dwc_dma_xfer_complete(ap, 1);
> +
> +			/* Clear the interrupt */
> +			out_le32(&(host_pvt.sata_dma_regs->  \
> +				interrupt_clear.tfr.low), DMA_CHANNEL(chan));
> +		}
> +
> +		/* Check for error interrupt. */
> +		if (err_reg&  DMA_CHANNEL(chan)) {
> +			/* Error handler ! */
> +			dev_err(ap->dev, "error interrupt err_reg=0x%08x\n",
> +				err_reg);
> +
> +			/* Clear the interrupt. */
> +			out_le32(&(host_pvt.sata_dma_regs->interrupt_clear.\
> +			error.low), DMA_CHANNEL(chan));
> +		}
> +	}
> +
> +	spin_unlock(&host->lock);
> +	kfree(hp);
> +
> +	return IRQ_HANDLED;
> +}

> +static inline void clear_serror(void)
> +{
> +	out_le32((host_pvt.scr_addr_sstatus) + 4,
> +		 in_le32((host_pvt.scr_addr_sstatus) + 4));
> +}

this should be defined in terms of scr_read/write functions defined 
previously.


> +/* See ahci.c */
> +static void sata_dwc_error_intr(struct ata_port *ap,
> +				struct sata_dwc_device *hsdev, uint intpr)
> +{
> +	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
> +	struct ata_eh_info *ehi =&ap->link.eh_info;
> +	unsigned int err_mask = 0, action = 0;
> +	struct ata_queued_cmd *qc;
> +	u32 serror;
> +	u8 status, tag;
> +	u32 err_reg;
> +	struct sata_dwc_host_priv *hp;
> +	hp = kmalloc(sizeof(*hp), GFP_KERNEL);

ditto above 3 comments about 'hp'


> +	ata_ehi_clear_desc(ehi);
> +
> +	serror = core_scr_read(SCR_ERROR);
> +	status = ap->ops->sff_check_status(ap);
> +
> +	err_reg = in_le32(&(host_pvt.sata_dma_regs->  \
> +				interrupt_status.error.low));
> +	tag = ap->link.active_tag;
> +
> +	dev_err(ap->dev, "%s SCR_ERROR=0x%08x intpr=0x%08x status=0x%08x "
> +		"dma_intp=%d pending=%d issued=%d dma_err_status=0x%08x\n",
> +		__func__, serror, intpr, status, hp->dma_interrupt_count,
> +		hsdevp->dma_pending[tag], hsdevp->cmd_issued[tag], err_reg);
> +
> +	/* Clear error register and interrupt bit */
> +	clear_serror();
> +	clear_interrupt_bit(hsdev, SATA_DWC_INTPR_ERR);
> +
> +	/* This is the only error happening now. */
> +	err_mask |= AC_ERR_HOST_BUS;
> +	action |= ATA_EH_RESET;
> +
> +	/* Pass this on to EH */
> +	ehi->serror |= serror;
> +	ehi->action |= action;
> +
> +	qc = ata_qc_from_tag(ap, tag);
> +	if (qc)
> +		qc->err_mask |= err_mask;
> +	else
> +		ehi->err_mask |= err_mask;
> +
> +	ata_port_abort(ap);
> +	kfree(hp);
> +
> +	/*
> +	  if (irq_stat&  PORT_IRQ_FREEZE)
> +	  ata_port_freeze(ap);
> +	  else
> +	  ata_port_abort(ap);
> +	*/
> +}
> +
> +/*
> + * Function : sata_dwc_isr
> + * arguments : irq, void *dev_instance, struct pt_regs *regs
> + * Return value : irqreturn_t - status of IRQ
> + * This Interrupt handler called via port ops registered function.
> + * .irq_handler = sata_dwc_isr
> + */
> +static irqreturn_t sata_dwc_isr(int irq, void *dev_instance)
> +{
> +	u8 status, tag;
> +	int handled, num_processed, port = 0;
> +	uint intpr, sactive, sactive2, tag_mask;
> +	struct sata_dwc_device_port *hsdevp;
> +	struct ata_host *host = (struct ata_host *)dev_instance;
> +	struct sata_dwc_device *hsdev = HSDEV_FROM_HOST(host);
> +	struct ata_port *ap;
> +	struct ata_queued_cmd *qc;
> +	struct sata_dwc_host_priv *hp;
> +
> +	hp = kmalloc(sizeof(*hp), GFP_KERNEL);
> +	hp->sata_dwc_sactive_issued = 0;

ditto above 3 comments about 'hp'


> +	spin_lock(&host->lock);
> +
> +	/* Read the interrupt register */
> +	intpr = in_le32(&hsdev->sata_dwc_regs->intpr);
> +
> +	ap = host->ports[port];
> +	hsdevp = HSDEVP_FROM_AP(ap);
> +
> +	dev_dbg(ap->dev, "%s intpr=0x%08x active_tag=%d\n", __func__, intpr,
> +		ap->link.active_tag);
> +
> +	/* Check for error interrupt */
> +	if (intpr&  SATA_DWC_INTPR_ERR) {
> +		sata_dwc_error_intr(ap, hsdev, intpr);
> +		handled = 1;
> +		goto DONE;
> +	}
> +
> +	/* Check for DMA SETUP FIS (FP DMA) interrupt */
> +	if (intpr&  SATA_DWC_INTPR_NEWFP) {
> +		clear_interrupt_bit(hsdev, SATA_DWC_INTPR_NEWFP);
> +
> +		tag = (u8)(in_le32(&hsdev->sata_dwc_regs->fptagr));
> +		dev_dbg(ap->dev, "%s: NEWFP tag=%d\n", __func__, tag);
> +		if (hsdevp->cmd_issued[tag] != SATA_DWC_CMD_ISSUED_PEND)
> +			dev_warn(ap->dev, "CMD tag=%d not pending?\n", tag);
> +
> +		hp->sata_dwc_sactive_issued |= qcmd_tag_to_mask(tag);
> +
> +		qc = ata_qc_from_tag(ap, tag);
> +		/* Start FP DMA for NCQ command.  At this point the tag is the
> +		 * active tag.  It is the tag that matches the command about to
> +		 * be completed.
> +		 */
> +		qc->ap->link.active_tag = tag;
> +		sata_dwc_bmdma_start_by_tag(qc, tag);
> +
> +		handled = 1;
> +		goto DONE;
> +	}
> +	sactive = core_scr_read(SCR_ACTIVE);
> +	tag_mask = (hp->sata_dwc_sactive_issued | sactive) ^ sactive;
> +
> +	/* If no sactive issued and tag_mask is zero then this is not NCQ */
> +	if (hp->sata_dwc_sactive_issued == 0&&  tag_mask == 0) {
> +		if (ap->link.active_tag == ATA_TAG_POISON)
> +			tag = 0;
> +		else
> +			tag = ap->link.active_tag;
> +		qc = ata_qc_from_tag(ap, tag);
> +
> +		/* DEV interrupt w/ no active qc? */
> +		if (unlikely(!qc || (qc->tf.flags&  ATA_TFLAG_POLLING))) {
> +			dev_err(ap->dev, "%s interrupt with no active qc "
> +				"qc=%p\n", __func__, qc);
> +			ata_sff_check_status(ap);
> +			handled = 1;
> +			goto DONE;
> +		}
> +
> +		status = ap->ops->sff_check_status(ap);

either call ->sff_check_status or ata_sff_check_status(), pick one.  in 
above code, you do both.


> +		qc->ap->link.active_tag = tag;
> +		hsdevp->cmd_issued[tag] = SATA_DWC_CMD_ISSUED_NOT;
> +
> +		if (status&  ATA_ERR) {
> +			dev_dbg(ap->dev, "interrupt ATA_ERR (0x%x)\n", status);
> +			sata_dwc_qc_complete(ap, qc, 1);
> +			handled = 1;
> +			goto DONE;
> +		}
> +
> +		dev_dbg(ap->dev, "%s non-NCQ cmd interrupt, protocol: %s\n",
> +			__func__, prot_2_txt(qc->tf.protocol));
> +DRVSTILLBUSY:
> +		if (ata_is_dma(qc->tf.protocol)) {
> +			/* Each DMA transaction produces 2 interrupts.  The DMAC
> +			 * transfer complete interrupt and the SATA controller
> +			 * operation done interrupt. The command should be
> +			 * completed only after both interrupts are seen.
> +			 */
> +			hp->dma_interrupt_count++;
> +			if (hsdevp->dma_pending[tag] == \
> +					SATA_DWC_DMA_PENDING_NONE) {
> +				dev_err(ap->dev, "%s: DMA not pending "
> +				"intpr=0x%08x status=0x%08x pending=%d\n",
> +				__func__, intpr, status,
> +					hsdevp->dma_pending[tag]);
> +			}
> +
> +			if ((hp->dma_interrupt_count) % 2 == 0)
> +				sata_dwc_dma_xfer_complete(ap, 1);
> +		} else if (ata_is_pio(qc->tf.protocol)) {
> +			ata_sff_hsm_move(ap, qc, status, 0);
> +			handled = 1;
> +			goto DONE;
> +		} else {
> +			if (unlikely(sata_dwc_qc_complete(ap, qc, 1)))
> +				goto DRVSTILLBUSY;
> +		}
> +
> +		handled = 1;
> +		goto DONE;
> +	}
> +
> +	/*
> +	 * This is NCQ command.  At this point we need to figure out for which
> +	 * tags we have gotten a completion interrupt.  One interrupt may serve
> +	 * as completion for more than one operation when commands are queued
> +	 * (NCQ).  We need to process each completed command.
> +	 */
> +
> +PROCESS:  /* process completed commands */
> +	sactive = core_scr_read(SCR_ACTIVE);
> +	tag_mask = (hp->sata_dwc_sactive_issued | sactive) ^ sactive;
> +
> +	if (sactive != 0 || hp->sata_dwc_sactive_issued>  1 || tag_mask>  1) {
> +		dev_dbg(ap->dev, "%s NCQ:sactive=0x%08x sactive_issued=0x%08x "
> +			"tag_mask=0x%08x\n", __func__, sactive,
> +			hp->sata_dwc_sactive_issued, tag_mask);
> +	}
> +
> +	if ((tag_mask | (hp->sata_dwc_sactive_issued)) != \
> +				(hp->sata_dwc_sactive_issued)) {
> +		dev_warn(ap->dev, "Bad tag mask?  sactive=0x%08x "
> +			 "hp->sata_dwc_sactive_issued=0x%08x tag_mask=0x%08x\n"
> +			 , sactive, hp->sata_dwc_sactive_issued, tag_mask);
> +	}
> +
> +	/* read just to clear ... not bad if currently still busy */
> +	status = ap->ops->sff_check_status(ap);
> +	dev_dbg(ap->dev, "%s ATA status register=0x%x\n", __func__, status);
> +
> +	tag = 0;
> +	num_processed = 0;
> +	while (tag_mask) {
> +		num_processed++;
> +		while (!(tag_mask&  0x00000001)) {
> +			tag++;
> +			tag_mask>>= 1;
> +		}
> +		tag_mask&= (~0x00000001);
> +		qc = ata_qc_from_tag(ap, tag);
> +
> +		/* To be picked up by completion functions */
> +		qc->ap->link.active_tag = tag;
> +		hsdevp->cmd_issued[tag] = SATA_DWC_CMD_ISSUED_NOT;
> +
> +		/* Let libata/scsi layers handle error */
> +		if (status&  ATA_ERR) {
> +			dev_dbg(ap->dev, "%s ATA_ERR (0x%x)\n", __func__,
> +				status);
> +			sata_dwc_qc_complete(ap, qc, 1);
> +			handled = 1;
> +			goto DONE;
> +		}
> +
> +		/* Process completed command */
> +		dev_dbg(ap->dev, "%s NCQ command, protocol: %s\n", __func__,
> +			prot_2_txt(qc->tf.protocol));
> +		if (ata_is_dma(qc->tf.protocol)) {
> +			hp->dma_interrupt_count++;
> +			if (hsdevp->dma_pending[tag] == \
> +					SATA_DWC_DMA_PENDING_NONE)
> +				dev_warn(ap->dev, "%s: DMA not pending?\n",
> +					__func__);
> +			if ((hp->dma_interrupt_count) % 2 == 0)
> +				sata_dwc_dma_xfer_complete(ap, 1);
> +		} else {
> +			if (unlikely(sata_dwc_qc_complete(ap, qc, 1)))
> +				goto STILLBUSY;
> +		}
> +		continue;
> +
> +STILLBUSY:
> +		ap->stats.idle_irq++;
> +		dev_warn(ap->dev, "STILL BUSY IRQ ata%d: irq trap\n",
> +			 ap->print_id);
> +	} /* while tag_mask */
> +
> +	/*
> +	 * Check to see if any commands completed while we were processing our
> +	 * initial set of completed commands (reading of status clears
> +	 * interrupts, so we might miss a completed command interrupt if one
> +	 * came in while we were processing --we read status as part of
> +	 * processing a completed command).
> +	 */
> +	sactive2 = core_scr_read(SCR_ACTIVE);
> +	if (sactive2 != sactive) {
> +		dev_dbg(ap->dev, "More completed-sactive=0x%x sactive2=0x%x\n",
> +			sactive, sactive2);
> +		goto PROCESS;

this appears to be a recipe for an infinite loop?


> +/*
> + * Function : sata_dwc_port_start
> + * arguments : struct ata_ioports *port
> + * Return value : returns 0 if success, error code otherwise
> + * This function allocates the scatter gather LLI table for AHB DMA
> + */
> +static int sata_dwc_port_start(struct ata_port *ap)
> +{
> +	int err = 0;
> +	struct sata_dwc_device *hsdev;
> +	struct sata_dwc_device_port *hsdevp = NULL;
> +	struct device *pdev;
> +	u32 sstatus;
> +	int i;
> +
> +	hsdev = HSDEV_FROM_AP(ap);
> +
> +	dev_dbg(ap->dev, "%s: port_no=%d\n", __func__, ap->port_no);
> +
> +	hsdev->host = ap->host;
> +	pdev = ap->host->dev;
> +	if (!pdev) {
> +		dev_err(ap->dev, "%s: no ap->host->dev\n", __func__);
> +		err = -ENODEV;
> +		goto CLEANUP;
> +	}
> +
> +	/* Allocate Port Struct */
> +	hsdevp = kmalloc(sizeof(*hsdevp), GFP_KERNEL);
> +	if (!hsdevp) {
> +		dev_err(ap->dev, "%s: kmalloc failed for hsdevp\n", __func__);
> +		err = -ENOMEM;
> +		goto CLEANUP;
> +	}
> +	memset(hsdevp, 0, sizeof(*hsdevp));

use kzalloc()


> +	/* Clear any error bits before libata starts issuing commands */
> +	clear_serror();
> +
> +	ap->private_data = hsdevp;
> +
> +	/* Are we in Gen I or II */
> +	sstatus = core_scr_read(SCR_STATUS);
> +	switch (SATA_DWC_SCR0_SPD_GET(sstatus)) {
> +	case 0x0:
> +		dev_info(ap->dev, "**** No negotiated speed (nothing attached?"
> +			") ****\n");
> +		break;
> +	case 0x1:
> +		dev_info(ap->dev, "**** GEN I speed rate negotiated ****\n");
> +		break;
> +	case 0x2:
> +		dev_info(ap->dev, "**** GEN II speed rate negotiated ****\n");
> +		break;
> +	}

NAK, libata already prints this out


> +/*
> + * Function : sata_dwc_exec_command_by_tag
> + * arguments : ata_port *ap, ata_taskfile *tf, u8 tag, u32 cmd_issued
> + * Return value : None
> + * This function keeps track of individual command tag ids and calls
> + * ata_exec_command in libata
> + */
> +static void sata_dwc_exec_command_by_tag(struct ata_port *ap,
> +					 struct ata_taskfile *tf,
> +					 u8 tag, u32 cmd_issued)
> +{
> +
> +	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
> +
> +	dev_dbg(ap->dev, "%s cmd(0x%02x): %s tag=%d\n", __func__, tf->command,
> +		ata_cmd_2_txt(tf), tag);
> +
> +	spin_lock(&ap->host->lock);
> +	hsdevp->cmd_issued[tag] = cmd_issued;
> +	spin_unlock(&ap->host->lock);

either you need spin_lock_irqsave(), or you don't need the lock at all. 
  investigate which.



> +static void sata_dwc_qc_prep(struct ata_queued_cmd *qc)
> +{
> +	u32 sactive;
> +	u8 tag = qc->tag;
> +
> +	if ((qc->dma_dir == DMA_NONE) || (qc->tf.protocol == ATA_PROT_PIO))
> +		return;
> +
> +#ifdef DEBUG_NCQ
> +	if (qc->tag>  0)
> +		dev_info(qc->ap->dev, "%s: qc->tag=%d ap->active_tag=0x%08x\n",
> +			 __func__, tag, qc->ap->link.active_tag);
> +#endif
> +
> +	if (ata_is_ncq(qc->tf.protocol)) {
> +		sactive = core_scr_read(SCR_ACTIVE);
> +		sactive |= (0x00000001<<  tag);
> +		core_scr_write(SCR_ACTIVE, sactive);
> +		dev_dbg(qc->ap->dev, "%s: tag=%d ap->link.sactive = 0x%08x "
> +		"sactive=0x%08x\n", __func__, tag, qc->ap->link.sactive,
> +		 sactive);
> +	} else {
> +		tag = 0;
> +	}
> +
> +	sata_dwc_qc_prep_by_tag(qc, tag);

qc_prep is for setting up DMA internally, not on the hardware.  SActive 
should be twiddled in qc_issue.



> +static struct scsi_host_template sata_dwc_sht = {
> +	ATA_NCQ_SHT(DRV_NAME),
> +	/*
> +	 * test-only: Currently this driver doesn't handle NCQ
> +	 * correctly. We enable NCQ but set the queue depth to a
> +	 * max of 1. This will get fixed in in a future release.
> +	 */
> +	.sg_tablesize		= LIBATA_MAX_PRD,
> +	.can_queue		= ATA_DEF_QUEUE,	/* ATA_MAX_QUEUE */
> +	.dma_boundary		= ATA_DMA_BOUNDARY,
> +};

What is the problem with NCQ?  It is better to submit a non-NCQ driver 
then, rather than a driver with lots of buggy, unused NCQ code.



> +static const struct ata_port_info sata_dwc_port_info[] = {
> +	{
> +		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
> +				  ATA_FLAG_MMIO | ATA_FLAG_NCQ,
> +		.pio_mask	= 0x1f,	/* pio 0-4 */
> +		.udma_mask	= ATA_UDMA6,
> +		.port_ops	=&sata_dwc_ops,
> +	},

ditto... don't flag ATA_FLAG_NCQ if you note in the above comment that 
NCQ is broken


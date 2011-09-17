Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab1IQBzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 21:55:06 -0400
Received: from vm4.telegraphics.com.au ([98.124.60.149]:54537 "EHLO
	vps4.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab1IQBzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 21:55:05 -0400
Date: Sat, 17 Sep 2011 11:54:56 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Ramesh Raj <ramesh.v.raj@gmail.com>
cc: gregkh@suse.de, abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        hjk@linutronix.de, jkosina@suse.cz, blp@cs.stanford.edu,
        justinmattock@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: fixed checkpatch errors and curly brace
 issues
In-Reply-To: <1316212273-14940-1-git-send-email-ramesh.v.raj@gmail.com>
Message-ID: <alpine.LNX.2.00.1109171127240.2509@nippy.intranet>
References: <1316212273-14940-1-git-send-email-ramesh.v.raj@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I don't know why you CC'd this to me, I've nothing to do with this driver. 

But I'll review the patch anyway.


On Fri, 16 Sep 2011, Ramesh Raj wrote:

> daqboard2000.c: fixed checkpatch errors and curly brace issues.

Your commit log entry repeats the subject and adds a filename? You're 
kidding?

checkpatch "errors" are suggestions (at best).

> -        Word0:
> -          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> -          ! | | | ! | | | ! | | | ! | | | !
> -          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> +	Word0:
> +	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> +	  ! | | | ! | | | ! | | | ! | | | !
> +	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

Converting spaces to tabs in ASCII art documentation is daft.

>  
>  	/* If pacer clock is not set to some high value (> 10 us), we
>  	   risk multiple samples to be put into the result FIFO. */
> -	fpga->acqPacerClockDivLow = 1000000;	/* 1 second, should be long enough */
> +	fpga->acqPacerClockDivLow = 1000000;/* 1 second, should be long enough*/

Is this supposed to be an improvement?


>  	fpga->acqPacerClockDivHigh = 0;
>  
>  	gain = CR_RANGE(insn->chanspec);
> @@ -430,16 +429,16 @@ static int daqboard2000_ai_insn_read(struct comedi_device *dev,
>  		/* Enable reading from the scanlist FIFO */
>  		fpga->acqControl = DAQBOARD2000_SeqStartScanList;
>  		for (timeout = 0; timeout < 20; timeout++) {
> -			if (fpga->acqControl & DAQBOARD2000_AcqConfigPipeFull) {
> +			if (fpga->acqControl & DAQBOARD2000_AcqConfigPipeFull)
>  				break;
> -			}
> +

Pointless churn, IMHO.

>  			/* udelay(2); */
>  		}
>  		fpga->acqControl = DAQBOARD2000_AdcPacerEnable;
>  		for (timeout = 0; timeout < 20; timeout++) {
> -			if (fpga->acqControl & DAQBOARD2000_AcqLogicScanning) {
> +			if (fpga->acqControl & DAQBOARD2000_AcqLogicScanning)
>  				break;
> -			}
> +

Same.

>  			/* udelay(2); */
>  		}
>  		for (timeout = 0; timeout < 20; timeout++) {
> @@ -465,9 +464,8 @@ static int daqboard2000_ao_insn_read(struct comedi_device *dev,
>  	int i;
>  	int chan = CR_CHAN(insn->chanspec);
>  
> -	for (i = 0; i < insn->n; i++) {
> +	for (i = 0; i < insn->n; i++)
>  		data[i] = devpriv->ao_readback[chan];
> -	}

Same.

>  
>  	return i;
>  }
> -			if ((fpga->dacControl & ((chan + 1) * 0x0010)) == 0) {
> +			if ((fpga->dacControl & ((chan + 1) * 0x0010)) == 0)
>  				break;
> -			}
> +

Same.

>  			/* udelay(2); */
>  		}
>  		devpriv->ao_readback[chan] = data[i];
>  		/*



>  				    (cpld_array[i] << 8) + cpld_array[i + 1];
> -				if (!daqboard2000_writeCPLD(dev, data)) {
> +				if (!daqboard2000_writeCPLD(dev, data))
>  					break;
> -				}

Same.

>  			}
>  			if (i >= len) {
>  #ifdef DEBUG_EEPROM
> @@ -658,9 +659,9 @@ static void daqboard2000_activateReferenceDacs(struct comedi_device *dev)
>  	/*  Set the + reference dac value in the FPGA */
>  	fpga->refDacs = 0x80 | DAQBOARD2000_PosRefDacSelect;
>  	for (timeout = 0; timeout < 20; timeout++) {
> -		if ((fpga->dacControl & DAQBOARD2000_RefBusy) == 0) {
> +		if ((fpga->dacControl & DAQBOARD2000_RefBusy) == 0)
>  			break;
> -		}
> +

Same.

>  		udelay(2);
>  	}
>  /*  printk("DAQBOARD2000_PosRefDacSelect %d\n", timeout);*/
> @@ -668,9 +669,9 @@ static void daqboard2000_activateReferenceDacs(struct comedi_device *dev)
>  	/*  Set the - reference dac value in the FPGA */
>  	fpga->refDacs = 0x80 | DAQBOARD2000_NegRefDacSelect;
>  	for (timeout = 0; timeout < 20; timeout++) {
> -		if ((fpga->dacControl & DAQBOARD2000_RefBusy) == 0) {
> +		if ((fpga->dacControl & DAQBOARD2000_RefBusy) == 0)
>  			break;
> -		}
> +

Same.

>  		udelay(2);
>  	}
>  /*  printk("DAQBOARD2000_NegRefDacSelect %d\n", timeout);*/
> @@ -707,7 +708,11 @@ static void daqboard2000_initializeDac(struct comedi_device *dev)
>  /*
>  The test command, REMOVE!!:
>  
> -rmmod daqboard2000 ; rmmod comedi; make install ; modprobe daqboard2000; /usr/sbin/comedi_config /dev/comedi0 daqboard/2000 ; tail -40 /var/log/messages
> +rmmod daqboard2000;
> +* rmmod comedi; make install ;
> +* modprobe daqboard2000;
> +* /usr/sbin/comedi_config /dev/comedi0 daqboard/2000 ;
> +* tail -40 /var/log/messages
>  */

I'm sorry. How is this an improvement? Your version of this shell script 
has worse style than the original, and can't be cut and pasted.


>  
>  static int daqboard2000_8255_cb(int dir, int port, int data,
> @@ -722,7 +727,7 @@ static int daqboard2000_8255_cb(int dir, int port, int data,
>  	}
>  /*
>    printk("daqboard2000_8255_cb %x %d %d %2.2x -> %2.2x\n",
> -        arg, dir, port, data, result);
> +	arg, dir, port, data, result);

Wrong. The level of indentation here is not a tab. Also, there are coding 
style rules for comments.

>  */
>  	return result;
>  }
> @@ -743,9 +748,9 @@ static int daqboard2000_attach(struct comedi_device *dev,
>  	slot = it->options[1];
>  
>  	result = alloc_private(dev, sizeof(struct daqboard2000_private));
> -	if (result < 0) {
> +	if (result < 0)
>  		return -ENOMEM;
> -	}
> +

Churn.

>  	for (card = pci_get_device(0x1616, 0x0409, NULL);
>  	     card != NULL; card = pci_get_device(0x1616, 0x0409, card)) {
>  		if (bus || slot) {
> @@ -778,7 +783,7 @@ static int daqboard2000_attach(struct comedi_device *dev,
>  		}
>  		if (!dev->board_ptr) {
>  			printk
> -			    (" unknown subsystem id %08x (pretend it is an ids2)",
> +			   ("unknown subsystem id %08x (pretend it is an ids2)",

Wrong in various ways. If checkpatch didn't point out the whitespace 
issues in your code then read the style guides. You should split the 
string constant, keep the parens on the line with the function invocation, 
indent to the correct level. I'm not going to comment on the missing log 
level tag.

>  			     id);
>  			dev->board_ptr = boardtypes;
>  		}
> @@ -794,9 +799,8 @@ static int daqboard2000_attach(struct comedi_device *dev,
>  	    ioremap(pci_resource_start(card, 0), DAQBOARD2000_PLX_SIZE);
>  	devpriv->daq =
>  	    ioremap(pci_resource_start(card, 2), DAQBOARD2000_DAQ_SIZE);
> -	if (!devpriv->plx || !devpriv->daq) {
> +	if (!devpriv->plx || !devpriv->daq)
>  		return -ENOMEM;
> -	}

Churn.

>  
>  	result = alloc_subdevices(dev, 3);
>  	if (result < 0)
> @@ -869,18 +873,18 @@ static int daqboard2000_detach(struct comedi_device *dev)
>  	if (dev->subdevices)
>  		subdev_8255_cleanup(dev, dev->subdevices + 2);
>  
> -	if (dev->irq) {
> +	if (dev->irq)
>  		free_irq(dev->irq, dev);
> -	}
> +

Same.

>  	if (devpriv) {
>  		if (devpriv->daq)
>  			iounmap(devpriv->daq);
>  		if (devpriv->plx)
>  			iounmap(devpriv->plx);
>  		if (devpriv->pci_dev) {
> -			if (devpriv->got_regions) {
> +			if (devpriv->got_regions)
>  				comedi_pci_disable(devpriv->pci_dev);
> -			}
> +

Same.

>  			pci_dev_put(devpriv->pci_dev);
>  		}
>  	}
> 


Ramesh, please don't spam my inbox with this. I have nothing to do 
with this driver, and I don't like reviewing crap like this.

As for Greg Kroah-Hartman's inbox, you need to read this:
http://www.kroah.com/log/linux/maintainer-06.html

If you are going to submit patches relating to coding style, start by 
reading the kernel code style guide (and the other links in part 1 of that 
series of posts).

As for running check patch on existing code, please consider Al Viro's 
advice:
https://lkml.org/lkml/2010/3/8/282

Finn

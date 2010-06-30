Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab0F3F6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 01:58:33 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:14604 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897Ab0F3F6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 01:58:31 -0400
Message-ID: <000301cb1819$439924b0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Andy Isaacson" <adi@hexapodia.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Wang, Yong Y" <yong.y.wang@intel.com>,
       "Wang Qi" <qi.wang@intel.com>, "Intel OTC" <joel.clark@intel.com>,
       "Andrew" <andrew.chih.howe.khor@intel.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "LKML" <linux-kernel@vger.kernel.org>
References: <4C204B0D.2030201@dsn.okisemi.com> <20100629233111.GA6357@hexapodia.org>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Date: Wed, 30 Jun 2010 14:58:25 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy

Thank you for your comments.
Please refer to the following inline.
Thanks, Ohtake.

----- Original Message ----- 
From: "Andy Isaacson" <adi@hexapodia.org>
To: "Masayuki Ohtak" <masa-korg@dsn.okisemi.com>
Cc: "Arnd Bergmann" <arnd@arndb.de>; "Wang, Yong Y" <yong.y.wang@intel.com>; "Wang Qi" <qi.wang@intel.com>; "Intel OTC"
<joel.clark@intel.com>; "Andrew" <andrew.chih.howe.khor@intel.com>; "Alan Cox" <alan@lxorguk.ukuu.org.uk>; "LKML"
<linux-kernel@vger.kernel.org>
Sent: Wednesday, June 30, 2010 8:31 AM
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver


> On Tue, Jun 22, 2010 at 02:33:01PM +0900, Masayuki Ohtak wrote:
> > +config PCH_PHUB
> > + tristate "PCH PHUB"
> > + depends on PCI
> > + help
> > +   If you say yes to this option, support will be included for the
> > +   PCH Packet Hub Host controller.
> > +   This driver is for PCH Packet hub driver for Topcliff.
>
> "Topcliff" is probably some kind of internal codename; please use a name

Topcliff is not internal codename but external product name.

> that will be visible to customers of this product.  References to what
> kind of device (IEEE standards it implements, what systems it might be
> present on, etc) are also appropriate.

I will add what kinds of device.

>
> > +   This driver is integrated as built-in.
>
> This sentence doesn't parse to me.  What are you trying to say?
>

I will modify above.

> > +   This driver can access GbE MAC address.
> > +   This driver can access HW register.
>
> I think you mean something more like "This driver allows access to the
> GbE MAC address and HW registers of the PCH Packet Hub."
>
> If this is a driver for an Ethernet MAC, what is it doing in
> drivers/char/ ?

In Topcliff, MAC address is in PHUB HW not in GbE HW.

>
> > +   You can also be integrated as module.
>
> Please look at any other tristate and copy the standard wording.

I will modify above.

>
> > +/*!
> > + * @file pch_phub.c
> > + * @brief Provides all the implementation of the interfaces pertaining to
> > + * the Packet Hub module.
>
> We don't normally merge comment markup languages other than kernel-doc.
> Please read Documentation/kernel-doc-nano-HOWTO.txt and follow it.  (Or,
> provide a pointer to documentation and tools for this mysterious markup
> language.)

I will modify above.

>
> > +/*
> > + * History:
> > + * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
> > + *
> > + * created:
> > + * OKI SEMICONDUCTOR 04/14/2010
> > + * modified:
>
> No changelogs in comments, that's what git history is for.

I will modify above.

>
> > +/* includes */
>
> Useless comment.

I will delete above.

>
> > +/*--------------------------------------------
> > + macros
> > +--------------------------------------------*/
>
> More useless comments.

I will delete above.

>
> > +/* Status Register offset */
> > +#define PHUB_STATUS 0x00
> > +/* Control Register offset */
> > +#define PHUB_CONTROL 0x04
>
> I would format this as:
>
> #define PHUB_STATUS     0x00    /* Status Register offset */
> #define PHUB_CONTROL    0x04    /* Control Register offset */
>
> but it's up to you.

I will modify above.

>
> > +struct pch_phub_reg {
> > + unsigned int phub_id_reg;
>
> Since these are used to hold HW-defined data, you should use fixed-size
> types such as u32.  Also, you should consider whether they should be
> marked little endian / big endian.

I will modify above.

>
> > +/* ToDo: major number allocation via module parameter */
> > +static dev_t pch_phub_dev_no;
> > +static int pch_phub_major_no;
> > +static struct cdev pch_phub_dev;
>
> If this is to remain a chardev, use register_chrdev().  You shouldn't
> need a module parameter to configure your device numbers.

I will delete module paramter.

>
> > + void __iomem *reg_addr = pch_phub_reg.pch_phub_base_address +\
> > + reg_addr_offset;
>
> That \ is superfluous.  There are several of these in this file.

I will delete uncecessary '\'.

>
> The indentation on the second line is too large, and the fact that
> "a = b + c" spills onto a second line is a clue that your struct names
> are too long.

We don't modify structure name this time.

>
> > + iowrite32(((ioread32(reg_addr) & ~mask)) | data, reg_addr);
> > + return;
>
> The return is unneeded if this remains a void function.  (many more
> occurrences.)

I will delete 'return' of  void function.

>
> > +/** pch_phub_restore_reg_conf - restore register configuration
> > + */
>
> Don't use /** unless you're using kernel-doc.

I will modify above.

>
> > + unsigned int i;
> > + void __iomem *p = pch_phub_reg.pch_phub_base_address;
> > +
> > + dev_dbg(&pdev->dev, "pch_phub_restore_reg_conf ENTRY\n");
> > + /* to store contents of PHUB_ID register */
> > + iowrite32(pch_phub_reg.phub_id_reg, p + PCH_PHUB_PHUB_ID_REG);
>
> Don't include comments that just duplicate the code.  Also, rename your
> constants from PCH_PHUB_PHUB_ to, I dunno, PHUB_ or something.

Sorry, I can't understand your intention.
Please give us more information.

>
> > +/** pch_phub_read_serial_rom - Implements the functionality of reading Serial
> > + *  ROM.
> > + *  @offset_address: Contains the Serial ROM address offset value
> > + *  @data: Contains the Serial ROM value
> > + */
>
> This comment is almost correctly formatted, but there are extra words
> and some whitespace problems, and it doesn't document what actually
> happens.

I will modify above.

>
> +/**
> + * pch_phub_read_serial_rom - read PHUB Serial ROM.
> + *  @offset_address:   serial ROM offset to read.
> + *  @data:             pointer at which to store value that was read.
> + */
>
> is more correct.

I will modify above.

>
> Similar problems in several function comments below.
>
> > +static int pch_phub_read_serial_rom(unsigned int offset_address,
> > + unsigned char *data)
>
> The second line is indented too far.  We use 8-space tabstops, so the
> "u" of unsigned is all the way over under the "t" of offset_address.  It
> should either be two tabstops indented, or lined up with the previous
> argument.  (This applies to several functions below too.)

I will modify above.

>
> It should be "u8 *data".

I will modify above.

>
> > + void __iomem *mem_addr = pch_phub_reg.pch_phub_extrom_base_address +\
> > + offset_address;
> > +
> > + *data = ioread8(mem_addr);
> > +
> > + return 0;
>
> If this can't fail, why not have it just return the value rather than
> forcing the caller to provide a pointer?  (If you want to be futureproof
> and support errorhandling in the future, that's OK.)

I will modify to void.

>
> > +static int pch_phub_write_serial_rom(unsigned int offset_address,
> > + unsigned char data)
> > +{
> > + int retval = 0;
> > + void __iomem *mem_addr = pch_phub_reg.pch_phub_extrom_base_address +\
> > + (offset_address & 0xFFFFFFFC);
> > + int i = 0;
> > + unsigned int word_data = 0;
> > +
> > + iowrite32(PCH_PHUB_ROM_WRITE_ENABLE,
> > + pch_phub_reg.pch_phub_extrom_base_address +\
> > + PHUB_CONTROL);
> > +
> > + word_data = ioread32(mem_addr);
> > +
> > + switch (offset_address % 4) {
> > + case 0:
> > + word_data &= 0xFFFFFF00;
> > + iowrite32((word_data | (unsigned int)data),
> > + mem_addr);
> > + break;
>
> This function is much larger than need be.  Remove the 0xFFFFFFFC magic
> number -- something like
>
> #define PCH_WORD_ADDR_MASK (~((1 << 4) - 1))
>
> and implement the byte masking as something like
>
>     pos = (offset_address % 4) * 8;
>     mask = ~(0xFF << pos);
>     iowrite32((word_data & mask) | (u32)data << pos, mem_addr);
>
> (You can keep the switch if there's a significant performance benefit to
> doing so, but please provide measurements.)
I will modify.(This processing is not performance critical.)


>
> This is a read-modify-write cycle -- where is the locking if two users
> try to update the serial ROM simultaneously?  Any required locking
> should be documented in the kernel-doc comment.

I will modify using MUTEX like ioctl.

>
> > + while (0x00 !=
> > +        ioread8(pch_phub_reg.pch_phub_extrom_base_address +\
> > + PHUB_STATUS)) {
> > + msleep(1);
> > + if (PHUB_TIMEOUT == i) {
> > + retval = -EPERM;
> > + break;
> > + }
> > + i++;
>
> Rewrite this as a for loop (and remove the initialization from the
> declaration of i at the top of this function).  I am not sure if
> msleep() is safe here -- what context will this be called from?

This function is called from ioctl context(not interrput).
Thus, I think safe.

>
> > +/** pch_phub_read_serial_rom_val - Implements the functionality of reading
> > + *  Serial ROM value.
> > + *  @offset_address: Contains the Serial ROM address offset value
> > + *  @data: Contains the Serial ROM value
> > + */
> > +static int pch_phub_read_serial_rom_val(unsigned int offset_address,
> > + unsigned char *data)
> > +{
> > + int retval = 0;
> > + unsigned int mem_addr;
> > +
> > + mem_addr = (offset_address / 4 * 8) + 3 -
> > + (offset_address % 4) + PCH_PHUB_ROM_START_ADDR;
>
> Is that formula correct?   It is very suprising.
>
> If it is correct, the formula is bizarre enough to warrant a long
> comment explaining the theory of operation and/or pointing to hardware
> docs.

I will modify the above and add comments.


>
> > +static ssize_t pch_phub_read(struct file *file, char __user *buf, size_t size,
> > + loff_t *ppos)
> > +{
> > + unsigned int rom_signature = 0;
> > + unsigned char rom_length;
> > + int ret_value;
> > + unsigned int tmp;
> > + unsigned char data;
> > + unsigned int addr_offset = 0;
> > + unsigned int orom_size;
> > + loff_t pos = *ppos;
> > +
> > + if (pos < 0)
> > + return -EINVAL;
> > +
> > + /*Get Rom signature*/
> > + pch_phub_read_serial_rom(0x80, (unsigned char *)&rom_signature);
> > + pch_phub_read_serial_rom(0x81, (unsigned char *)&tmp);
>
> I seriously doubt that your device is special enough to warrant a custom
> /dev node with proprietary semantics.  If this is just part of an
> Ethernet driver, please implement it in drivers/net/; if this is a
> generic PROM accessor, there must be some semi-standardized EPROM access
> interface but I don't know what it is offhand.
Since SROM is not in GbE HW but Phub HW, Phub is not part of Ethernet driver.
Packet hub is not generic driver but special device.

>
> -andy
>






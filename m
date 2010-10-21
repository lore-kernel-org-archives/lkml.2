Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab0JUOTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:19:25 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:60666 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932308Ab0JUOTW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:19:22 -0400
From: Pratyush ANAND <pratyush.anand@st.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Viresh KUMAR <viresh.kumar@st.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>
Date: Thu, 21 Oct 2010 22:18:28 +0800
Subject: RE: [PATCH V2 45/69] ST SPEAr: PCIE gadget suppport
Thread-Topic: [PATCH V2 45/69] ST SPEAr: PCIE gadget suppport
Thread-Index: Actv118iVYWxDtCoQ+GJNu09LEyyyQBRl3sw
Message-ID: <0901B62280FF37468247D8348744254F449565AA97@EAPEX1MAIL1.st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
	<c91308e26397dbe49f384c7d3cf168593e1fe8b0.1285933332.git.viresh.kumar@st.com>
 <20101019144725.977297f5.akpm@linux-foundation.org>
In-Reply-To: <20101019144725.977297f5.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Wednesday, October 20, 2010 3:17 AM
> To: Viresh KUMAR
> Cc: linux-arm-kernel@lists.infradead.org; rtc-linux@googlegroups.com;
> a.zummo@towertech.it; dbrownell@users.sourceforge.net; linux-
> usb@vger.kernel.org; linux-input@vger.kernel.org;
> dmitry.torokhov@gmail.com; linux-mtd@lists.infradead.org;
> dwmw2@infradead.org; linux-kernel@vger.kernel.org; Pratyush ANAND; Shiraz
> HASHIM; Vipin KUMAR; Deepak SIKRI; Armando VISCONTI; Vipul Kumar SAMAR;
> Rajeev KUMAR; Bhupesh SHARMA
> Subject: Re: [PATCH V2 45/69] ST SPEAr: PCIE gadget suppport
>
> On Fri,  1 Oct 2010 17:26:05 +0530
> Viresh KUMAR <viresh.kumar@st.com> wrote:
>
> > From: Pratyush Anand <pratyush.anand@st.com>
> >
> > This is a configurable gadget. can be configured by sysfs interface. Any
> > IP available at PCIE bus can be programmed to be used by host
> > controller.It supoorts both INTX and MSI.
> > By default, gadget is configured for INTX and SYSRAM1 is mapped to BAR0
> > with size 0x1000
> >
> >
> > ...
> >
> > +static void enable_dbi_access(struct pcie_app_reg *app_reg)
>
> app_reg should have the __iomem tag.
>
Ok.
> > +{
> > +   /* Enable DBI access */
> > +   writel(readl(&app_reg->slv_armisc) | (1 << AXI_OP_DBI_ACCESS_ID),
> > +                   &app_reg->slv_armisc);
> > +   writel(readl(&app_reg->slv_awmisc) | (1 << AXI_OP_DBI_ACCESS_ID),
> > +                   &app_reg->slv_awmisc);
> > +
> > +}
> > +
> > +static void disable_dbi_access(struct pcie_app_reg *app_reg)
>
> ditto
>
Ok.
> > +{
> > +   /* disable DBI access */
> > +   writel(readl(&app_reg->slv_armisc) & ~(1 << AXI_OP_DBI_ACCESS_ID),
> > +                   &app_reg->slv_armisc);
> > +   writel(readl(&app_reg->slv_awmisc) & ~(1 << AXI_OP_DBI_ACCESS_ID),
> > +                   &app_reg->slv_awmisc);
> > +
> > +}
> > +
> > +static void spear_dbi_read_reg(struct spear_pcie_gadget_config *config,
> > +           int where, int size, u32 *val)
> > +{
> > +   struct pcie_app_reg *app_reg
> > +           = (struct pcie_app_reg *) config->va_app_base;
>
> ditto
>
ok
> > +   u32 va_address;
> > +
> > +   /* Enable DBI access */
> > +   enable_dbi_access(app_reg);
> > +
> > +   va_address = (u32)config->va_dbi_base + (where & ~0x3);
> > +
> > +   *val = readl(va_address);
> > +
> > +   if (size == 1)
> > +           *val = (*val >> (8 * (where & 3))) & 0xff;
> > +   else if (size == 2)
> > +           *val = (*val >> (8 * (where & 3))) & 0xffff;
> > +
> > +   /* Disable DBI access */
> > +   disable_dbi_access(app_reg);
> > +}
> > +
> > +static void spear_dbi_write_reg(struct spear_pcie_gadget_config *config,
> > +           int where, int size, u32 val)
> > +{
> > +   struct pcie_app_reg *app_reg
> > +           = (struct pcie_app_reg *) config->va_app_base;
>
> etc.
>
ok
> > +   u32 va_address;
> > +
> > +   /* Enable DBI access */
> > +   enable_dbi_access(app_reg);
> > +
> > +   va_address = (u32)config->va_dbi_base + (where & ~0x3);
> > +
> > +   if (size == 4)
> > +           writel(val, va_address);
> > +   else if (size == 2)
> > +           writew(val, va_address + (where & 2));
> > +   else if (size == 1)
> > +           writeb(val, va_address + (where & 3));
> > +
> > +   /* Disable DBI access */
> > +   disable_dbi_access(app_reg);
> > +}
> > +
> >
> > ...
> >
> > +/**
>
> This token is specifically used to introduce a kerneldoc comment, but
> this wasn't a kerneldoc comment.
>
> > + * Tell if a device supports a given PCI capability.
> > + * Returns the address of the requested capability structure within the
> > + * device's PCI configuration space or 0 in case the device does not
> > + * support it. Possible values for @cap:
> > + *
> > + * %PCI_CAP_ID_PM  Power Management
> > + * %PCI_CAP_ID_AGP Accelerated Graphics Port
> > + * %PCI_CAP_ID_VPD Vital Product Data
> > + * %PCI_CAP_ID_SLOTID      Slot Identification
> > + * %PCI_CAP_ID_MSI Message Signalled Interrupts
> > + * %PCI_CAP_ID_CHSWP       CompactPCI HotSwap
> > + * %PCI_CAP_ID_PCIX        PCI-X
> > + * %PCI_CAP_ID_EXP PCI Express
> > + */
> >
> > ...
> >
> > +
> > +static ssize_t pcie_gadget_show_link(struct device *dev,
> > +           struct device_attribute *attr, char *buf)
> > +{
> > +   struct spear_pcie_gadget_config *config = dev_get_drvdata(dev);
> > +   struct pcie_app_reg *app_reg =
> > +           (struct pcie_app_reg *)config->va_app_base;
>
> Check all the __iomems;
>
Ok.
> > +   if (readl(&app_reg->app_status_1) & ((u32)1 << XMLH_LINK_UP_ID))
> > +           return sprintf(buf, "UP");
> > +   else
> > +           return sprintf(buf, "DOWN");
> > +}
> > +
> > +static ssize_t pcie_gadget_store_link(struct device *dev,
> > +           struct device_attribute *attr, const char *buf, size_t count)
> > +{
> > +   struct spear_pcie_gadget_config *config = dev_get_drvdata(dev);
> > +   struct pcie_app_reg *app_reg =
> > +           (struct pcie_app_reg *)config->va_app_base;
> > +   char link[10];
> > +
> > +   if (sscanf(buf, "%s", link) != 1)
>
> What happens if strlen(buf) >= 10?
>
Will return -EINVAL for strlen(buf) >= 0.
> > +           return -EINVAL;
> > +
> > +   if (!strcmp(link, "UP"))
> > +           writel(readl(&app_reg->app_ctrl_0) | (1 <<
> APP_LTSSM_ENABLE_ID),
> > +                   &app_reg->app_ctrl_0);
> > +   else
> > +           writel(readl(&app_reg->app_ctrl_0)
> > +                           & ~(1 << APP_LTSSM_ENABLE_ID),
> > +                           &app_reg->app_ctrl_0);
> > +   return count;
> > +}
> > +
> >
> > ...
> >
> > +static ssize_t pcie_gadget_store_int_type(struct device *dev,
> > +           struct device_attribute *attr, const char *buf, size_t count)
> > +{
> > +   struct spear_pcie_gadget_config *config = dev_get_drvdata(dev);
> > +   char int_type[10];
> > +   u32 cap, vector, vec, flags;
> > +
> > +   if (sscanf(buf, "%s", int_type) != 1)
>
> ditto
Will return -EINVAL for strlen(buf) >= 0.
>
> > +           return -EINVAL;
> > +
> > +   if (!strcmp(int_type, "INTA"))
> > +           spear_dbi_write_reg(config, PCI_INTERRUPT_LINE, 1, 1);
> > +
> > +   else if (!strcmp(int_type, "MSI")) {
> > +           vector = config->requested_msi;
> > +           vec = 0;
> > +           while (vector > 1) {
> > +                   vector /= 2;
> > +                   vec++;
> > +           }
> > +           spear_dbi_write_reg(config, PCI_INTERRUPT_LINE, 1, 0);
> > +           cap = pci_find_own_capability(config, PCI_CAP_ID_MSI);
> > +           spear_dbi_read_reg(config, cap + PCI_MSI_FLAGS, 1, &flags);
> > +           flags &= ~PCI_MSI_FLAGS_QMASK;
> > +           flags |= vec << 1;
> > +           spear_dbi_write_reg(config, cap + PCI_MSI_FLAGS, 1, flags);
> > +   }
>
> No checking for unrecognised input?
>
Will return -EINVAL for other inputs.

> > +   strcpy(config->int_type, int_type);
> > +
> > +   return count;
> > +}
> > +
> > +static DEVICE_ATTR(int_type, S_IWUSR | S_IRUGO,
> pcie_gadget_show_int_type,
> > +           pcie_gadget_store_int_type);
> > +
> > +static ssize_t pcie_gadget_show_no_of_msi(struct device *dev,
> > +           struct device_attribute *attr, char *buf)
> > +{
> > +   struct spear_pcie_gadget_config *config = dev_get_drvdata(dev);
> > +   struct pcie_app_reg *app_reg =
> > +           (struct pcie_app_reg *)config->va_app_base;
>
> __iomem
>
> > +   u32 cap, vector, vec, flags;
> > +
> > +   if ((readl(&app_reg->msg_status) & (1 << CFG_MSI_EN_ID))
> > +                   != (1 << CFG_MSI_EN_ID))
> > +           vector = 0;
> > +   else {
> > +           cap = pci_find_own_capability(config, PCI_CAP_ID_MSI);
> > +           spear_dbi_read_reg(config, cap + PCI_MSI_FLAGS, 1, &flags);
> > +           flags &= ~PCI_MSI_FLAGS_QSIZE;
> > +           vec = flags >> 4;
> > +           vector = 1;
> > +           while (vec--)
> > +                   vector *= 2;
> > +   }
> > +   config->configured_msi = vector;
> > +
> > +   return sprintf(buf, "%u", vector);
> > +}
> > +
> >
> > ...
> >
> > +static ssize_t pcie_gadget_store_inta(struct device *dev,
> > +           struct device_attribute *attr, const char *buf, size_t count)
> > +{
> > +   struct spear_pcie_gadget_config *config = dev_get_drvdata(dev);
> > +   struct pcie_app_reg *app_reg =
> > +           (struct pcie_app_reg *)config->va_app_base;
> > +   int en;
> > +
> > +   if (sscanf(buf, "%d", &en) != 1)
>
> strict_strtoul() would be better.  It will reject input of the form
> "42foo".
>
Ok..will use strict_strtoul.
> > +           return -EINVAL;
> > +
> > +   if (en)
> > +           writel(readl(&app_reg->app_ctrl_0) | (1 << SYS_INT_ID),
> > +                           &app_reg->app_ctrl_0);
> > +   else
> > +           writel(readl(&app_reg->app_ctrl_0) & ~(1 << SYS_INT_ID),
> > +                           &app_reg->app_ctrl_0);
> > +
> > +   return count;
> > +}
> > +
> > +static DEVICE_ATTR(inta, S_IWUSR, NULL, pcie_gadget_store_inta);
> > +
> > +static ssize_t pcie_gadget_store_send_msi(struct device *dev,
> > +           struct device_attribute *attr, const char *buf, size_t count)
> > +{
> > +   struct spear_pcie_gadget_config *config = dev_get_drvdata(dev);
> > +   struct pcie_app_reg *app_reg =
> > +           (struct pcie_app_reg *)config->va_app_base;
> > +   int vector;
> > +   u32 ven_msi;
> > +
> > +   if (sscanf(buf, "%d", &vector) != 1)
>
> strict_strtoul().
>
Ok..will use strict_strtoul().
> > +           return -EINVAL;
> > +
> > +   if (!config->configured_msi)
> > +           return -EINVAL;
> > +
> > +   if (vector >= config->configured_msi)
> > +           return -EINVAL;
> > +
> > +   ven_msi = readl(&app_reg->ven_msi_1);
> > +   ven_msi &= ~VEN_MSI_FUN_NUM_MASK;
> > +   ven_msi |= 0 << VEN_MSI_FUN_NUM_ID;
> > +   ven_msi &= ~VEN_MSI_TC_MASK;
> > +   ven_msi |= 0 << VEN_MSI_TC_ID;
> > +   ven_msi &= ~VEN_MSI_VECTOR_MASK;
> > +   ven_msi |= vector << VEN_MSI_VECTOR_ID;
> > +
> > +   /*generating interrupt for msi vector*/
> > +   ven_msi |= VEN_MSI_REQ_EN;
> > +   writel(ven_msi, &app_reg->ven_msi_1);
> > +   /*need to wait till this bit is cleared, it is not cleared
> > +    * autometically[Bug RTL] TBD*/
> > +   udelay(1);
> > +   ven_msi &= ~VEN_MSI_REQ_EN;
> > +   writel(ven_msi, &app_reg->ven_msi_1);
> > +
> > +   return count;
> > +}
> > +
> >
> > ...
> >
> > +static ssize_t pcie_gadget_store_vendor_id(struct device *dev,
> > +           struct device_attribute *attr, const char *buf, size_t count)
> > +{
> > +   struct spear_pcie_gadget_config *config = dev_get_drvdata(dev);
> > +   u32 id;
> > +
> > +   if (sscanf(buf, "%x", &id) != 1)
>
> strict_strtoul can be used here as well?
>
Ok..will use strict_strtoul().
> > +           return -EINVAL;
> > +
> > +   spear_dbi_write_reg(config, PCI_VENDOR_ID, 2, id);
> > +
> > +   return count;
> > +}
> > +
> >
> > ...
> >
> > +static ssize_t pcie_gadget_store_device_id(struct device *dev,
> > +           struct device_attribute *attr, const char *buf, size_t count)
> > +{
> > +   struct spear_pcie_gadget_config *config = dev_get_drvdata(dev);
> > +   u32 id;
> > +
> > +   if (sscanf(buf, "%x", &id) != 1)
>
> etc.
>
Ok..will use strict_strtoul().
> > +           return -EINVAL;
> > +
> > +   spear_dbi_write_reg(config, PCI_DEVICE_ID, 2, id);
> > +
> > +   return count;
> > +}
> > +
> >
> > ...
> >
> > +static ssize_t pcie_gadget_store_bar0_size(struct device *dev,
> > +           struct device_attribute *attr, const char *buf, size_t count)
> > +{
> > +   struct spear_pcie_gadget_config *config = dev_get_drvdata(dev);
> > +   u32 size, pos, pos1;
> > +   u32 no_of_bit = 0;
> > +
> > +   if (sscanf(buf, "%x", &size) != 1)
>
> etc.
>
Ok..will use strict_strtoul().
> > +           return -EINVAL;
> > +   /* as per PCIE specs, min bar size supported is 128 bytes. But
> > +    * our controller supports min as 256*/
> > +   if (size <= 0x100)
> > +           size = 0x100;
> > +   /* max bar size is 1MB*/
> > +   else if (size >= 0x100000)
> > +           size = 0x100000;
> > +   else {
> > +           pos = 0;
> > +           pos1 = 0;
> > +           while (pos < 21) {
> > +                   pos = find_next_bit((unsigned long *)&size, 21, pos);
> > +                   if (pos != 21)
> > +                           pos1 = pos + 1;
> > +                   pos++;
> > +                   no_of_bit++;
> > +           }
> > +           if (no_of_bit == 2)
> > +                   pos1--;
> > +
> > +           size = 1 << pos1;
> > +   }
> > +   config->bar0_size = size;
> > +   spear_dbi_write_reg(config, PCIE_BAR0_MASK_REG, 4, size - 1);
> > +
> > +   return count;
> > +}
> > +
> >
> > ...
> >
> > +static ssize_t pcie_gadget_show_bar0_address(struct device *dev,
> > +           struct device_attribute *attr, char *buf)
> > +{
> > +   struct spear_pcie_gadget_config *config = dev_get_drvdata(dev);
> > +   struct pcie_app_reg *app_reg =
> > +           (struct pcie_app_reg *)config->va_app_base;
>
> etc
>
Ok..will use __iomem
> > +   u32 address = readl(&app_reg->pim0_mem_addr_start);
> > +
> > +   return sprintf(buf, "%x", address);
> > +}
> > +
> >
> > ...
> >
> > +static ssize_t pcie_gadget_show_help(struct device *dev,
> > +           struct device_attribute *attr, char *buf)
> > +{
> > +   char text[] = "\t\tlink read->ltssm status\n \
> > +           link write->arg1 = UP to enable ltsmm DOWN to disable\n \
> > +           int_type read->type of supported interrupt\n \
> > +           int_type write->arg1 = interrupt type to be configured and\n \
> > +           can be INTA, MSI or NO_INT\n \
> > +           (select MSI only when you have programmed no_of_msi)\n \
> > +           no_of_msi read->zero if MSI is not enabled by host\n \
> > +           and positive value is the number of MSI vector granted\n \
> > +           no_of_msi write->arg1 = number of MSI vector needed\n \
> > +           inta write->arg1 = 1 to assert INTA and 0 to de-assert\n \
> > +           send_msi write->arg1 = MSI vector to be send\n \
> > +           vendor_id read->programmed vendor id (hex)\n\
> > +           vendor_id write->arg1 = vendor id(hex) to be programmed\n \
> > +           device_id read->programmed device id(hex)\n \
> > +           device_id write->arg1 = device id(hex) to be programmed\n \
> > +           bar0_size read->size of bar0 in hex\n \
> > +           bar0_size write->arg1= size of bar0 in hex\n \
> > +           (default bar0 size is 1000 (hex) bytes)\n \
> > +           bar0_address read->address of bar0 mapped area in hex\n \
> > +           bar0_address write->arg1 = address of bar0 mapped area in
> hex\n\
> > +           (default mapping of bar0 is SYSRAM1(E0800000)\n \
> > +           (always program bar size before bar address)\n \
> > +           (kernel might modify bar size and address to align)\n \
> > +           (read back bar size and address after writing to check)\n \
> > +           bar0_rw_offset read->offset of bar0 for which bar0_data \n \
> > +           will return value\n \
> > +           bar0_rw_offset write->arg1 = offset of bar0 for which\n \
> > +           bar0_data will write value\n \
> > +           bar0_data read->data at bar0_rw_offset\n \
> > +           bar0_data write->arg1 = data to be written at\n \
> > +           bar0_rw_offset\n";
> > +
> > +   int size = (sizeof(text) < PAGE_SIZE) ? sizeof(text) : PAGE_SIZE;
> > +
> > +   return snprintf(buf, size, "%s", text);
> > +}
>
> What the heck is this??
>

This was just to provide help for different sysfs nodes. What could be the other
Way to do it? Should it be better to remove help node from here provide all the help
In a separate document?

> > +static DEVICE_ATTR(help, S_IRUGO, pcie_gadget_show_help, NULL);
> > +
> > +static struct attribute *pcie_gadget_attributes[] = {
> > +   &dev_attr_link.attr,
> > +   &dev_attr_int_type.attr,
> > +   &dev_attr_no_of_msi.attr,
> > +   &dev_attr_inta.attr,
> > +   &dev_attr_send_msi.attr,
> > +   &dev_attr_vendor_id.attr,
> > +   &dev_attr_device_id.attr,
> > +   &dev_attr_bar0_size.attr,
> > +   &dev_attr_bar0_address.attr,
> > +   &dev_attr_bar0_rw_offset.attr,
> > +   &dev_attr_bar0_data.attr,
> > +   &dev_attr_help.attr,
> > +   NULL
> > +};
> > +
> >
> > ...
> >
> > +static int __devinit spear_pcie_gadget_probe(struct platform_device
> *pdev)
> > +{
> > +   struct resource *res0, *res1;
> > +   struct spear_pcie_gadget_config *config;
> > +   unsigned int status = 0;
> > +   int irq;
> > +   struct clk *clk;
> > +
> > +   /* get resource for application registers*/
> > +
> > +   res0 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +   if (!res0) {
> > +           dev_err(&pdev->dev, "no resource defined\n");
> > +           return -EBUSY;
> > +   }
> > +   if (!request_mem_region(res0->start, resource_size(res0),
> > +                           pdev->name)) {
> > +           dev_err(&pdev->dev, "pcie gadget region already claimed\n");
> > +           return -EBUSY;
> > +   }
> > +   /* get resource for dbi registers*/
> > +
> > +   res1 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> > +   if (!res1) {
> > +           dev_err(&pdev->dev, "no resource defined\n");
> > +           goto err_rel_res0;
> > +   }
> > +   if (!request_mem_region(res1->start, resource_size(res1),
> > +                           pdev->name)) {
> > +           dev_err(&pdev->dev, "pcie gadget region already claimed\n");
> > +           goto err_rel_res0;
> > +   }
> > +
> > +   config = kzalloc(sizeof(*config), GFP_KERNEL);
> > +   if (!config) {
> > +           dev_err(&pdev->dev, "out of memory\n");
> > +           status = -ENOMEM;
> > +           goto err_rel_res;
> > +   }
> > +
> > +   config->va_app_base = ioremap(res0->start, resource_size(res0));
> > +   if (!config->va_app_base) {
> > +           dev_err(&pdev->dev, "ioremap fail\n");
> > +           status = -ENOMEM;
> > +           goto err_kzalloc;
> > +   }
> > +
> > +   config->base = (void *)res1->start;
>
> Is that __iomem?
>
Will use __iomem here too.

> > +   config->va_dbi_base = ioremap(res1->start, resource_size(res1));
> > +   if (!config->va_dbi_base) {
> > +           dev_err(&pdev->dev, "ioremap fail\n");
> > +           status = -ENOMEM;
> > +           goto err_iounmap_app;
> > +   }
> > +
> > +   dev_set_drvdata(&pdev->dev, config);
> > +
> > +   irq = platform_get_irq(pdev, 0);
> > +   if (irq < 0) {
> > +           dev_err(&pdev->dev, "no update irq?\n");
> > +           status = irq;
> > +           goto err_iounmap;
> > +   }
> > +
> > +   status = request_irq(irq, spear_pcie_gadget_irq, 0, pdev->name,
> NULL);
> > +   if (status) {
> > +           dev_err(&pdev->dev, "pcie gadget interrupt IRQ%d already \
> > +                           claimed\n", irq);
> > +           goto err_get_irq;
> > +   }
> > +   /* Register sysfs hooks */
> > +   status = sysfs_create_group(&pdev->dev.kobj,
> &pcie_gadget_attr_group);
> > +   if (status)
> > +           goto err_irq;
> > +
> > +   /* init basic pcie application registers*/
> > +   /* do not enable clock if it is PCIE0.Ideally , all controller should
> > +    * have been independent from others with respect to clock. But PCIE1
> > +    * and 2 depends on PCIE0.So PCIE0 clk is provided during board
> init.*/
> > +   if (pdev->id == 1) {
> > +           /* Ideally CFG Clock should have been also enabled here. But
> > +            * it is done currently during board init routne*/
> > +           clk = clk_get_sys("pcie1", NULL);
> > +           if (!clk) {
> > +                   pr_err("%s:couldn't get clk for pcie1\n", __func__);
> > +                   goto err_irq;
> > +           }
> > +           if (clk_enable(clk)) {
> > +                   pr_err("%s:couldn't enable clk for pcie1\n", __func__);
> > +                   goto err_irq;
> > +           }
> > +   } else if (pdev->id == 2) {
> > +           /* Ideally CFG Clock should have been also enabled here. But
> > +            * it is done currently during board init routne*/
> > +           clk = clk_get_sys("pcie2", NULL);
> > +           if (!clk) {
> > +                   pr_err("%s:couldn't get clk for pcie2\n", __func__);
> > +                   goto err_irq;
> > +           }
> > +           if (clk_enable(clk)) {
> > +                   pr_err("%s:couldn't enable clk for pcie2\n", __func__);
> > +                   goto err_irq;
> > +           }
> > +   }
> > +   spear13xx_pcie_device_init(config);
> > +
> > +   return 0;
> > +err_irq:
> > +   free_irq(irq, NULL);
> > +err_get_irq:
> > +   dev_set_drvdata(&pdev->dev, NULL);
> > +err_iounmap:
> > +   iounmap(config->va_dbi_base);
> > +err_iounmap_app:
> > +   iounmap(config->va_app_base);
> > +err_kzalloc:
> > +   kfree(config);
> > +err_rel_res:
> > +   release_mem_region(res1->start, resource_size(res1));
> > +err_rel_res0:
> > +   release_mem_region(res0->start, resource_size(res0));
> > +   return status;
> > +}
> > +
> >
> > ...
> >
>
> The driver implements a large, complex userspace interface and afaict
> that interface wasn't documented anywhere.
>
> But the interface is the most important part of the driver!  It should
> be documented in a permanent fashion so that reviewers can understand
> and review your proposed interface.  They will want to do that before
> even looking at the code.
Ok..Will write Documentation/misc-devices/spear_pcie_gadget.txt.

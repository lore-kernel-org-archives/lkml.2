Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab2IOWWi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 18:22:38 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:62639 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751343Ab2IOWWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 18:22:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120915075301.GA31044@avionic-0098.mockup.avionic-design.de>
References: <1347655456-2542-1-git-send-email-thierry.reding@avionic-design.de>
 <1347655456-2542-2-git-send-email-thierry.reding@avionic-design.de>
 <CAMuHMdWuR_tdMw9iVkaQ3D9p1HVU_L05ap=MzBuo1jLD6YdHHw@mail.gmail.com> <20120915075301.GA31044@avionic-0098.mockup.avionic-design.de>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 15 Sep 2012 16:22:11 -0600
Message-ID: <CAErSpo7q9fvtjatfKqtb8SP3UOJdEXpbvFC_qMBTc6mAoRTQuA@mail.gmail.com>
Subject: Re: [PATCH 2/2] PCI: Provide a default pcibios_update_irq()
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Chris Zankel <chris@zankel.net>, Greg Ungerer <gerg@uclinux.org>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-m68k@vger.kernel.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2012 at 1:53 AM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> On Sat, Sep 15, 2012 at 09:32:10AM +0200, Geert Uytterhoeven wrote:
>> On Fri, Sep 14, 2012 at 10:44 PM, Thierry Reding
>> <thierry.reding@avionic-design.de> wrote:
>> > --- a/drivers/pci/setup-irq.c
>> > +++ b/drivers/pci/setup-irq.c
>> > @@ -17,6 +17,14 @@
>> >  #include <linux/ioport.h>
>> >  #include <linux/cache.h>
>> >
>> > +void __devinit __weak pcibios_update_irq(struct pci_dev *dev, int irq)
>> > +{
>> > +#ifdef CONFIG_PCI_DEBUG
>> > +       printk(KERN_DEBUG "PCI: Assigning IRQ %02d to %s\n", irq,
>> > +              pci_name(dev));
>>
>> pr_debug()?
>> Or even better, dev_dbg()?
>
> The problem with pr_debug() and dev_dbg() is that they will be compiled
> out if DEBUG is not defined. Perhaps we should pass -DDEBUG if PCI_DEBUG
> is configured and make this dev_dbg()?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698Ab1CDDZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 22:25:58 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:58003 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758213Ab1CDDZ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 22:25:57 -0500
From: "TK, Pratheesh Gangadhar" <pratheesh@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hjk@hansjkoch.de" <hjk@hansjkoch.de>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 4 Mar 2011 08:55:27 +0530
Subject: RE: [PATCH v9 1/1] PRUSS UIO driver support
Thread-Topic: [PATCH v9 1/1] PRUSS UIO driver support
Thread-Index: AcvZzw3faMBe88LKTIeGQCqBkaQ3jQASLVUw
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593024C008B02@dbde02.ent.ti.com>
References: <1299175677-17859-1-git-send-email-pratheesh@ti.com>
 <1299175677-17859-2-git-send-email-pratheesh@ti.com>
 <201103031915.55825.arnd@arndb.de>
In-Reply-To: <201103031915.55825.arnd@arndb.de>
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

Hi,
> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Thursday, March 03, 2011 11:46 PM
> On Thursday 03 March 2011 19:07:57 Pratheesh Gangadhar wrote:
> > +struct uio_pruss_dev {
> > +       struct uio_info *info;
> > +       struct clk *pruss_clk;
> > +       dma_addr_t sram_paddr;
> > +       dma_addr_t ddr_paddr;
> > +       void __iomem *prussio_vaddr;
> > +       void *sram_vaddr;
> > +       void *ddr_vaddr;
> > +       unsigned int hostirq_start;
> > +       unsigned int pintc_base;
> > +};
> > +
> > +struct pruss_priv {
> > +       struct uio_pruss_dev *pupdev;
> > +};
> 
> I cannot see the point of struct pruss_priv, I think it would be better to
> just merge the two data structures into one. Everything else looks
> good to me now.

pruss_priv is needed to get access to uio_pruss_dev from uio_info *info in
UIO interrupt handler (pruss_handler) and shall be per interrupt entry.

+static irqreturn_t pruss_handler(int irq, struct uio_info *info) {
+	struct pruss_priv *priv = info->priv;
+	struct uio_pruss_dev *gdev = priv->pupdev;

Note that info is a pointer to array supporting 8 interrupts. This allows to
redirect to driver structure via info->priv quickly.

Thanks,
Pratheesh   

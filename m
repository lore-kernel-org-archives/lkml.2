Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab0KKO3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 09:29:48 -0500
Received: from mxout1.idt.com ([157.165.5.25]:52171 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab0KKO3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 09:29:47 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/4][v2] fsl_rio: move machine_check handler into machine_check_e500 & machine_check_e500mc
Date: Thu, 11 Nov 2010 06:29:01 -0800
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55201538C58@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <0B482EBF-AF82-4C61-A35E-D9619246D259@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/4][v2] fsl_rio: move machine_check handler into machine_check_e500 & machine_check_e500mc
Thread-Index: AcuBnHIS4jyPuMkHTW6glt4psaBfggAD4stQ
References: <1288777018-24259-1-git-send-email-b21989@freescale.com> <0B482EBF-AF82-4C61-A35E-D9619246D259@freescale.com>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Kumar Gala" <kumar.gala@freescale.com>,
        "Shaohui Xie" <b21989@freescale.com>
Cc: <akpm@linux-foundation.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala <kumar.gala@freescale.com> wrote:
> > @@ -527,8 +535,12 @@ int machine_check_e500(struct pt_regs *regs)
> 
> To deal w/Alex's comment do:
> 
> machine_check_e500(...) {
> 
> 	int ret = 0;
> 
> 
> > 		printk("Bus - Write Address Error\n");
> > 	if (reason & MCSR_BUS_IBERR)
> > 		printk("Bus - Instruction Data Error\n");
> > -	if (reason & MCSR_BUS_RBERR)
> > +	if (reason & MCSR_BUS_RBERR) {
> > 		printk("Bus - Read Data Bus Error\n");
> > +#ifdef CONFIG_RAPIDIO
> > +		fsl_rio_mcheck_exception(regs);
> > +#endif
> 
> make this like 'ret = fsl_rio...
> 

Please, place it in the beginning of the machine_check_e500[mc](...) as
well to avoid any 'printk' if RIO exception was handled properly.

Alex. 

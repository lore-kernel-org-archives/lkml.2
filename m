Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab1I0OjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 10:39:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56903 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157Ab1I0OjB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 10:39:01 -0400
thread-index: Acx9Iy7w+p8Ln62FTlqxho5PBOZk9Q==
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4657
Subject: Re: [PATCH 2/5 v11] arm: omap: usb: ehci and ohci hwmod structures for omap3
From: Tero Kristo <t-kristo@ti.com>
Reply-To: <t-kristo@ti.com>
To: "Balbi, Felipe" <balbi@ti.com>
CC: "Munegowda, Keshava" <keshava_mgowda@ti.com>,
        Paul Walmsley <paul@pwsan.com>, "Cousson, Benoit" <b-cousson@ti.com>,
        "Basak, Partha" <p-basak2@ti.com>, <parthab@india.ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "Gadiyar, Anand" <gadiyar@ti.com>,
        <sameo@linux.intel.com>, <tony@atomide.com>,
        "Hilman, Kevin" <khilman@ti.com>, <johnstul@us.ibm.com>,
        "Sripathy, Vishwanath" <vishwanath.bs@ti.com>
In-Reply-To: <20110927132453.GF19603@legolas.emea.dhcp.ti.com>
References: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com> <1316691479-1849-2-git-send-email-keshava_mgowda@ti.com> <1316691479-1849-3-git-send-email-keshava_mgowda@ti.com> <alpine.DEB.2.00.1109221115320.10719@utopia.booyaka.com> <CAP05o4+Zc2z6sBOX_rQeoDQ9PneypcLRCyBbaaB2m+ZjeXZnaw@mail.gmail.com> <alpine.DEB.2.00.1109240020510.22872@utopia.booyaka.com> <CAP05o4Lwk2uUz5ou84GQsrsBdjW-FEYP-55pBzH+a74hP4g1Dw@mail.gmail.com> <cbad72cea703d117067f7c628f7db806@mail.gmail.com> <1317127327.3820.31.camel@sokoban> <CAP05o4J75jGLTH8prOGD79Mte4DOg9ukgwe3V-KHFnB1Q-fi4w@mail.gmail.com> <20110927132453.GF19603@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Texas Instruments
Date: Tue, 27 Sep 2011 17:38:51 +0300
Message-ID: <1317134331.3820.44.camel@sokoban>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 15:24 +0200, Balbi, Felipe wrote:
> Hi,
> 
> On Tue, Sep 27, 2011 at 06:48:35PM +0530, Munegowda, Keshava wrote:
> > > So, you would need a mechanism to do something like this:
> > >
> > > pad a or b wakeup detected -> irq0
> > > pad c or d wakeup detected -> irq1?
> > 
> > yes, if get something like this , its perfect.
> 
> can't you have different IRQs for each pad ? I mean, allocate one
> irq_desc for each pad and let drivers request a pad/pin as an IRQ
> source. Then, when you detect a pad wakeup, you can:

Direct pad to irq mapping was turned down on some previous version of
the prcm chain handler set, but yes, it is a potential approach. However
the irq_desc allocation mechanism should be dynamic... there are some
200 programmable pads anyway.

>
> unsigned	pad_irq = pad_number - pad->irq_base;
> 
> handle_nested_thread(pad_irq);
> 
> this will make use of threaded IRQ handlers even. Could it be something
> like that ?
> 



Texas Instruments Oy, Tekniikantie 12, 02150 Espoo. Y-tunnus: 0115040-6. Kotipaikka: Helsinki
 


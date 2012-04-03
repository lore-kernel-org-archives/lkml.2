Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab2DCU77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 16:59:59 -0400
Received: from mail.vyatta.com ([76.74.103.46]:52722 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684Ab2DCU75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 16:59:57 -0400
Date: Tue, 3 Apr 2012 13:59:54 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: LinoSanfilippo@gmx.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] sky2: fix missing register reset on error path in
 sky2_test_msi()
Message-ID: <20120403135954.2131ab08@s6510.linuxnetplumber.net>
In-Reply-To: <20120403.163008.1865240185992444794.davem@davemloft.net>
References: <20120330173616.GC2703@Neptun>
	<20120403115547.799fcc1f@s6510.linuxnetplumber.net>
	<20120403.163008.1865240185992444794.davem@davemloft.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Apr 2012 16:30:08 -0400 (EDT)
David Miller <davem@davemloft.net> wrote:

> From: Stephen Hemminger <shemminger@vyatta.com>
> Date: Tue, 3 Apr 2012 11:55:47 -0700
> 
> > On Fri, 30 Mar 2012 19:36:16 +0200
> > Lino Sanfilippo <LinoSanfilippo@gmx.de> wrote:
> > 
> >> In sky2_test_msi() the temporarily set SW IRQ in B0 register is not reset in case
> >> that request_irq() fails.
> >> With this patch we only set the interrupt mask if request_irq() was successful.
> >> 
> >> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> > 
> > Ok, but this is a non-serious error case. If request_irq() fails here,
> > the driver is going to fail to load and on the failure path of
> > sky2_probe will reset the chip on the way out.
> 
> So, ACK for net-next?  Toss it?  What?

Put it in net-next, no need for net or stable.

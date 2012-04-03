Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab2DCSzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 14:55:53 -0400
Received: from mail.vyatta.com ([76.74.103.46]:47055 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755245Ab2DCSzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 14:55:51 -0400
Date: Tue, 3 Apr 2012 11:55:47 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] sky2: fix missing register reset on error path in
 sky2_test_msi()
Message-ID: <20120403115547.799fcc1f@s6510.linuxnetplumber.net>
In-Reply-To: <20120330173616.GC2703@Neptun>
References: <20120330173616.GC2703@Neptun>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012 19:36:16 +0200
Lino Sanfilippo <LinoSanfilippo@gmx.de> wrote:

> In sky2_test_msi() the temporarily set SW IRQ in B0 register is not reset in case
> that request_irq() fails.
> With this patch we only set the interrupt mask if request_irq() was successful.
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>

Ok, but this is a non-serious error case. If request_irq() fails here,
the driver is going to fail to load and on the failure path of
sky2_probe will reset the chip on the way out.



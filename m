Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab2DCUaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 16:30:21 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38035 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab2DCUaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 16:30:20 -0400
Date: Tue, 03 Apr 2012 16:30:08 -0400 (EDT)
Message-Id: <20120403.163008.1865240185992444794.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: LinoSanfilippo@gmx.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] sky2: fix missing register reset on error path in
 sky2_test_msi()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120403115547.799fcc1f@s6510.linuxnetplumber.net>
References: <20120330173616.GC2703@Neptun>
	<20120403115547.799fcc1f@s6510.linuxnetplumber.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 03 Apr 2012 13:30:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Tue, 3 Apr 2012 11:55:47 -0700

> On Fri, 30 Mar 2012 19:36:16 +0200
> Lino Sanfilippo <LinoSanfilippo@gmx.de> wrote:
> 
>> In sky2_test_msi() the temporarily set SW IRQ in B0 register is not reset in case
>> that request_irq() fails.
>> With this patch we only set the interrupt mask if request_irq() was successful.
>> 
>> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> 
> Ok, but this is a non-serious error case. If request_irq() fails here,
> the driver is going to fail to load and on the failure path of
> sky2_probe will reset the chip on the way out.

So, ACK for net-next?  Toss it?  What?

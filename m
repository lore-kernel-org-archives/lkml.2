Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab1IHX2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:28:14 -0400
Received: from mx1.netlogicmicro.com ([12.203.210.36]:3682 "EHLO
	orion5.netlogicmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753867Ab1IHX2N convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:28:13 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Sep 2011 19:28:13 EDT
X-TM-IMSS-Message-ID: <b159c8480003e3e3@netlogicmicro.com>
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: How to chip->startup() with IRQs disabled
Date: Thu, 8 Sep 2011 16:13:54 -0700
Message-ID: <74B0AE1BA53C37449DE49BB274F9A2DBC4D07C@orion8.netlogicmicro.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: How to chip->startup() with IRQs disabled
Thread-Index: AcxkWiI2j/+0JnnlT7KeKap/xgfTRQKDZciC
References: <74B0AE1BA53C37449DE49BB274F9A2DBC4D052@orion8.netlogicmicro.com>
From: "Om Narasimhan" <onarasimhan@netlogicmicro.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,
I am working on a MIPS chip with multiple cores. I have defined 
static struct irq_chip new_plat_chip = {
...
	.startup = n_irq_startup,
	.mask = n_irq_shutdown,
...
};

In n_irq_startup(), I have to make sure that all cores have set RVEC bit and corresponding EIMR bit. So, I try using on_each_cpu() (because EIMR can be set only by running code on that particular cpu) to run a function to set EIMR.

n_irq_startup() is called as chip->startup() from __setup_irq() (from request_threaded_irq, in turn from request_irq() ) with a spin lock held (desc->lock, in kernel/irq/manage.c).  This causes a stack dump from on_each_cpu(). Since it is wrong to call on_each_cpu with interrupts disabled, I want to change this piece of code.

I am wondering how other SMP mips system implement this. Any comments or pointers will be helpful.

I am not in the mailing list, please CC me in replies.

I tried sent this to linux-mips, but no replies. So, trying with a larger audience. (http://www.spinics.net/lists/mips/msg41902.html)
Om.

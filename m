Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab1HKMTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 08:19:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50238 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab1HKMTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 08:19:38 -0400
MIME-Version: 1.0
Date: Thu, 11 Aug 2011 21:19:37 +0900
Message-ID: <CAK7N6vo+WN2TXQEKWp0F5usRYQtTaYjF31UZeyQGRpx9-dH07g@mail.gmail.com>
Subject: changing to threaded_handler in twl6030-irq.c
From: anish singh <anish198519851985@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rajendra Nayak <rnayak@ti.com>, Balaji T K <balajitk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/*
 * handle_twl6030_int() is the desc->handle method for the twl6030 interrupt.
 * This is a chained interrupt, so there is no desc->action method for it.
 * Now we need to query the interrupt controller in the twl6030 to determine
 * which module is generating the interrupt request.  However, we can't do i2c
 * transactions in interrupt context, so we must defer that work to a kernel
 * thread.  All we do here is acknowledge and mask the interrupt and wakeup
 * the kernel thread.
 */
static irqreturn_t handle_twl6030_pih(int irq, void *devid)
{
        disable_irq_nosync(irq);
        complete(devid);
        return IRQ_HANDLED;
}

Does this still hold good when we have threaded_handler?Is it possible
to move to threaded handler if no, can anybody explain the reason?
Just to know more about threaded handler short comings if there is any.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687Ab1GBAGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 20:06:53 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35822 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab1GBAGw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 20:06:52 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTimGAuyMP43eDUet7Ts0XU9WQRYbyQ@mail.gmail.com>
References: <BANLkTimGAuyMP43eDUet7Ts0XU9WQRYbyQ@mail.gmail.com>
Date: Sat, 2 Jul 2011 08:06:51 +0800
Message-ID: <BANLkTinDh+JXmy=vdy3XgNzurt2PuHrKfw@mail.gmail.com>
Subject: tick_setup_device in tick-common.c
From: chao xie <xiechao.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi
I am very strange about this function.
In this function, it has
/*
        * When the device is not per cpu, pin the interrupt to the
        * current cpu:
        */
       if (!cpumask_equal(newdev->cpumask, cpumask))
               irq_set_affinity(newdev->irq, cpumask);

When the clock event device has cpu_mask set to be cpumask_of(1), it
means that the device is bound to cpu1. So above code has covered it,
but why we have "!cpumask_equal(newdev->cpumask, cpumask)"?
if the "newdev->cpumask" equals "cpumask", cpumask_equal will return
1, and at this situation we will set the irq affinity because the
device is bound to the dedicated cpu.

Is there a bug, or i understand wrong about cpumask of clock_event_device?
Thanks.

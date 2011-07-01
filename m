Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab1GAJty (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:49:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52887 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766Ab1GAJtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:49:53 -0400
MIME-Version: 1.0
Date: Fri, 1 Jul 2011 17:49:52 +0800
Message-ID: <BANLkTimGAuyMP43eDUet7Ts0XU9WQRYbyQ@mail.gmail.com>
Subject: tick_setup_device in tick-common.c
From: chao xie <xiechao.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
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

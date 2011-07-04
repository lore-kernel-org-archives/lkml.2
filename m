Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab1GDC3X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 22:29:23 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58110 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab1GDC3T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 22:29:19 -0400
MIME-Version: 1.0
In-Reply-To: <CADApbeg7pR5gvVx352rgZP2MiH5VG9zPq1L5tX3LUX4YEgQtLw@mail.gmail.com>
References: <CADApbeg7pR5gvVx352rgZP2MiH5VG9zPq1L5tX3LUX4YEgQtLw@mail.gmail.com>
Date: Mon, 4 Jul 2011 10:29:19 +0800
Message-ID: <CADApbeicWd8g7XFoy9thuD-3Jfz3ROtsHJsVTxKMTs9MR-s2=A@mail.gmail.com>
Subject: tick_setup_device in tick_common.c
From: Chao Xie <xiechao.mail@gmail.com>
To: tglx@linutronix.de, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
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

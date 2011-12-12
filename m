Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab1LLRso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:48:44 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59037 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab1LLRsl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:48:41 -0500
MIME-Version: 1.0
In-Reply-To: <1309427470-605-4-git-send-email-balbi@ti.com>
References: <1309427470-605-1-git-send-email-balbi@ti.com>
	<1309427470-605-4-git-send-email-balbi@ti.com>
Date: Mon, 12 Dec 2011 19:48:41 +0200
Message-ID: <CAMP44s03Cj+V_L8GKyWLMuCGQ5Fg9nZ+Uxm5DpwVVF3YY0RSqA@mail.gmail.com>
Subject: Re: [PATCH 3/7] mfd: twl4030-irq: drop the kthread
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 12:51 PM, Felipe Balbi <balbi@ti.com> wrote:
> ... and use threaded IRQ infrastructure. Later
> patches will come dropping both workqueues and
> setting the nested thread flag.

...

>  static irqreturn_t handle_twl4030_pih(int irq, void *devid)
>  {
> -       /* Acknowledge, clear *AND* mask the interrupt... */
> -       disable_irq_nosync(irq);
> -       complete(devid);

...

> -       status = request_irq(irq_num, handle_twl4030_pih, IRQF_DISABLED,
> -                               "TWL4030-PIH", &irq_event);
> +       status = request_threaded_irq(irq_num, NULL, handle_twl4030_pih,
> +                       IRQF_DISABLED, "TWL4030-PIH", NULL);

FTR, in this reorganization this code was dropped
disable_irq_nosync(irq), which means the irq's would never be cleared.
IRQF_ONESHOT should have been on the flags.

But Neil Brown already found the issue and fixed it :)
http://article.gmane.org/gmane.linux.kernel/1220705

-- 
Felipe Contreras

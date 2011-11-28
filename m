Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab1K1XsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:48:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58211 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab1K1XsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:48:03 -0500
Date: Mon, 28 Nov 2011 15:48:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com
Subject: Re: [PATCH 2/2] misc: add driver support for MAX8997 MUIC
Message-Id: <20111128154801.05f7c199.akpm@linux-foundation.org>
In-Reply-To: <1322125938-6944-3-git-send-email-dg77.kim@samsung.com>
References: <1322125938-6944-2-git-send-email-dg77.kim@samsung.com>
	<1322125938-6944-3-git-send-email-dg77.kim@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Nov 2011 18:12:18 +0900
Donggeun Kim <dg77.kim@samsung.com> wrote:

> The MUIC function in MAX8997 device can be used as
> a USB port detector and switch.
> This patch supports the MUIC feature of MAX8997.
> 
> Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Samuel, can you please merge this if/when it's ready?

>
> ...
>
> +static irqreturn_t max8997_muic_irq_handler(int irq, void *data)
> +{
> +	struct max8997_muic_info *info = data;
> +
> +	dev_dbg(info->dev, "irq:%d\n", irq);
> +	info->irq = irq;
> +
> +	schedule_work(&info->irq_work);
> +
> +	return IRQ_HANDLED;
> +}

The code does schedule_work() but I see no flush_work().  Is it
possible for the work to still be pending after device shutdown, or
even after rmmod?


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab1EPJmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 05:42:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:37737 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab1EPJmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 05:42:16 -0400
Date: Mon, 16 May 2011 11:24:29 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Daniel Drake <dsd@laptop.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, dilinger@queued.net
Subject: Re: [PATCH 11/11] x86, olpc: Add XO-1.5 SCI driver
Message-ID: <20110516092429.GC26487@linutronix.de>
References: <1304166750-31125-1-git-send-email-dsd@laptop.org>
 <1304166750-31125-12-git-send-email-dsd@laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1304166750-31125-12-git-send-email-dsd@laptop.org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Drake | 2011-04-30 13:32:30 [+0100]:

>+static DECLARE_WORK(sci_work, process_sci_queue_work);
>+
>+static u32 xo15_sci_gpe_handler(acpi_handle gpe_device, u32 gpe, void *context)
>+{
>+	schedule_work(&sci_work);
>+	return ACPI_INTERRUPT_HANDLED | ACPI_REENABLE_GPE;
>+}

I know this is too much to ask but acpi_install_gpe_handler() looks like
a custom irq demultiplexor which lacks the support for threaded irqs.

Sebastian

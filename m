Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2IYM34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:29:56 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55502 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab2IYM3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:29:53 -0400
MIME-Version: 1.0
In-Reply-To: <20120919115933.GJ3772@arwen.pp.htv.fi>
References: <1347972050-3509-1-git-send-email-sourav.poddar@ti.com>
	<20120918140213.GA27463@arwen.pp.htv.fi>
	<CANOLnONC1oDN3yu=ipao2A6MfuSkZfROVPewWLLEM5fNTKipxQ@mail.gmail.com>
	<20120919115933.GJ3772@arwen.pp.htv.fi>
Date: Tue, 25 Sep 2012 17:59:52 +0530
Message-ID: <CAJe_Zhc5jCBcfvTcs=Xi_QXLU+t_Erck-3pxV5co1xAsjj8kkA@mail.gmail.com>
Subject: Re: [RFT/PATCH] serial: omap: prevent resume if device is not suspended.
From: Jassi Brar <jaswinder.singh@linaro.org>
To: balbi@ti.com
Cc: Grazvydas Ignotas <notasas@gmail.com>,
        Sourav Poddar <sourav.poddar@ti.com>, gregkh@linuxfoundation.org,
        alan@linux.intel.com, tony@atomide.com, khilman@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, paul@pwsan.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 September 2012 17:29, Felipe Balbi <balbi@ti.com> wrote:

> this is what I mean, actually. If we remove pm_runtime_get_sync() in
> exchange for pm_runtime_set_active() before pm_runtime_enable(), it
> works on PandaBoard, but breaks BeagleBoard.
>
Perhaps it suggests that OMAP4 (PandaBoard) serial port is already
activated but OMAP3 (BeagleBoard) isn't. So we need to reflect that
either by doing pm_runtime_set_active() only on OMAP4 or by bringing
up the OMAP3 too before the pm_runtime_set_active() call.
BTW I understand get_sync(), set_active() and enable() are for
different purposes, they can't be traded for one another.

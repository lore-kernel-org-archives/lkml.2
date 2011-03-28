Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab1C1OsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 10:48:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52981 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab1C1OsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 10:48:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Par-Gunnar HJALMDAHL" <par-gunnar.p.hjalmdahl@stericsson.com>
Subject: Re: [PATCH v2 2/2] mach-ux500: Add CG2900 devices
Date: Mon, 28 Mar 2011 16:47:48 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "Par-Gunnar Hjalmdahl" <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
References: <1301302992-10671-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com> <20110328141237.GB19350@suse.de> <AFCDDB4A3EA003429EEF1E7B211FDBBA3377B51A1F@EXDCVYMBSTM005.EQ1STM.local>
In-Reply-To: <AFCDDB4A3EA003429EEF1E7B211FDBBA3377B51A1F@EXDCVYMBSTM005.EQ1STM.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103281647.48802.arnd@arndb.de>
X-Provags-ID: V02:K0:qc/rFwY5Ha858E78HNr6AGUUiCZ0tlsUucns2A2u9Vx
 RTkfRr6dAiGkwFbRPibKgO3tXJtcZzpysciA90vldcrjshNPPv
 AdmVAgIo6ZoaHFKU88dbTQnNM5W8VJlFOgBGE+kOtGQS1LLhm+
 Wop1Ptv0fcKLNJbl68vi6zQSOF/K1rI/2SuhNZ1jHPOm77C/x8
 th6dFmap1KxOoY8osMNkg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 March 2011, Par-Gunnar HJALMDAHL wrote:
> But how should I then do this? As I understood it I was told that I should
> call an init function, but I was not allowed to add any staging folder
> inclusion in the board config makefile. And now I can't do any extern
> declaration either. I don't really see how I could do it then.
> 
> The only thing I can think of is to use platform device and driver for
> the cg2900_init. But I wouldn't call that to call an init-function, but that
> might be OK for this purpose?

There are at least two ways to do it:

* As Linus Walleij explained, use an initcall instead of calling a
  function from the board init code. "initcall" here refers to the
  interfaces from include/linux/init.h, e.g. module_init(). This
  will result in the function getting called at module load time,
  or at some point during bootup when it's built into the kernel.
  This initcall needs to check if you are running on the right board,
  using machine_is_xxx().

* As I explained, register a simple platform_device with the resources
  for the entire cg2900 device from the board code in a way that
  is independent of the actual driver. The driver code can then
  register all the subdevices from the cg2900_probe function.
  The code in the architecture would consist out of a single
  call to platform_device_register_simple() plus the resources.

Either way is fine with me.

	Arnd

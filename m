Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab0D1VY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 17:24:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:46839 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755175Ab0D1VYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 17:24:25 -0400
Message-ID: <4BD8A78B.6070906@suse.cz>
Date: Wed, 28 Apr 2010 23:24:27 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: USB_SERIAL_KEYSPAN_* dependency on FIRMWARE_IN_KERNEL
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

I recently disabled CONFIG_FIRMWARE_IN_KERNEL in the default openSUSE
kernels (as no built-in driver needs firmware and the initrd takes care
of the modules), but this disabled all the CONFIG_USB_SERIAL_KEYSPAN_*
options, because there is

config USB_SERIAL_KEYSPAN_MPR
        bool "USB Keyspan MPR Firmware"
        depends on USB_SERIAL_KEYSPAN && FIRMWARE_IN_KERNEL
etc

in drivers/usb/serial/Kconfig, added in 2971c57 by you. Is there a
reason for this dependency or shouldn't this rather depend on FW_LOADER?
On a related note, firmware/Makefile has

ifdef CONFIG_FIRMWARE_IN_KERNEL
fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_MPR) += keyspan/mpr.fw
...
else
fw-shipped- += keyspan/mpr.fw ...
endif

which just duplicates the dependency (if CONFIG_FIRMWARE_IN_KERNEL is
not set, the CONFIG_USB_SERIAL_KEYSPAN_* options won't be set either).
Note that I do not have the hardware, so maybe I'm missing something
obvious...

thanks,
Michal

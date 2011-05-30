Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1E3HDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 03:03:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40309 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab1E3HDp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 03:03:45 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>,
        linux-usb@vger.kernel.org
Subject: Re: [2.6.39] crash in acm_ctrl_msg+0x16/0x59
Date: Mon, 30 May 2011 07:54:14 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oliver Neukum <oliver@neukum.name>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <4DE25252.7050503@gmail.com>
In-Reply-To: <4DE25252.7050503@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105300754.14490.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 29. Mai 2011, 16:04:02 schrieb Riccardo Magliocchetti:

> mtp-probe: bus: 6, device: 4 was not an MTP device
> [20462.901834] cdc_acm 6-1:1.0: ttyACM0: USB ACM device
> [20462.904417] usbcore: registered new interface driver cdc_acm
> [20462.904420] cdc_acm: v0.26:USB Abstract Control Model driver for USB 
> modems and ISDN adapters
> [20463.624142] usb 6-1: USB disconnect, device number 4
> [20463.641859] CPU 0
> 
> This is the stracktrace:
> 
> acm_ctrl_msg+0x16/0x59
> mutex_lock+0x13/0x2a
> acm_port_down+0x4c/0xcb
> acm_tty_close+0x75/0x93
> tty_release+0x1b5/0x47c
> ? compat_do_readv_write+0x199/0x1ae
> fput+0xf8/0x1ad
> filp_close+0x69/0x75
> sys_close+0x8a/0xea
> sysenter_dispatch+0x07/0x32

So we are trying to talk to a device that is already gone.
Is there anything unusual about your device? Could you
post "lsusb -v"?

	Regards
		Oliver


-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 

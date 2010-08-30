Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab0H3Onn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 10:43:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49241 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab0H3Onn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 10:43:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hank Janssen <hjanssen@microsoft.com>
Subject: hv block drivers
Date: Mon, 30 Aug 2010 16:43:42 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008301643.42253.arnd@arndb.de>
X-Provags-ID: V02:K0:z7Y5pNBVnK7FzBgaYwu2AawvNwCPQCuaSQZKVVKPpC/
 cFwUqlWpX2Wma2dxOy5iQ1y0P694Hf2oMRzLcFAFiqMUF7gASZ
 d4sK14HdQTo6exjZHnyKz7AON7/ewT70eBogydkqb0vH5QSvca
 pv2BABVhM7IBw73Psblqzz7lkhrJhiG/TXqBHWumxOIgr7o2vH
 W0akU2B0gx8QS0jakurUg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hank,

I wanted to follow up on the block device driver discussion we had at
LinuxCon, based on some other input I got.

What most people recommended was to make both the hv scsi and the
hv ata code scsi device drivers, *not* make them standalone block
drivers as I originally recommended.

The main reason for this is consistent naming of the devices. We
have a lot of user code that can deal with /dev/sd* devices, but
introducing the /dev/vd* devices for virtio caused a lot of pain
that you probably shouldn't have to go through.

I'm not sure whether the two should be one or two drivers. My
feeling here is that it might be nice to have a single scsi
host driver for both that has two modes of driving the device,
one sending the SCSI commands down the virtual bus, the other
one interpreting the SCSI commands in the same way that libata
does.

	Arnd

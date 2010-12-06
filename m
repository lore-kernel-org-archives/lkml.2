Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab0LFOlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 09:41:14 -0500
Received: from 93.100.122.208.pool.sknt.ru ([93.100.122.208]:41914 "EHLO
	localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750709Ab0LFOlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 09:41:12 -0500
Date: Mon, 6 Dec 2010 17:45:19 +0300
From: Valentine Barshak <vbarshak@mvista.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] USB: HID: Fix race between disconnect and hiddev_ioctl
Message-ID: <20101206144519.GA8438@mvista.com>
Reply-To: Valentine Barshak <vbarshak@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a USB HID device is disconneceted, the hiddev_ioctl could try
to access invalid hiddev->hid pointer.

The following two patches attempt to fix race condition between
disconnect and hiddev_ioctl and make hiddev_ioctl always return
-ENODEV on a disconnected device.

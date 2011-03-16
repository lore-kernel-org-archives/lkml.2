Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab1CPB4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 21:56:06 -0400
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:53023 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1CPB4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 21:56:03 -0400
Message-ID: <4D8018A9.6000800@ahsoftware.de>
Date: Wed, 16 Mar 2011 02:55:53 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: balbi@ti.com
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: musb as module broken in 2.6.38
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

in commit dc09886bfa781e2b442301116c18199519e36f0f the name of the 
platform-driver was splitted and musb-omap2430 is used for several 
boards (arch/arm/mach-omap2/usb-musb.c).

But musb_hdrc still uses musb-hdrc as name when platform_driver_probe() 
is called. The result is that loading the driver (when build as a 
module) doesn't work anymore (it doesn't find the platform-device).

Do I miss something or was something forgotten when the glue-layers for 
musb got introduced?

(The driver still works when linked into the kernel, but is 
disfunctional when build as a module.)

Regards,

Alexander Holler

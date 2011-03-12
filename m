Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab1CLWj4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 17:39:56 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49015 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab1CLWjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 17:39:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:from:subject:to:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=J3wvH/cG7thQ+0T/n3WsGvvfxV2khjPQagMMn8mSP2qqM7lm0mVtJEmvzkscfZImOF
         L6mvEg3hhoTsDWqSbPhkpLEJ0WAFb8TmA3TvJ098Ki7nDVcaETk8KtQUda2xLYfyEth5
         U+eHj0UYWSu1a+1hD3ml8eZQ0aK6r3aUvOk2Y=
From: Andy Green <andy@warmcat.com>
Subject: [RFC PATCH 0/3] USB: async platform_data support for usb and usbnet
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: patches@linaro.org
Date: Sat, 12 Mar 2011 22:39:49 +0000
Message-ID: <20110312223643.27344.72406.stgit@otae.warmcat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series allows usb probe to benefit from the proposed
async platform_data API described here

http://marc.info/?l=linux-kernel&m=129996915023642&w=2

It causes the usb host core system to bind to any registered async
platform data that matches the device path of the device automatically,
and in addition adds platform data to usbnet and causes it to take
notice of the plaform data settings during init, allowing override of
usb%d vs eth%d naming convention and actual MAC address from the
board definition file.

---

Andy Green (3):
      USBNET: Use usbnet platform data if it is present
      USBNET: Introduce usbnet platform data
      USB HOST CORE:probed devices collect any platform_data waiting for them


 drivers/net/usb/usbnet.c   |   23 +++++++++++++++++------
 drivers/usb/core/usb.c     |    3 +++
 include/linux/usb/usbnet.h |    8 ++++++++
 3 files changed, 28 insertions(+), 6 deletions(-)

-- 
Signature

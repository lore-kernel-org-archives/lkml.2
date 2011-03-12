Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab1CLWcK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 17:32:10 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54903 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab1CLWcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 17:32:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:from:subject:to:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=KDnrAob279DUHzPleDHBEI0S8nE48EfD4FmiyTptPZQgxRqm6PhLRZ+7BRwrXMRmOD
         j89HTD3gKA/r5QKWPrreb5/SF9XcUfHGw+p2Ye9YWB0hfCrWSZ/opgQKU+ConGKEETPd
         BpSfwQOeUUrTNjIm+SdCMjFN/Skbo3mucUBbA=
From: Andy Green <andy@warmcat.com>
Subject: [RFC PATCH 0/4] PLATFORM: Support for async platform_data
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: patches@linaro.org
Date: Sat, 12 Mar 2011 22:32:03 +0000
Message-ID: <20110312222633.27020.19543.stgit@otae.warmcat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series adds two apis which allow board definition
files to register bindings between device paths (like usb1/1-1/1-1.1)
and platform data.  It's for use in the case that there are hardwired
chips on a board that need to be configured from the board definition
file, but the creation of the device is asynchronous to the boot
action.  Beagle XM and Panda are both real-world examples where there
are hardwired chips on the PCB with fixed interconnect using USB
protocol that can benefit from platform_data for the usual reasons.

This patcheset is the platform part of a three part set which when
taken as a whole, allows the board definition file to configure
USB-wired onboard network interface assets.

---

Andy Green (4):
      PLATFORM: Add some documentation to platform docs about async platform_data
      PLATFORM: Introduce async platform_data attach api
      PLATFORM: Introduce registration function for async platform data maps
      PLATFORM: introduce structure to bind async platform data to a dev path name


 Documentation/driver-model/platform.txt |   25 +++++++++
 drivers/base/platform.c                 |   91 +++++++++++++++++++++++++++++++
 include/linux/platform_device.h         |   22 +++++++
 3 files changed, 138 insertions(+), 0 deletions(-)

-- 
Signature

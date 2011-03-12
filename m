Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab1CLWcq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 17:32:46 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32952 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab1CLWci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 17:32:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=ZyUSWQQ6Ld7TRMNJr/Zgy0YQRVURqOUYSBH7+iTM1H/T1BY/GObKpk3Nqf6DnFQd25
         ECBEmnTU581FReQaTRzVq7WYQLgecdXf9HHLYz7iWPNMEWk/6CdAeb6zL3zT5O+fHOny
         K/2wwGcpjtsKRtYd/Xg8Ir9UaHsPO7oJLQumM=
From: Andy Green <andy@warmcat.com>
Subject: [RFC PATCH 4/4] PLATFORM: Add some documentation to platform docs
 about async platform_data
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: patches@linaro.org, Andy Green <andy.green@linaro.org>
Date: Sat, 12 Mar 2011 22:32:35 +0000
Message-ID: <20110312223234.27020.3911.stgit@otae.warmcat.com>
In-Reply-To: <20110312222633.27020.19543.stgit@otae.warmcat.com>
References: <20110312222633.27020.19543.stgit@otae.warmcat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Green <andy.green@linaro.org>
---

 Documentation/driver-model/platform.txt |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/Documentation/driver-model/platform.txt b/Documentation/driver-model/platform.txt
index 41f4163..0c34156 100644
--- a/Documentation/driver-model/platform.txt
+++ b/Documentation/driver-model/platform.txt
@@ -96,6 +96,31 @@ System setup also associates those clocks with the device, so that that
 calls to clk_get(&pdev->dev, clock_name) return them as needed.
 
 
+Providing platform_data to onboard devices on asynchronously probed buses
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Some boards have fixed onboard assets that would normally be dealt with
+by using plaform_data set in the usual way in the board definition file,
+but cannot directly do so because they are on a bus that is probed
+asynchronously.  For emebedded devices, often the broard definition
+file is adding platform devices for the buses involved, like USB host
+and gadget, in a fixed order using platform_add_devices(), so the device
+path of these fixed soldered-on-the-board assets is deterministic.
+
+For buses and devices that are named deterministically at boot-time,
+you can define platform_data that binds to these devices when they are
+probed by declaring a map of device paths to platform_data in your
+board definition file before adding the bus platform devices, using
+
+	void platform_register_async_platform_data(
+		struct platform_async_platform_data *map, int count);
+
+Buses that participate in this scheme will then check this mapping list
+for corresponding platform_data as they are probed and apply it
+automatically.  An example device path mapping is
+
+	"usb1/1-1/1-1.1"
+
+
 Legacy Drivers:  Device Probing
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Some drivers are not fully converted to the driver model, because they take


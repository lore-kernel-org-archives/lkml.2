Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab2JCNty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 09:49:54 -0400
Received: from bishop.asidev.net ([95.141.38.214]:56055 "EHLO
	bishop.asidev.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab2JCNtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 09:49:52 -0400
X-Greylist: delayed 453 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2012 09:49:52 EDT
Message-ID: <506C40B7.7050102@evidence.eu.com>
Date: Wed, 03 Oct 2012 15:42:15 +0200
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Lightning/1.0b2 Thunderbird/3.1.20
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH] umc-bus.c: fix usage of device_trylock
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

I've probably found a wrong usage of device_trylock inside the driver
umc-bus.c: device_trylock has the same semantics of mutex_trylock, so it
returns 1 if the lock has been acquired successfully.

Please, find below a patch.

Best regards,

	Claudio


Subject: umc-bus.c: fix usage of device_trylock
From: Claudio Scordino <claudio@evidence.eu.com>

device_trylock has the same semantics of mutex_trylock, so it returns 1
if the lock has been acquired successfully.

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
---
  drivers/uwb/umc-bus.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/uwb/umc-bus.c b/drivers/uwb/umc-bus.c
index 82a84d5..5c5b3fc 100644
--- a/drivers/uwb/umc-bus.c
+++ b/drivers/uwb/umc-bus.c
@@ -63,7 +63,7 @@ int umc_controller_reset(struct umc_dev *umc)
  	struct device *parent = umc->dev.parent;
  	int ret = 0;
  
-	if (device_trylock(parent))
+	if (!device_trylock(parent))
  		return -EAGAIN;
  	ret = device_for_each_child(parent, parent, umc_bus_pre_reset_helper);
  	if (ret >= 0)
-- 
1.7.1


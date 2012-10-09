Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab2JIKV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 06:21:28 -0400
Received: from bishop.asidev.net ([95.141.38.214]:43736 "EHLO
	bishop.asidev.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab2JIKVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 06:21:25 -0400
Message-ID: <5073FA9D.8080501@evidence.eu.com>
Date: Tue, 09 Oct 2012 12:21:17 +0200
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Lightning/1.0b2 Thunderbird/3.1.20
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH RESEND] umc-bus.c: fix usage of device_trylock
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

I've not received any feedback about this patch, so I'm resending just
to check if someone is going to take care of it.

The patch fixes the usage of device_trylock inside the driver umc-bus.c:
device_trylock has the same semantics of mutex_trylock, so it returns 1
if the lock has been acquired successfully.

Best regards,

	Claudio


Subject: umc-bus.c: fix usage of device_trylock
From: Claudio Scordino <claudio@evidence.eu.com>

Fix usage of device_trylock. It has the same semantics of mutex_trylock, so it
returns 1 if the lock has been acquired successfully.

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
Signed-off-by: Bruno Morelli <bruno@evidence.eu.com>
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



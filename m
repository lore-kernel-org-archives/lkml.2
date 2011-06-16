Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab1FPJDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:03:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60981 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab1FPJDB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:03:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=IMhGmg1FQZce5t4JtbMhwse3NCnoVXN9YZpUDcq7GPaMlZaVN9Ovbsu3gfkKk67Srz
         PJ1uBGRhtO/OkimORzsWZhxZlNguOrW1k/NFG1C0pAQVlaEd/xGeYQjImsrcjJEckqBj
         4QaE0h6s71xpzKmQ7a50pH6JtPY6DKbxGP0Ec=
Date: Thu, 16 Jun 2011 11:02:56 +0200
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: 3.0-rc2: mei breaks suspend
Message-ID: <20110616110256.0890dd37@susi.home.s3e.de>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

having the "mei" driver loaded, which happened automatically on my
ThinkPad X200s, successfully prevents any suspend efforts:

[39736.728116] pci_pm_suspend(): mei_pci_suspend+0x0/0xc0 [mei] returns 9999

The code has not changed since 3.0-rc2, so I did not try compiling latest
git.

Jiri Slaby hinted that this code in drivers/staging/mei/wd.c is to blame:

169         ret = wait_event_interruptible_timeout(dev->wait_stop_wd,
170                                         dev->wd_stopped, 10 * HZ);

I am, however, not familiar enough with timers and stuff to immediately
spot the problem.

Removing the module before suspend is a workaround.

This could be considered a regression, as suspend worked very well before
this driver was introduced :-)

Best regards,

	Stefan
-- 
Stefan Seyfried

Linux Consultant & Developer
B1 Systems GmbH
Osterfeldstraﬂe 7 / 85088 Vohburg / http://www.b1-systems.de
GF: Ralph Dehner / Unternehmenssitz: Vohburg / AG: Ingolstadt,HRB 3537

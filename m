Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab1ACQiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 11:38:54 -0500
Received: from outbound-queue-1.mail.thdo.gradwell.net ([212.11.70.34]:56934
	"EHLO outbound-queue-1.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932113Ab1ACQix convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 11:38:53 -0500
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Jan 2011 11:38:52 EST
Subject: Using s3virge card in Sun Blade 2000
From: Alex Buell <alex.buell@munted.org.uk>
Reply-To: alex.buell@munted.org.uk
To: linux-fbdev@vger.kernel.org,
        Mailing Lists - Kernel Developers 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: One very high maintenance cat for company
Date: Mon, 03 Jan 2011 16:32:16 +0000
Message-ID: <1294072336.17576.7.camel@lithium>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
X-Gradwell-MongoId: 4d21fa5e.2337-3f0d-2
X-Gradwell-Auth-Method: mailbox
X-Gradwell-Auth-Credentials: postmaster@pop3.munted.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I hope the fbdev list is still in use. I have just been experimenting
with using my old S3ViRGE PCI card in my Sun Blade 2000 as its primary
display adapter has no X11 driver available for it. 

I put the card into my SPARC and booted up, after compiling in the s3fb
driver into the kernel. 

On boot-up, it uses the e3d framebuffer driver, and detects the s3fb
card but ignores it as seen in dmesg:

s3fb 0000:00:03.0: ignoring secondary device

I then pulled out the primary graphic card (XVR-500) and rebooted. I got
the following lines in dmesg:

vgaarb: device added: PCI:0000:00:03.0,decodes=io
+mem,owns=mem,locks=none
vgaarb: loaded
s3fb 0000:00:03.0: ignoring secondary device

It seems a bit odd that it is still ignoring the S3ViRGE card given that
it is now the only graphic adapter in the system. 

I then commented out the following code in drivers/video/s3fb.c:

      if (! svga_primary_device(dev)) {
                dev_info(&(dev->dev), "ignoring secondary device\n");
                return -ENODEV;
        }

and rebooted. 

It got as far as the switching to console device before it hung. 

I'm aware the s3fb driver has big endian issues, I can help fix those
issues so I can get the card working. Or in other words, I'd welcome
advice on how to proceed with this. 

Thanks!
-- 
Tactical Nuclear Kittens

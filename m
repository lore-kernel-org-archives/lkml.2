Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab3ADRuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 12:50:13 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:53070 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab3ADRuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 12:50:11 -0500
Date: Fri, 4 Jan 2013 18:49:58 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Kees Bakker <spam@tasking.nl>
Cc: linux-kernel@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: Re: drm/nouveau E[     DRM] fail ttm_validate
Message-ID: <20130104174958.GA15275@joi.lan>
References: <65b9.50e6c93a.b1791@altium.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65b9.50e6c93a.b1791@altium.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 01:21:14PM +0100, Kees Bakker wrote:
> Hi,
> 
> Right after I upgraded to Ubuntu quantal I started seeing these
> messages:
> Jan  4 12:18:12 koli kernel: [ 3705.970720] nouveau E[     DRM] fail ttm_validate
> Jan  4 12:18:12 koli kernel: [ 3705.970726] nouveau E[     DRM] validate vram_list
> Jan  4 12:18:12 koli kernel: [ 3705.970760] nouveau E[     DRM] validate: -12

This is userspace bug. See below.

> A few times I had corrupted graphics, and I had to stop X. Restarting didn't
> help and I had to reboot.
> 
> I'm running my own 3.7.1 kernel, so I also installed the 3.7.0 development kernel
> from Ubuntu (3.7.0-7). And that kernel shows these messages too.
> 
> With the Ubuntu kernel the graphics corruption is milder. I can continue to work. Sometimes
> I get a burst of the messages, but I have no clue how it is triggered.
> 
> Now the strange thing is that I was running my 3.7.1 kernel on Ubuntu precise
> and I have never seen these messages before. What could be the case is that
> xorg is doing something new and that is causing the errors.
> 
> xserver-xorg-video-nouveau
>    precise 1:1.0.2-0ubuntu3
>    quantal 1:0.0.16+git20111201+b5534a1-1build2

(Please do not use distro codenames when reporting bugs upstream)

Quantal, being newer release than Precise, ships much older Nouveau DDX, WTF?
You used some PPA with Precise?

0.0.16 is known to behave like that - you need to upgrade to >= 1.0.

> 
> Some more details
> /var/log/syslog:Jan  4 11:16:42 koli kernel: [    0.000000] Linux version 3.7.0-7-generic (root@koli) (gcc version 4.7.2 (Ubuntu/Lin
> /var/log/syslog:Jan  4 11:16:44 koli kernel: [   18.081288] [drm] Initialized drm 1.1.0 20060810
> /var/log/syslog:Jan  4 11:16:45 koli kernel: [   18.615246] nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x04b300b1
> /var/log/syslog:Jan  4 11:16:45 koli kernel: [   18.615251] nouveau  [  DEVICE][0000:01:00.0] Chipset: G73 (NV4B)
> /var/log/syslog:Jan  4 11:16:45 koli kernel: [   18.615254] nouveau  [  DEVICE][0000:01:00.0] Family : NV40
> /var/log/syslog:Jan  4 11:16:45 koli kernel: [   18.616802] nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for image...
> /var/log/syslog:Jan  4 11:16:45 koli kernel: [   18.655315] nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
> /var/log/syslog:Jan  4 11:16:45 koli kernel: [   18.655320] nouveau  [   VBIOS][0000:01:00.0] using image from PRAMIN
> /var/log/syslog:Jan  4 11:16:45 koli kernel: [   18.655505] nouveau  [   VBIOS][0000:01:00.0] BIT signature found
> /var/log/syslog:Jan  4 11:16:45 koli kernel: [   18.655509] nouveau  [   VBIOS][0000:01:00.0] version 05.73.22.67
> /var/log/syslog:Jan  4 11:16:45 koli kernel: [   18.660805] nouveau  [     PFB][0000:01:00.0] RAM type: DDR2
> /var/log/syslog:Jan  4 11:16:45 koli kernel: [   18.660811] nouveau  [     PFB][0000:01:00.0] RAM size: 256 MiB

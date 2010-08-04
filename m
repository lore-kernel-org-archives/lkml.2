Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab0HDHg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:36:59 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:52680 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758452Ab0HDHg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:36:57 -0400
Date: Wed, 4 Aug 2010 09:35:46 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: linux-raid@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: How to track down abysmal performance ata - raid1 - crypto - vg/lv
 - xfs
Message-ID: <20100804073546.GA7494@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	linux-raid@vger.kernel.org, xfs@oss.sgi.com,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

on a production system I run kernel 2.6.35 and

	XFS	(rw,relatime,nobarrier)

on a

	lvdevice of a vgroup 

consisting of five

	dm-crypt devices (cryptsetup -c aes-lrw-benbi -s 384 create)

, each of which runs on a

	md-raid1 device (mdadm --create --level=raid1 --raid-devices=2)

on two

	750 GB ATA devices.


The read performance is abysmal. The ata devices can be ruled out, as hdparm
resulted in acceptable performance:
> Timing cached reads:   9444 MB in  2.00 seconds = 4733.59 MB/sec
> Timing buffered disk reads:  298 MB in  3.02 seconds =  98.73 MB/sec

How can I best track down the cause of the performance problem, 
a) without rebooting too often, and
b) without breaking up the setup specified above (production system)?

Any ideas? perf(1)? iostat(1)?

Thanks & best,

	Dominik

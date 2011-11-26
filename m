Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab1KZEcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 23:32:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47954 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab1KZEcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 23:32:12 -0500
From: tom.leiming@gmail.com
To: tony@atomide.com, greg@kroah.com, arnd@arndb.de
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] OMAP4&drivers/misc: introduce face detection module driver
Date: Sat, 26 Nov 2011 12:31:41 +0800
Message-Id: <1322281904-14526-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches(against -next tree) introduce a device driver under
drivers/misc for enabling one face detection IP[1] which is
integrated inside OMAP4 SoC currently, and have some OMAP4
platform dependent changes to make the module workable on OMAP4 SoC.

For verification purpose, I write one user space utility[2] to
test the module and driver, follows its basic functions:

	- detect faces in a input grayscal picture(PGM raw, 320 by 240)
	- plot a rectangle to mark the detected faces, and save it as
	another same type grayscal picture
	- set detection parameters

I should have though about implementing a face detection demo on video
playback from uvc camera, but OMAP4 DSS on -next tree can't work,
so have to quit the idea.

Looks the performance of the module is not bad, see some detection
results on the link[3][4]. 

Face detection can be used to implement some interesting applications
(camera, face unlock, baby monitor, ...).

 arch/arm/mach-omap2/devices.c              |   33 +
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   81 +++
 drivers/misc/Kconfig                       |    7 +
 drivers/misc/Makefile                      |    1 +
 drivers/misc/fdif.c                        |  874 ++++++++++++++++++++++++++++
 include/linux/fdif.h                       |   67 +++
 include/linux/major.h                      |    1 +
 7 files changed, 1064 insertions(+), 0 deletions(-)


thanks,
--
Ming Lei


[1], Ch9 of OMAP4 Technical Reference Manual
[2], http://kernel.ubuntu.com/git?p=ming/fdif.git;a=summary
[3], http://kernel.ubuntu.com/~ming/dev/fdif/output
[4], All pictures are taken from http://www.google.com/imghp
and converted to pnm from jpeg format, only for test purpose.


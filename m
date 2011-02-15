Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab1BOVvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 16:51:24 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42977 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848Ab1BOVvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 16:51:22 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6258"; a="74390479"
Message-ID: <4D5AF554.2030208@codeaurora.org>
Date: Tue, 15 Feb 2011 13:51:16 -0800
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: dilinger@queued.net, Samuel Ortiz <sameo@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-arm-msm@vger.kernel.org
Subject: platform data and mfd design question
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently all the mfd devices declare their struct mfd_cell 
sub_devices[] array within the core driver. The platform data to them is 
either passed in as a part of the core driver's platform data.

Msm on the other hand declares the struct mfd_cell subdevice[] array in 
the board file and passes this on to the core driver via platfom data.
This code can be found here (sorry for the long url - it is convinient 
to click on it),
https://www.codeaurora.org/gitweb/quic/la/?p=kernel/msm.git;a=blob;f=arch/arm/mach-msm/board-msm8x60.c;h=ed9e9a7674b5ee443f25af828a0044ff99fac483;hb=refs/heads/android-msm-2.6.35
look for static struct mfd_cell pm8058_subdevs[]

This gives one the convenience of changing the mfd_cells and their 
platform data in the board file itself. There are boards where the 
platform data of some cells changes and in some cases we dont even add a 
particular cell.

This design makes the core driver very light weight. All it does is 
calls mfd_add_devices on the cell array passed from its platform data.

Will this be acceptable in mainline OR do we need to change to follow 
how others in drivers/mfd do it which is to define the mfd_cell array in 
the core file itself and manipulate their platform data before doing 
mfd_add_devices.


--
Sent by an employee of the Qualcomm Innovation Center, Inc. The Qualcomm 
Innovation Center, Inc. is a member of the Code Aurora Forum.

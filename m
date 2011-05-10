Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899Ab1EJVpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 17:45:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61167 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab1EJVpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 17:45:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver.
Date: Tue, 10 May 2011 23:44:58 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Nori, Sekhar" <nsekhar@ti.com>, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        sachi@mistralsolutions.com, "Samuel Ortiz" <sameo@linux.intel.com>,
        "open list" <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <201105051612.18522.arnd@arndb.de> <FBFC0000E34D487086421780A0F5252A@subhasishg>
In-Reply-To: <FBFC0000E34D487086421780A0F5252A@subhasishg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105102344.58598.arnd@arndb.de>
X-Provags-ID: V02:K0:cQn5E764kppI8vPxG+oeJbLW3z0WfBhlwpe98dhf6lr
 QCVFFrthM1xx6JkN5wdtF1IzAlxfvNQsmF1kTNCzUkITNiAWg8
 ZGMCwEH0dayVOT8LTTOv/PgLPV/lRH9fPNE8mh+2kAi4kB9/EG
 zWXrMN6+73wmP8rqWV/cabiMY3hTUnmV3cDQBEcVQVMFA/4WVv
 o+8XArblFt/fQ9Tp44RuA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 May 2011, Subhasish Ghosh wrote:
> > Instead of passing a configuration file into the MFD driver and
> > calling it a firmware, I can see three other options that I believe
> > would be nicer:
> > 
> > 1. have a single firmware blob that describes the child devices
> > and the code that is to be loaded into both units. If they are
> > acting as one device, either make sure you only create one
> > child node, or create one with a name that no driver binds to.
> > 
> > 2. Call request_firmware separately for the two child devices,
> > and configure them separately based on the information in the
> > firmware files. In the case where they should act as a single
> > device, call the children e.g. "pruss-uart-a" and "pruss-uart-b",
> > then bind to both names in the pruss-uart drivers and only
> > start using the device when you have both nodes for the same
> > parent.
> > 
> > 3. Do the configuration through sysfs files in the MFD device node,
> > which then cause the creation of the child devices. This means you
> > need extra user space scripts to write the addititonal files, but
> > is also the most flexible way.
> > 
> 
> Are you suggesting something like:
> 
> /sys..../pruss/pru0/id
> /sys..../pruss/pru0/fw_name
> /sys..../pruss/pru0/load
> 
> /sys..../pruss/pru1/id
> /sys..../pruss/pru1/fw_name
> /sys..../pruss/pru1/load

No, that is none of the three I suggested.

> I can program these configs and store them in the pru private.
> Then write something into load.
> This can load the PRU based upon the configs.
> But, I am not sure how to do this effectively using sysfs,
> I mean I don't want to end up writing six write and six read
> handlers. 

Please look into implementing one of the three I suggested before
you go off in another direction. In case of the third one, the idea
was to configure the name of the device for each pru using sysfs,
which then gets bound to the driver, which loads its own firmware
as you do today. Only in the first two suggestions, the mfd driver
would be responsible for loading the firmware.

	Arnd

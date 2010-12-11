Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab0LKTaO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 14:30:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46236 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab0LKTaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 14:30:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [linux-pm] 2.6.37-rc5, pata_atiixp, DVD-ROM: kernel log flooded with "rpm_resume flags 0x4", "rpm_resume returns 1"
Date: Sat, 11 Dec 2010 20:29:08 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5+; KDE/4.4.4; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20101211173234.77617d3a@stein>
In-Reply-To: <20101211173234.77617d3a@stein>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012112029.08895.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 11, 2010, Stefan Richter wrote:
> Hi,
> 
> I just booted from 2.6.36 (without PM debugging configured) into
> 2.6.37-rc5 (with PM debugging enabled).  There is endless log spam like
> this:

I guess you have either CONFIG_PM_VERBOSE set or CONFIG_PM_DEBUG unset.

Which is the case?

Rafael


> Dec 11 17:11:31 stein kernel: scsi host6: rpm_resume flags 0x4
> Dec 11 17:11:31 stein kernel: scsi host6: rpm_resume returns 1
> Dec 11 17:11:31 stein kernel: scsi host6: rpm_resume flags 0x4
> Dec 11 17:11:31 stein kernel: scsi host6: rpm_resume returns 1
> Dec 11 17:11:31 stein kernel: scsi host6: rpm_resume flags 0x4
> Dec 11 17:11:31 stein kernel: scsi host6: rpm_resume returns 1
> Dec 11 17:11:33 stein kernel: scsi host6: rpm_resume flags 0x4
> Dec 11 17:11:33 stein kernel: scsi host6: rpm_resume returns 1
> Dec 11 17:11:33 stein kernel: scsi host6: rpm_resume flags 0x4
> Dec 11 17:11:33 stein kernel: scsi host6: rpm_resume returns 1
> Dec 11 17:11:33 stein kernel: scsi host6: rpm_resume flags 0x4
> Dec 11 17:11:33 stein kernel: scsi host6: rpm_resume returns 1
> Dec 11 17:11:33 stein kernel: scsi host6: rpm_resume flags 0x4
> Dec 11 17:11:33 stein kernel: scsi host6: rpm_resume returns 1
> Dec 11 17:11:33 stein kernel: scsi host6: rpm_resume flags 0x4
> Dec 11 17:11:33 stein kernel: scsi host6: rpm_resume returns 1
> Dec 11 17:11:33 stein kernel: scsi host6: rpm_resume flags 0x4
> Dec 11 17:11:33 stein kernel: scsi host6: rpm_resume returns 1
> Dec 11 17:11:35 stein kernel: scsi host6: rpm_resume flags 0x4
> Dec 11 17:11:35 stein kernel: scsi host6: rpm_resume returns 1
> Dec 11 17:11:35 stein kernel: scsi host6: rpm_resume flags 0x4
> Dec 11 17:11:35 stein kernel: scsi host6: rpm_resume returns 1
> Dec 11 17:11:35 stein kernel: scsi host6: rpm_resume flags 0x4
> Dec 11 17:11:35 stein kernel: scsi host6: rpm_resume returns 1
> Dec 11 17:11:35 stein kernel: scsi host6: rpm_resume flags 0x4
> Dec 11 17:11:35 stein kernel: scsi host6: rpm_resume returns 1
> Dec 11 17:11:35 stein kernel: scsi host6: rpm_resume flags 0x4
> Dec 11 17:11:35 stein kernel: scsi host6: rpm_resume returns 1
> Dec 11 17:11:35 stein kernel: scsi host6: rpm_resume flags 0x4
> Dec 11 17:11:35 stein kernel: scsi host6: rpm_resume returns 1
> Dec 11 17:11:37 stein kernel: scsi host6: rpm_resume flags 0x4
> Dec 11 17:11:37 stein kernel: scsi host6: rpm_resume returns 1
> Dec 11 17:11:37 stein kernel: scsi host6: rpm_resume flags 0x4
> Dec 11 17:11:37 stein kernel: scsi host6: rpm_resume returns 1
> Dec 11 17:11:37 stein kernel: scsi host6: rpm_resume flags 0x4
> Dec 11 17:11:37 stein kernel: scsi host6: rpm_resume returns 1
> 
> Why is rpm_resume performed 6 times every two seconds?
> 
> host6 is pata_atiixp with an:
> 
> 00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller
> (prog-if 8a [Master SecP PriP])
> 
> # grep . /sys/class/scsi_host/host6/power/*
> /sys/class/scsi_host/host6/power/async:enabled
> grep: /sys/class/scsi_host/host6/power/autosuspend_delay_ms: Input/output error
> /sys/class/scsi_host/host6/power/control:auto
> /sys/class/scsi_host/host6/power/runtime_active_kids:0
> /sys/class/scsi_host/host6/power/runtime_active_time:0
> /sys/class/scsi_host/host6/power/runtime_enabled:disabled
> /sys/class/scsi_host/host6/power/runtime_status:unsupported
> /sys/class/scsi_host/host6/power/runtime_suspended_time:0
> /sys/class/scsi_host/host6/power/runtime_usage:0
> 
> Attached to it is one device:
> 
> Host: scsi6 Channel: 00 Id: 00 Lun: 00
>   Vendor: PLEXTOR  Model: DVD-ROM PX-130A  Rev: 1.01
>   Type:   CD-ROM                           ANSI  SCSI revision: 05
> 
> # grep . /sys/class/scsi_host/host6/device/target6\:0\:0/6\:0\:0\:0/power/*
> /sys/class/scsi_host/host6/device/target6:0:0/6:0:0:0/power/async:enabled
> grep: /sys/class/scsi_host/host6/device/target6:0:0/6:0:0:0/power/autosuspend_delay_ms: Input/output error
> /sys/class/scsi_host/host6/device/target6:0:0/6:0:0:0/power/control:on
> /sys/class/scsi_host/host6/device/target6:0:0/6:0:0:0/power/runtime_active_kids:0
> /sys/class/scsi_host/host6/device/target6:0:0/6:0:0:0/power/runtime_active_time:2689146
> /sys/class/scsi_host/host6/device/target6:0:0/6:0:0:0/power/runtime_enabled:forbidden
> /sys/class/scsi_host/host6/device/target6:0:0/6:0:0:0/power/runtime_status:active
> /sys/class/scsi_host/host6/device/target6:0:0/6:0:0:0/power/runtime_suspended_time:0
> /sys/class/scsi_host/host6/device/target6:0:0/6:0:0:0/power/runtime_usage:2
> 


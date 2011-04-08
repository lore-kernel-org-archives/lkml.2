Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab1DHUPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 16:15:19 -0400
Received: from mail.digium.com ([216.207.245.2]:46174 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757782Ab1DHUPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 16:15:17 -0400
Date: Fri, 8 Apr 2011 15:15:13 -0500
From: Shaun Ruffell <sruffell@digium.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6.39-rc2][bisected] Constant DISK_MEDIA_CHANGE_EVENTS from
	CDROM drive.
Message-ID: <20110408201513.GA3040@digium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running with 2.6.39-rc2 on a CentOS 5.5 installation with a "IDE interface:
Intel Corporation 82801CA Ultra ATA Storage Controller (rev 02)" (8086:248b),
I've noticed constant DISK_MEDIA_CHANGE uevents.  In my kernel log: 

[ 1107.530699] kobject: 'hda' (f5372610): fill_kobj_path: path = '/block/hda'
[ 1109.580559] kobject: 'hda' (f5372610): kobject_uevent_env
[ 1109.580594] kobject: 'hda' (f5372610): fill_kobj_path: path = '/block/hda'
[ 1111.630560] kobject: 'hda' (f5372610): kobject_uevent_env
[ 1111.630595] kobject: 'hda' (f5372610): fill_kobj_path: path = '/block/hda'
[ 1113.680560] kobject: 'hda' (f5372610): kobject_uevent_env

And from udevmonitor --env:

UEVENT[1302291995.789487] change@/block/hda
ACTION=change
DEVPATH=/block/hda
SUBSYSTEM=block
DISK_MEDIA_CHANGE=1
MAJOR=3
MINOR=0
DEVNAME=hda
DEVTYPE=disk
SEQNUM=1318

I bisected it down to 929e27252e8ca69363f81f26af5eaba62cb4c572 'ide:
ide_requeue_and_plug() reinstate "always plug" behaviour'

I haven't yet looked into how that change would result in the change in
behavior I'm seeing but I thought I would let you know sooner rather than
leter in case this is something that is already known.

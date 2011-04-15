Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab1DORNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 13:13:46 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33934 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab1DORNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 13:13:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=yF8pW7t8WMLzYIABt9unSmWbtJN7lxsurl+rD1XDuXJtIx1Es2X0bk5z2qij5di2ea
         QFUrQniqHM0lZB/YDNJ0m96CTXWbnDCONIcDnjHcCB1LyMwmyJIZzsaCXM7GEA+rGNXN
         gs+3z4bMyrW1Q2IJ4fMR1BnigJ1NOuGmfmDOI=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Shaun Ruffell <sruffell@digium.com>
Subject: Re: [2.6.39-rc2][bisected] Constant DISK_MEDIA_CHANGE_EVENTS from CDROM drive.
Date: Fri, 15 Apr 2011 19:13:38 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38; KDE/4.4.5; i686; ; )
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org
References: <20110408201513.GA3040@digium.com>
In-Reply-To: <20110408201513.GA3040@digium.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201104151913.38841.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=33342
for your bug report, please add your address to the CC list in there, thanks!

On piątek, 8 kwietnia 2011 o 22:15:13 Shaun Ruffell wrote:
> Running with 2.6.39-rc2 on a CentOS 5.5 installation with a "IDE interface:
> Intel Corporation 82801CA Ultra ATA Storage Controller (rev 02)"
> (8086:248b), I've noticed constant DISK_MEDIA_CHANGE uevents.  In my
> kernel log:
> 
> [ 1107.530699] kobject: 'hda' (f5372610): fill_kobj_path: path =
> '/block/hda' [ 1109.580559] kobject: 'hda' (f5372610): kobject_uevent_env
> [ 1109.580594] kobject: 'hda' (f5372610): fill_kobj_path: path =
> '/block/hda' [ 1111.630560] kobject: 'hda' (f5372610): kobject_uevent_env
> [ 1111.630595] kobject: 'hda' (f5372610): fill_kobj_path: path =
> '/block/hda' [ 1113.680560] kobject: 'hda' (f5372610): kobject_uevent_env
> 
> And from udevmonitor --env:
> 
> UEVENT[1302291995.789487] change@/block/hda
> ACTION=change
> DEVPATH=/block/hda
> SUBSYSTEM=block
> DISK_MEDIA_CHANGE=1
> MAJOR=3
> MINOR=0
> DEVNAME=hda
> DEVTYPE=disk
> SEQNUM=1318
> 
> I bisected it down to 929e27252e8ca69363f81f26af5eaba62cb4c572 'ide:
> ide_requeue_and_plug() reinstate "always plug" behaviour'
> 
> I haven't yet looked into how that change would result in the change in
> behavior I'm seeing but I thought I would let you know sooner rather than
> leter in case this is something that is already known.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Maciej Rutecki
http://www.maciek.unixy.pl

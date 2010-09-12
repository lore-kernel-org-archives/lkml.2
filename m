Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab0ILJte (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 05:49:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64655 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab0ILJtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 05:49:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=wiEHjPkzNTi2k8SoSv9/e2lDAieu2SWtVIcgWCYfh06fhUzEgzDsMR/vg2s1WKUgT1
         s7M0C5LxfK0sf/yC+kNP7Y0JO8t1eNxEsmnOxCw+lEM7+Km0ohMMMQrkMwMBC/SeiB9X
         cTCaqVE90gbm/mDkNvkrk1IOKqghuc375Whqk=
Subject: [REGRESSION] cdrom drive doesn't detect removal
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Sep 2010 11:49:29 +0200
Message-ID: <1284284969.2928.18.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After a switch between hal to devkit stack, a different strategy of
detecting a cdrom removal was applied.
Instead of polling it, userspace just tells the kernel not to lock the
dour (/proc/sys/dev/cdrom/lock) and as soon as user removes the disk,
udev notifies the userspace and it unmounts it. Since CDROMs are
readonly this is perfectly safe and fits the same procedure used for all
other removable disks. (usb, flash cards, etc..)

(Well, most cdroms aren't really read-only these days, but state of
packet writing is so sad these days that is doesn't matter).

However 2.6.36 doesn't detect that removal.
According to udevadm monitor --property no uevents are send on removal.

My feeling is that this is BKL fallout.
I of course use new libata stack, so my cdrom driver is sr.



Best regards,
Maxim Levitsky


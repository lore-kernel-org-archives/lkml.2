Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1EVONb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 10:13:31 -0400
Received: from edu-smtp-02.edutel.nl ([88.159.1.172]:41761 "EHLO
	edu-smtp-02.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab1EVONY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 10:13:24 -0400
Message-ID: <4DD919FD.9090000@neli.hopto.org>
Date: Sun, 22 May 2011 16:13:17 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: USB stick as root device does not work
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Using USB stick as root device does not work for me. I specify
'root=/dev/sdb1 rootwait' on the kernel commandline, but the kernel does
not wait for the USB stick to be scanned and its partitions found. I
have a harddisk which is /dev/sda, and this USB stick would be /dev/sdb.

I think blk_lookup_devt returns the block device number even if it does
not exist yet, and init/do_mounts.c:473 therefore skips waiting:

        if ((ROOT_DEV == 0) && root_wait) {

due to ROOT_DEV having become non-zero already.

If I use the commandline: 'root=/dev/sdb1 rootdelay=5' then it does
mount and boot properly. However, using rootwait seems safer and faster
to me, that it's meant for this use case.

Thanks for any pointers,

Micha

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839Ab1FQJ0C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 05:26:02 -0400
Received: from bar.sig21.net ([80.81.252.164]:58813 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358Ab1FQJ0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 05:26:00 -0400
X-Greylist: delayed 1294 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Jun 2011 05:26:00 EDT
Date: Fri, 17 Jun 2011 11:04:24 +0200
From: Johannes Stezenbach <js@sig21.net>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: missing compat-ioctl for CDROM_DRIVE_STATUS + FDGETPRM
Message-ID: <20110617090424.GA19345@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -3.8 (---)
X-Spam-21-Report: No, score=-3.8 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.649,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

running even a simple "qemu-img create -f qcow2 some.img 1G" causes
the following in dmesg on a Linux host with linux-2.6.39.1 x86_64 kernel
and 32bit userspace:

ioctl32(qemu-img:5296): Unknown cmd fd(3) cmd(00005326){t:'S';sz:0} arg(7fffffff) on some.img
ioctl32(qemu-img:5296): Unknown cmd fd(3) cmd(801c0204){t:02;sz:28} arg(fff77350) on some.img

(The same happens when starting a qemu or kvm vm.)

ioctl 00005326 seems to be CDROM_DRIVE_STATUS,
ioctl 801c0204 is FDGETPRM.  Both are used in
qemu/block/raw-posix.c in cdrom_probe_device()
and floppy_probe_device() respectively.

FWIW, I'm using qemu/kvm from Debian unstable
(qemu-0.14.0+dfsg-5.1, qemu-kvm-0.14.1+dfsg-1)


Johannes

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab0DMI5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 04:57:22 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:59343 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab0DMI5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 04:57:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:organization:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=EaQg3HY5tymwsv+usUN+nBsKpqRLSDUr3RWD3mr+uhX6oScrFxJd2f7RRICVZJOp7D
         AFa0H3Y0/YXBadpnVKlGJHTTHissI+DJ8YraP9mOFurj9cydD5uGoDcfYxlWnNsey8CT
         K4xdcvp5EyAivHnRmQiNLu1Gi+qccCgFyj06A=
From: Florian Fainelli <florian@openwrt.org>
To: linux-kernel@vger.kernel.org
Subject: Best way to do kernel only ldisc without user-space ldisc attaching?
Date: Tue, 13 Apr 2010 10:56:19 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-20-server; KDE/4.3.2; x86_64; ; )
Cc: alan@lxorguk.ukuu.org.uk, gregkh@suse.de
Organization: OpenWrt
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004131056.19984.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a line discpline driver for a custom protocol over an UART. This driver 
implements the following callbacks: open/close, receive_buf/write_wakeup.

So far, I have an ugly hack, which opens the /dev/tty<N> in the kernel, and 
directly uses the f_op and unlocked_ioctl functions to do the ldisc number to 
TTY device binding:

[snip]
struct file *f;

filp_open("/dev/ttyS1", 0, 0);

f->f_op->unlocked_ioctl(f, TCFLSH, 0x2);
memset(&tio, 0, sizeof(tio));
tio.c_cflag = my_flags;
tio.c_iflag = IGNPAR | ICRNL;
f->f_op->unlocked_ioctl(f, TCSETS, (long unsigned int)&tio);
f->f_op->unlocked_ioctl(f, TIOCSETD, (long unsigned int)&ldisc_nr);
set_fs(oldfs);
[snip]

This prevents me from rmmoding the module. However, I would like to avoid an 
user-space program from having to bind the TTY device to the ldisc number if 
possible.

Thank you very much for your answer.
--
Florian

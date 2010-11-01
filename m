Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab0KASzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:55:53 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61502 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab0KASzp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:55:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=Y3xl8OZ1VO4PmEST6VMlGczSb1xLoKFJ7329C7Y9tb6myZ1v1e+qIk3ANLG1TxcklT
         YQR6y2SSXJn/BBbmjuFF9J1U2V9oUY6d+MxXd/7gjfknR0BvJdokx33DNJ/i9fcdqx+V
         DDEn0VvQOtNuvKTmqRpVfSARZiFpw217bxheg=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: suspend-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: 2.6.37 rc1 doesn't suspend to ram
Date: Mon, 1 Nov 2010 19:55:39 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1; KDE/4.5.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201011011955.39485.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Some linus tree git commit in last few weeks broke suspend to ram here, s2ram -a3 -f says:

4310  open("/sys/power/state", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 16
4310  fstat(16, {st_mode=S_IFREG|0644, st_size=4096, ...}) = 0
4310  mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f81c05bc000
4310  write(16, "mem", 3)               = -1 EIO (Input/output error)
4310  close(16)                         = 0
4310  munmap(0x7f81c05bc000, 4096)      = 0
4310  dup(2)                            = 16
4310  fcntl(16, F_GETFL)                = 0x8002 (flags O_RDWR|O_LARGEFILE)
4310  fstat(16, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 1), ...}) = 0
4310  mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f81c05bc000
4310  lseek(16, 0, SEEK_CUR)            = -1 ESPIPE (Illegal seek)
4310  write(16, "s2ram_do: Input/output error\n", 29) = 29
4310  close(16)                         = 0

It was working fine previously. Any clues before I try to bisect?

thinkpad t400, suspend-utils git snap from 20101027

$ grep SUSPEND .config
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_SUSPEND_NVS=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_USB_SUSPEND=y

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

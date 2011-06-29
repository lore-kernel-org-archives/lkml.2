Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab1F2Mas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 08:30:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58681 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab1F2Mao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 08:30:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Johannes Stezenbach <js@sig21.net>
Subject: Re: missing compat-ioctl for CDROM_DRIVE_STATUS + FDGETPRM
Date: Wed, 29 Jun 2011 14:30:42 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110617090424.GA19345@sig21.net> <201106171502.39445.arnd@arndb.de> <20110629113834.GA4227@sig21.net>
In-Reply-To: <20110629113834.GA4227@sig21.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106291430.43102.arnd@arndb.de>
X-Provags-ID: V02:K0:R92N3CH6ObQZ9hMR79gM33ZLCMiQJ/1/9IzElmHF9bS
 6plO5HuNn8s2AD4yH3uAfV7q/yXuAU8ih4UxtQQBELVU1lgQNg
 JylNX9cZMj7DHncUjEtAOOR1MZEZym9QiZq47IMw+IpuEDTWCQ
 fQt1CZCdHqn/iuhz4oJ2rHarEJ3SMFAluOTmwou8iyj1Df9cT1
 Etv67Bnidgv8trQwgYNoA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 June 2011, Johannes Stezenbach wrote:
> Sorry for very slow reply.  I think qemu's use of these ioctls
> to probe if the device is a cdrom or floppy is valid, so instead
> of adding a stat() call to check for block device in qemu, I think
> it is better to silence the warning in the kernel.

Well, correct or not, it will keep causing annoying messages on
old kernels, so why not do both?

> Do I get it right that just adding two IGNORE_IOCTL() to
> the ioctl_pointer array in linux/fs/compat_ioctl.c is sufficient,
> like in commit 3f001711?

Yes.

> I.e. these ioctls are handled for block devices earlier
> in compat_sys_ioctl()?

Right. We always first ask the driver, and then search the lookup table
when the driver does not know how to handle it in compat mode.

	Arnd

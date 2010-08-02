Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab0HBI4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:56:37 -0400
Received: from mail.yrkesakademin.fi ([85.134.44.20]:29302 "EHLO
	mail.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab0HBI4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:56:36 -0400
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Aug 2010 04:56:36 EDT
Message-ID: <4C5686FF.9010803@mandriva.org>
Date: Mon, 2 Aug 2010 11:51:11 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; sv-SE; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: bug-make@gnu.org, linuxppc-dev@ozlabs.org
Subject: make 3.82 fails on powerpc defconfig update [was: Linux 2.6.35]
References: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com>
In-Reply-To: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
(please cc me as I'm not subscribed)

updating from make 3.81 to 3.82 gets me this:

[thomas@tmb linux-2.6.35]$ cp arch/powerpc/configs/ppc64_defconfig .config
[thomas@tmb linux-2.6.35]$ LC_ALL=C make oldconfig ARCH=powerpc
/mnt/work/2.6.35/linux-2.6.35/arch/powerpc/Makefile:183: *** mixed 
implicit and normal rules.  Stop.

The lines are:

182:
183: $(BOOT_TARGETS): vmlinux
184:         $(Q)$(MAKE) ARCH=ppc64 $(build)=$(boot) $(patsubst 
%,$(boot)/%,$@)
185:

BOOT_TARGETS are defined on line 166 as:
BOOT_TARGETS = zImage zImage.initrd uImage zImage% dtbImage% treeImage.% 
cuImage.% simpleImage.%


Now it's not a regression in the kernel as the same happends with the 
2.6.34 tree too.

(btw, the host I'm syncing the defconfig with is a x86_64 machine)


Now, I dont know if this is "intended breakage" by the make update, or 
if the Makefile needs to be updated....

Any ideas how to fix ?

--
Thomas


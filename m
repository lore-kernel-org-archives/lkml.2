Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab0DVOTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 10:19:44 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:57443 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab0DVOTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 10:19:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=xqJhmh4Ylnqv3ERY59EnCA2oNlqkrQmiCPGVvqitd6beRenYVUQIgaiNNPuUvHY0Du
         DG51k5Aduo0GF5dX4Yv3TglLuLdnX/EQug9natJhrAsMAG/br5Aao5kEAvlUl2UcBe7c
         ueZacKcRdKNv3aLcSm9pFvveCQIJ+puYiaMxM=
MIME-Version: 1.0
From: Rishi Dhupar <rishid@gmail.com>
Date: Thu, 22 Apr 2010 10:19:21 -0400
Message-ID: <q2wb438ee181004220719hd5357d60r1a9bb395d9da7298@mail.gmail.com>
Subject: initramfs issue with console missing
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to use initramfs to run an embedded linux device.  I am
getting a kern warning printed during bootup that the kernel is unable
to open an initial console.  My rootfs does not contain a /dev/console
node; I was expecting to be able to create the /dev/console node in my
init script before the kernel tries to access the /dev tree.

Why does the kernel expect /dev/console to exist prior to running the
ramdisk init process?  I thought one of the benefits of initramfs was
it could run earlier in the init process, thus allowing me to create
devs and build the proc, sys directories at run-time. I know I could
do a mknod console on my host machine before building the rootfs but I
want my device to be able to get itself up and running with a minimal
file system.

For reference: init/main.c:init_post()
it checks if /dev/console exists (and prints warning) prior to calling
run_init_process(ramdisk_execute_command)

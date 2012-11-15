Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768349Ab2KOQFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 11:05:24 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40018 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768293Ab2KOQFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 11:05:23 -0500
Message-ID: <1352995520.26800.2.camel@rig.fritz.box>
Subject: Re: [PATCH 00/12] printk() fixes, optimizations, and clean ups
From: Kay Sievers <kay@vrfy.org>
To: "Jan H." =?ISO-8859-1?Q?Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Thu, 15 Nov 2012 17:05:20 +0100
In-Reply-To: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.1 (3.6.1-1.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-14 at 00:12 +0100, Jan H. Schönherr wrote:
> Hi Greg, hi Kay, and all other interested people.
> 
> This series aims at cleaning up and fixing some bugs around printk().
> Patches 9 and 11 might require some discussion, see below.

This is how current git looks like:
[    1.062953] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
[    1.090595] List of all partitions:
[    1.091703] 0800       117220824 sda  driver: sd
[    1.093054]   0801         1048576 sda1 1fcbc57f-4bfc-4c2b-91a3-9c84fbcd9af1
[    1.094662]   0802        30720000 sda2 084917b7-8be2-4e86-838d-f771a9902e08
[    1.096624]   0803        15360000 sda3 180053b6-6697-4f4c-b331-4925773197ff
[    1.098624]   0804        54730752 sda4 b67dfc6e-d06f-4b11-bd52-96c09163aca9
[    1.100304]   0805        15360000 sda5 6d0d537c-3107-4057-a57b-5379a0cd8e31
[    1.101918] No filesystem could mount root, tried:  btrfs
[    1.103633] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(8,1)


This with all your patches applied:
[    1.032804] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
[    1.063915] List of all partitions:
[    1.065521] 0800       117220824 sda  driver: sd
[    1.067444]   0801         1048576 sda1 1fcbc57f-4bfc-4c2b-91a3-9c84fbcd9af1  0802        30720000 sda2 084917b7-8be2-4e86-838d-f771a9902e08  0803        15360000 sda3 180053b6-6697-4f4c-b331-4925773197ff  0804        54730752 sda4 b67dfc6e-d06f-4b11-bd52-96c09163aca9  0805        15360000 sda5 6d0d537c-3107-4057-a57b-5379a0cd8e31No filesystem could mount root, tried:  btrfs
[    1.077120] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(8,1)


Something seems broken in the patches regarding the console or newline logic.

Thanks,
Kay


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab1GFC64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 22:58:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60306 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab1GFC6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 22:58:55 -0400
MIME-Version: 1.0
Date: Tue, 5 Jul 2011 20:58:54 -0600
Message-ID: <BANLkTi=x8AtwMdXWZ5Rv_F6WPMgWF+d4qw@mail.gmail.com>
Subject: Linux -2.6.39 reading MBR as garbage
From: Ben Johnson <myalphabetfamily@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,
  I have been fighting with this issue for a while now and I wanted to
see if someone could point me in the right direction.

I am running Linaro with a 2.6.39 kernel.  My issue is such that when
my system boots occasionally it reads the Master Boot record as
garbage.  In this case it fails to recognize the partition table and
fails to boot.  I have only seen this on 2.6.39 as I have recently
switched.

I have modified:
fs/partitions/check.c
fs/partitions/msdos.c

to give me a hex dump of the first 512 bytes of the partition table
from the kernels perspective.  This is what I get when it reads the
table correctly and it boots:

[    1.186218]
[    1.187896] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.193237] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.198547] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.203857] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.209197] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.214508] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.219818] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.225128] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.230468] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.235778] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.241088] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.246429] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.251708] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.257049] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.262359] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.267669] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.272979] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.278320] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.283630] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.288940] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.294281] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.299591] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.304901] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.310241] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.315551] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.320861] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.326171] 0000 0000 0000 0000 0000 0000 0000 0000
[    1.331481] 0000 0000 0000 0000 a314 9c65 0000 8001
[    1.336791] 0407 0c01 c4ff 3f00 0000 8639 0100 0001
[    1.342132] c4ff 8301 c4ff c539 0100 8639 4000 0001
[    1.347442] c4ff 8301 c4ff 4b73 4100 034f ad00 0000
[    1.352752] 0000 0000 0000 0000 0000 0000 0000 55aa


This is what I get when it reads garbage:


[    1.024108] 03d2 08ec 3268 ad73 ef28 62f1 4e27 a4d1
[    1.029479] dae4 de5a c5de 9cc7 4a93 bf69 8375 0b3e
[    1.034790] 3a84 9f1b 425b 8dd9 2cd6 eaf6 7e35 04be
[    1.040100] 1b84 5919 d654 f5fa 3c1c 884b 31ba a59f
[    1.045440] dd40 cf82 a10f c620 94c3 7a8b 1f3a 429d
[    1.050781] 8f4d 23ae c9e6 b457 b9f1 9425 78df 12c2
[    1.056091] 6e8d 672f 52e3 ee48 65b1 5da7 cdd0 ace3
[    1.061401] ea48 7db1 0da6 2dd4 ecfa 6a1d 7c4f 09a2
[    1.066741] 35cc bcab 8bf9 3816 9077 6133 46ab 97f9
[    1.072052] 7017 2072 c12e 86e7 1652 75ed 3c6e 8967
[    1.077362] 3752 b3ef a861 f144 2798 d152 e7ee 5065
[    1.082702] e15c 47c9 90b5 63bf 4983 b509 be35 84bd
[    1.088012] 1b8e 5925 d6dc f6ca 36bc b78b b139 a695
[    1.093322] d77c f30a 2a3c fc8a 0b3c 3a88 9f33 42ab
[    1.098663] 8ff9 2016 c076 8137 06b2 17ac 71e9 2476
[    1.103942] d936 d6b6 f7b6 31b4 a5bb dd98 cd52 afef
[    1.109283] e060 4141 8785 111e 6645 559f fd40 0f80
[    1.114624] 2100 c602 940f 7823 10ca 62bd 4f8f a121
[    1.119934] c6c4 969b 775b 33da a8df f2c0 2e80 e702
[    1.125244] 520d ec2c 68e9 7277 2d32 eeae 67e5 505f
[    1.130584] e1c0 4481 9b05 5a1f dc40 c982 b50f be21
[    1.135894] 84c5 1a9e 5f45 c39c 894b 37ba b19f a541
[    1.141204] df84 c11a 865f 15c2 7c8d 0b2e 3ae4 9e5b
[    1.146545] 45db 9cd9 4ad7 bef1 8625 14de 7ac5 1e9e
[    1.151855] 4745 939d 694f 77a3 31ca a4bf db80 d902
[    1.157165] d60e f426 38d4 92fb 6e1b 645b 59db d4d8
[    1.162506] fad2 1eec 4669 9575 7f3f 0282 0f0c 2228
[    1.167816] ccf2 aa2f fce0 0a40 3d80 8d03 2e0a e43e
[    1.173126] 5885 d31c ea4a 7dbd 0d8e 2d24 eeda 66dd
[    1.178436] 56cf f6a0 37c0 b083 a309 ca34 bcbb 8b99
[    1.183776] 3956 97f7 7033 20aa c3fe 8807 3012 a06f
[    1.189086] c160 8743 138a 693d 768f 3722 b2cf aea1

I am using a uSD card and I took the card out and did a DD of the
first 512 bytes and got the good MBR.  So for some reason I think the
kernel is reading incorrectly some of the time.  Any ideas?

Thanks,
Ben

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab0F0XGA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 19:06:00 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:47738 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab0F0XF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 19:05:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=YryQ69ZVjGCzAHroXvbTJ+qlad7JxSnlV0nh0betodboLlr3LUdIOxs1bJsY/BBL6i
         UZQSp7wTmRiZt033uBCrZo3pwfPBHg8CB/vmkXyjvJk/Rj4JqY12Z1Ho+RaUJc+bAVxo
         o/BM1gIrvYLCC1Im2HrRddJtRwtARZ4X83GFU=
MIME-Version: 1.0
From: Ragnar Hojland Espinosa <ragnar@ragnar-hojland.com>
Date: Mon, 28 Jun 2010 01:05:28 +0200
X-Google-Sender-Auth: A7_74uWnJY06OGTI4kV22v7CQiE
Message-ID: <AANLkTinR6E9hSkopCgqcVK9WHojNKesAH_5V5XoWSjiA@mail.gmail.com>
Subject: 2.6.34 ext4_mb_free_metadata: Double free of blocks
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving about 200 GB through the network out of the computer (vanilla
2.6.34, sata_via sata device), after it finished I noticed:

EXT4-fs error (device sda1): ext4_mb_free_metadata: Double free of
blocks 20764 (20764 395)
JBD: Spotted dirty metadata buffer (dev = sda1, blocknr = 0). There's
a risk of filesystem corruption in case of system crash..

So I proceeded to umount and fsck.

# umount /vol3/
# fsck -f /vol3/
fsck from util-linux-ng 2.17.2
e2fsck 1.41.11 (14-Mar-2010)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong for group #6764 (17193, counted=16798).
Fix<y>? yes

Free blocks count wrong (44974340, counted=44973945).
Fix<y>? yes

FWIW.
-- 
Ragnar

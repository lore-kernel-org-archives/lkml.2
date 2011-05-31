Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379Ab1EaIfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 04:35:17 -0400
Received: from forward13.mail.yandex.net ([95.108.130.120]:39624 "EHLO
	forward13.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab1EaIfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 04:35:11 -0400
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 May 2011 04:35:11 EDT
X-Yandex-Spam: 1
From: Dmitry Dmitriev <dimondmm@yandex.ru>
To: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org
Subject: =?utf-8?B?UFJPQkxFTTogQ29ycnVwdCBpbm9kZSBmbGFncyB3aGVuIHJlbW92ZSBBVFRSX1NZUyBmbGFnIG9uIGZh?=
	=?utf-8?B?dCBmaWxlIHN5c3RlbSBtb3VudGVkIHdpdGgg4oCcc3lzX2ltbXV0YWJsZeKAnSBtb3VudCBvcHRpb24u?=
MIME-Version: 1.0
Message-Id: <31181306830445@web159.yandex.ru>
Date: Tue, 31 May 2011 12:27:24 +0400
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Inode flags are corrupted when removing ATTR_SYS flag by FAT_IOCTL_SET_ATTRIBUTES ioctl on fat file system mounted with “sys_immutable” mount option. In this case S_IMMUTABLE flag must be removed from inode flags, but actually removed all other flags except S_IMMUTABLE. This problem observed on 2.6.34 kernel, but it seems still exist( after examine of 2.6.39 kernel source code ).

The problem in fat_ioctl_set_attributes function( fs/fat/file.c ). This function contains following code(2.6.39 kernel):
 101        if (sbi->options.sys_immutable) {
 102                if (attr & ATTR_SYS)
 103                        inode->i_flags |= S_IMMUTABLE;
 104                else
 105                        inode->i_flags &= S_IMMUTABLE;
 106        }

Instead of removing S_IMMUTABLE flag from inode flags on line 105 function removes all other flags from inode flags. I think that line 105 must be following:

 105                        inode->i_flags &= ~S_IMMUTABLE;

Regards,
Dmitry

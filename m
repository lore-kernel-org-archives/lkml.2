Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab0FHNdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 09:33:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46846 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab0FHNdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 09:33:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:openpgp:content-type
         :content-transfer-encoding;
        b=EeUYLSt/7CYwDOtfoNkk0g5V/DbdKMmX3RMIfvWcWSckiW+aNwpqunHrqnX8EepR8q
         nNS8RpXU+6PdBo7V1h4MeorhVLKOHLohhOclGvoSt/Lr1OTf59mUQwYJn80TcvOnx3bf
         DncFvyc96ccKIWpm3qSnTPvPyP4Fc2SyWyOnA=
Message-ID: <4C0E469E.7030808@gmail.com>
Date: Tue, 08 Jun 2010 16:33:18 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: Theodore Tso <tytso@MIT.EDU>
CC: Jeffrey Merkey <jeffmerkey@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: EXT3 File System Corruption 2.6.34
References: <AANLkTinQatQEYahpkN3bT-S5C41HqRoH--gTrvIbGs_c@mail.gmail.com> <4C0D5DCD.5010201@sandeen.net> <AANLkTik1T2nJxsoK9UGIVy6q6pfSxniFfJXJY0InmuUh@mail.gmail.com> <AANLkTil4FMnGl7llR4N0PkXuNyEClQmTspNK6PT62PAi@mail.gmail.com> <889B6B31-A1F0-438D-B782-DBB855912 <7707881C-9879-4531-8DE9-EEED2F4534E5@mit.edu>
In-Reply-To: <7707881C-9879-4531-8DE9-EEED2F4534E5@mit.edu>
X-Enigmail-Version: 1.0.1
OpenPGP: id=5379965D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2010 02:14 PM, Theodore Tso wrote:
> 
> If you pull the plug without fsyncing the file, you will end up with a zero-length file -- or possibly no file at all, even with data=ordered.  If you really want to preserve data after pulling the power cord immediately after a write were the application hasn't done an fsync() or a sync() call, you can mount the file system with the mount option -o sync --- but then the performance will be horrible.
> 
> It's all a tradeoff of what you think is important....
> 

I think you should either get the old file, or the new file (if you
don't fsync), and not some random data from another file.
The manual entry for data=writeback only says that you may get old data
after a crash/recovery, not that you may get old/new data from *another*
file.

On the other hand I didn't specify any mount options, and I got
data=ordered. So is data=ordered the default or not?
Or does it depend whether you use ext3 or ext4 driver for ext3?

/etc/fstab has:
/dev/md3        /               ext3    noatime,errors=remount-ro 0       1

and my ext* related config options:
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_XATTR=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set

So I use the ext4 driver for the ext3 partition (I intended to convert
it to ext4 at some point, but didn't have time to do so yet).

This is with 2.6.34-00179-gdebb980 (drm-radeon-testing, which is
basically 2.6.34 + some radeon specific stuff).

Best regards,
--Edwin

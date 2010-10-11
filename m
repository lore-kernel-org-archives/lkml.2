Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab0JKHJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 03:09:14 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56803 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab0JKHJM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 03:09:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AAm6KnhSCkUXSTnsGl8xwYNf9JNCqzvb3wopHAUwcocfNj17CK6km4CD8Wp6ENFkLI
         /QnjzGUZm/2C0nyJX/Cj0HBqD/Z6pVsIF5r2nAwQZLeem5DIu8+jpKK1VIT23liNHOcC
         xg2upWcDM84h0td3qhjUtnaP0jr7TxHsohWIw=
MIME-Version: 1.0
In-Reply-To: <20101010100211.3c747512.rdunlap@xenotime.net>
References: <4CB1EC2F.7070807@gmail.com>
	<20101010100211.3c747512.rdunlap@xenotime.net>
Date: Mon, 11 Oct 2010 09:09:10 +0200
Message-ID: <AANLkTinrRMDshtMQ_iBvRNYeEDQdihtu9ggu++masczR@mail.gmail.com>
Subject: Re: [PATCH 16/16] pramfs Makefile and Kconfig
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/10 Randy Dunlap <rdunlap@xenotime.net>:
> On Sun, 10 Oct 2010 18:39:11 +0200 Marco Stornelli wrote:
>
>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>
>> Makefile and Kconfig.
>>
>> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
>> ---
>>  diff -Nurp linux-2.6.36-orig/fs/pramfs/Kconfig linux-2.6.36/fs/pramfs/Kconfig
>> --- linux-2.6.36-orig/fs/pramfs/Kconfig       1970-01-01 01:00:00.000000000 +0100
>> +++ linux-2.6.36/fs/pramfs/Kconfig    2010-09-14 18:49:52.000000000 +0200
>> @@ -0,0 +1,72 @@
>> +config PRAMFS
>> +     tristate "Persistent and Protected RAM file system support"
>> +     depends on HAS_IOMEM && EXPERIMENTAL
>> +     select CRC16
>> +     help
>> +        If your system has a block of fast (comparable in access speed to
>> +        system memory) and non-volatile RAM and you wish to mount a
>> +        light-weight, full-featured, and space-efficient filesystem over it,
>> +        say Y here, and read <file:Documentation/filesystems/pramfs.txt>.
>> +
>> +        To compile this as a module,  choose M here: the module will be
>> +        called pramfs.ko.
>
>          called pramfs.
>
> (we don't add the .ko suffix; well, we try not to do that)

Ok.

>
>> +
>> +config PRAMFS_XIP
>> +     bool "Enable Execute-in-place in PRAMFS"
>> +     depends on PRAMFS && !PRAMFS_WRITE_PROTECT
>> +     help
>> +        Say Y here to enable xip feature of PRAMFS.
>
>                                XIP

Ok.

>
>> +
>> +config PRAMFS_WRITE_PROTECT
>> +     bool "Enable PRAMFS write protection"
>> +     depends on PRAMFS && MMU
>> +     default y
>> +     help
>> +        Say Y here to enable the write protect feature of PRAMFS.
>> +
>> +config PRAMFS_XATTR
>> +     bool "PRAMFS extended attributes"
>> +     depends on PRAMFS
>> +     help
>> +       Extended attributes are name:value pairs associated with inodes by
>> +       the kernel or by users (see the attr(5) manual page, or visit
>> +       <http://acl.bestbits.at/> for details).
>> +
>> +       If unsure, say N.
>> +
>> +config PRAMFS_POSIX_ACL
>> +     bool "PRAMFS POSIX Access Control Lists"
>> +     depends on PRAMFS_XATTR
>> +     select FS_POSIX_ACL
>> +     help
>> +       Posix Access Control Lists (ACLs) support permissions for users and
>> +       groups beyond the owner/group/world scheme.
>> +
>> +       To learn more about Access Control Lists, visit the Posix ACLs for
>> +       Linux website <http://acl.bestbits.at/>.
>> +
>> +       If you don't know what Access Control Lists are, say N
>
> end sentence with period ('.').

Ok.

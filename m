Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab0GDE3w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 00:29:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45036 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab0GDE3t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 00:29:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xPcpnwbCIqNxVE9eBfqWhdxuBLucyHwXb7C5RQ4wB81Cy+65+59odP1U0MTDfY7guF
         O+hVDxFHDzfT0dCOEBhDtq/BgnXFncXl5nIZjax3f57Nz/sOjmvPyVEnx5KdE3DQ1MOx
         V9qHRc6kCOqUxmC37bPLoMZfjWfNPlDU2WHjQ=
MIME-Version: 1.0
In-Reply-To: <C80B6032-0FB2-4D63-B940-3FE86B52992B@dilger.ca>
References: <20100701235727.19035.84584.stgit@warthog.procyon.org.uk>
	<20100701235738.19035.21536.stgit@warthog.procyon.org.uk>
	<C80B6032-0FB2-4D63-B940-3FE86B52992B@dilger.ca>
Date: Sun, 4 Jul 2010 06:29:46 +0200
X-Google-Sender-Auth: 9LCiBtTUURiwRAjTkZLbutMOw70
Message-ID: <AANLkTimj6ors03ysxqyuiDcSxEdKqGxTCAppDnV3haTZ@mail.gmail.com>
Subject: Re: [PATCH 3/3] xstat: Implement a requestable extra result to 
	procure some inode flags [ver #4]
From: Michael Kerrisk <mtk.manpages@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
       samba-technical@lists.samba.org, linux-ext4@vger.kernel.org,
       linux-api@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC+=linux-api]

On Fri, Jul 2, 2010 at 7:45 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> On 2010-07-01, at 17:57, David Howells wrote:
>> [This is, for the moment, to be considered an example.  Do we actually want to
>> export these flags?  Should they be a full member of struct xstat?]
>
> I would say this should be a full-fledged member of struct xstat.
> I think they are fairly standard (available on many filesystems
> today), and requiring an ioctl to access them is unpleasant.
>
>> (1) User settable flags (to be consistent with the BSD st_flags field):
>>
>>       UF_NODUMP       Do not dump this file.
>>       UF_IMMUTABLE    This file is immutable.
>>       UF_APPEND       This file is append-only.
>>       UF_OPAQUE       This directory is opaque (unionfs).
>>       UF_NOUNLINK     This file can't be removed or renamed.
>>       UF_COMPRESSED   This file is compressed.
>>       UF_HIDDEN       This file shouldn't be displayed in a GUI.
>>
>>    The UF_SETTABLE constant is the union of the above flags.
>>
>> (2) Superuser settable flags (to be consistent with the BSD st_flags field):
>>
>>       SF_ARCHIVED     This file has been archived.
>>       SF_IMMUTABLE    This file is immutable.
>>       SF_APPEND       This file is append-only.
>>       SF_NOUNLINK     This file can't be removed or renamed.
>>       SF_HIDDEN       This file is a snapshot inode.
>>
>>    The SF_SETTABLE constant is the union of the above flags.
>>
>> (3) Linux-specific flags:
>>
>>       XSTAT_LF_MAGIC_FILE     Magic file, such as found in procfs and sysfs.
>>       XSTAT_LF_SYNC           File is written synchronously.
>>       XSTAT_LF_NOATIME        Atime is not updated on this file.
>>       XSTAT_LF_JOURNALLED_DATA Data modifications to this file are journalled.
>>       XSTAT_LF_ENCRYPTED      This file is encrypted.
>>       XSTAT_LF_SYSTEM         This file is a system file (FAT/NTFS/CIFS).
>>       XSTAT_LF_TEMPORARY      This file is a temporary file (NTFS/CIFS).
>>       XSTAT_LF_OFFLINE        file is currently unavailable (CIFS).
>
> Yuck on the names.  Why not stick with the "UF_" and "SF_" prefixes?
> Since we don't need to keep _binary_ compatibility with these flag values
> (only name portability) we can use the same flag values as the
> FS_*_FL definitions in fs.h.  That is what all of the existing filesystems
> already use (ext2/3/4, ocfs, btrfs, reiserfs, xfs, jfs).

Agree on the naming. Andreas expresses what I intended when I proposed the idea.

Cheers,

Michael


-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/

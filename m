Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366Ab1AHIUm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 03:20:42 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43805 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1AHIUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 03:20:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iwYRy3AMpaqgyewX0iRJXqdjkfT0umHfl+kdJjg3t7P/hTUWdtD4NkcAMr2dLw2Ll2
         2lW515hACH2d2FhiekP/a/NaLKfEP3vdkZljM6VtrHDopDF1FwUB0X+NnviYkjm+0U4L
         pFmCHrJIz4S35h6+FntV+/138P31n8eIncVWY=
Message-ID: <4D281D65.1070102@gmail.com>
Date: Sat, 08 Jan 2011 09:16:37 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 01/17] pramfs: documentation
References: <4D25AF02.60208@gmail.com>	<AANLkTimGt5hi+TpFHWxktJEg3tcDQmmARdqFqzAt++OQ@mail.gmail.com>	<4D2777FC.6040509@gmail.com> <AANLkTimtvYfHXG=rMLbFLzVaKbfB6nrj_ZE1AH4quRG2@mail.gmail.com>
In-Reply-To: <AANLkTimtvYfHXG=rMLbFLzVaKbfB6nrj_ZE1AH4quRG2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2011 22:59, Tony Luck wrote:
> On Fri, Jan 7, 2011 at 12:30 PM, Marco Stornelli
> <marco.stornelli@gmail.com> wrote:
>> constraint). About the errors: pramfs does not maintain file data in the
>> page caches for normal file I/O, so no writeback, the read/write
>> operation are done with direct io and they are always sync. The data are
>> write protected in hw when the arch provide this facility (x86 does).
>> Inode contains a checksum and when there are problems they are marked as
>> bad. Superblock contains checksum and there is a redundant superblock.
> 
> But you can still get pramfs inconsistencies if the system crashes at an
> inopportune moment. E.g. when making files you write the new inode to
> pramfs, and then you insert the entry into the directory. A crash between
> these two operations leaves an allocated inode that doesn't appear in
> any directory.  Without a fsck option, it will be hard to see that you have
> this problem, and your only recovery option is to wipe *all* files by making
> a new filesystem.

Is it a problem if you lost some logs? However do you expect that fsck
in this case will drop the inode?

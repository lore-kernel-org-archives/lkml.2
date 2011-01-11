Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab1AKPnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 10:43:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35794 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858Ab1AKPnS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 10:43:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=qUZZnaGFx0D+xgqdDvstldavRs2vJ3YVtGCFlWTmN4JFjSFyvWhLHqQEfvFToZ0hhM
         mEKoJNiEheaRjKqpGimR+J84uc4qLmcttGf4RCWSOJlmcJxOI6g/eqCcD0Sg4W45nvDF
         sMXkGlnUAdl7JdQxB49UAxfjRMPQ4ZyiMeIbU=
MIME-Version: 1.0
In-Reply-To: <4D281D65.1070102@gmail.com>
References: <4D25AF02.60208@gmail.com> <AANLkTimGt5hi+TpFHWxktJEg3tcDQmmARdqFqzAt++OQ@mail.gmail.com>
 <4D2777FC.6040509@gmail.com> <AANLkTimtvYfHXG=rMLbFLzVaKbfB6nrj_ZE1AH4quRG2@mail.gmail.com>
 <4D281D65.1070102@gmail.com>
From: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Date: Tue, 11 Jan 2011 16:42:57 +0100
Message-ID: <AANLkTi=fF_hskZ7kDEby0Uga0eaU_stM9qs890mUpxWd@mail.gmail.com>
Subject: Re: [PATCH 01/17] pramfs: documentation
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/8 Marco Stornelli <marco.stornelli@gmail.com>:
> On 07/01/2011 22:59, Tony Luck wrote:
>> On Fri, Jan 7, 2011 at 12:30 PM, Marco Stornelli
>> <marco.stornelli@gmail.com> wrote:
>>> constraint). About the errors: pramfs does not maintain file data in the
>>> page caches for normal file I/O, so no writeback, the read/write
>>> operation are done with direct io and they are always sync. The data are
>>> write protected in hw when the arch provide this facility (x86 does).
>>> Inode contains a checksum and when there are problems they are marked as
>>> bad. Superblock contains checksum and there is a redundant superblock.
>>
>> But you can still get pramfs inconsistencies if the system crashes at an
>> inopportune moment. E.g. when making files you write the new inode to
>> pramfs, and then you insert the entry into the directory. A crash between
>> these two operations leaves an allocated inode that doesn't appear in
>> any directory.  Without a fsck option, it will be hard to see that you have
>> this problem, and your only recovery option is to wipe *all* files by making
>> a new filesystem.
>
> Is it a problem if you lost some logs? However do you expect that fsck
> in this case will drop the inode?


IF there could be some inconsistencies in the file-system AND as long
as there is no way to fixup these inconsistencies than purging their
allocated space THEN I think the best approach would be clearing these
inconsistencies at the mount time and printing a WARNING message for
debug/stats purpose. Otherwise a user-space tool would be better
because it could be used in interactive mode, also.

Obviously the best would be to not have any inconsistencies at all.
However, in a real world, the thread-off between a journaling fs and a
simpler one in terms of code and memory usage could make acceptable
adopting a simpler fs than a journaled one. Kernel documentation
should inform clearly the user about pro/cons of adopting a simpler fs
especially about data loss conditions.

-RAF

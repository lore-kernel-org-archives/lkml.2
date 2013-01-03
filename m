Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab3ACIqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 03:46:23 -0500
Received: from mout.gmx.net ([212.227.15.19]:62811 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab3ACIqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 03:46:19 -0500
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX1+AvFcJzIuAlEYDA1s8g8ZPvL71aQBrNvvVYXXozu
	bcwVwmKoDzzZGw
Message-ID: <50E54557.8050902@fisher-privat.net>
Date: Thu, 03 Jan 2013 09:46:15 +0100
From: Oleksij Rempel <bug-track@fisher-privat.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] fat: mark fs as dirty on mount and clean on umount
References: <87pq1vza3y.fsf@devron.myhome.or.jp> <87han7za23.fsf@devron.myhome.or.jp> <20130102154422.53a84995.akpm@linux-foundation.org>
In-Reply-To: <20130102154422.53a84995.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.01.2013 00:44, schrieb Andrew Morton:
> On Fri, 28 Dec 2012 02:20:20 +0900
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:
>
>> There is no documented methods to mark FAT as dirty. Unofficially MS
>> started to use reserved Byte in boot sector for this purpose,
>> at least since Win 2000. With Win 7 user is warned if fs is dirty
>> and asked to clean it.
>> Different versions of Win, handle it in different ways,
>> but always have same meaning:
>> - Win 2000 and XP, set it on write operations and
>>    remove it after operation was finnished
>> - Win 7, set dirty flag on first write and remove it on umount.
>>
>> We will do it as fallow:
>> - set dirty flag on mount. If fs was initially dirty, warn user,
>>    remember it and do not do any changes to boot sector.
>> - clean it on umount. If fs was initially dirty, leave it dirty.
>> - do not do any thing if fs mounted read-only.
>> - TODO: leave fs dirty if we found some error after mount.
>
> The changelog doesn't describe why we're making this change.  Nor does
> it describe the user-visible effects of this change.
>
> AFAICT the effect is to issue a warning at mount-time to tell the
> user that the fs wasn't cleanly unmounted and that the user should fsck
> the volume, correct?
>
> If so, why is this considered a desirable feature?  (I can guess, but
> would prefer to hear it spelled out by the experts, please).
>

FAT is old and still intensively used file system with high number of 
data lost. This patch set is a try to reduce this numbers.
To make this work complete, we need some changes in user space too. But 
even stand alone, this patchset can warn M$ Windows 7 about probably 
damaged FS. In this case Win 7 will inform user and give option to start 
checkdisk.
-- 
Regards,
Oleksij

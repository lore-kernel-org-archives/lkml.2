Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab1G3NPe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 09:15:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41612 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab1G3NP2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 09:15:28 -0400
MIME-Version: 1.0
In-Reply-To: <4E33397F.4010908@draigBrady.com>
References: <CAPweEDzv+vByC1s2bWRjVQdVLqw4Xf2sUf_CQgVync_YcxtdvQ@mail.gmail.com>
	<20110725134533.GA23781@citd.de>
	<CAPweEDybuOpPVidJWg+rfs8rU8y=xo4d3H=P7XQJh_DiKrF4DQ@mail.gmail.com>
	<20110729195904.GC1720@ucw.cz>
	<20110729213156.GA32685@citd.de>
	<4E33397F.4010908@draigBrady.com>
Date: Sat, 30 Jul 2011 14:15:27 +0100
X-Google-Sender-Auth: zAKAgKz_fkxm8NDq6Ah-psQzxzU
Message-ID: <CAPweEDxPgjU1aWL0FPC-BsxKsFyiDyQHu2CAvwC8d9VtMUw1kw@mail.gmail.com>
Subject: Re: ext3 hacked filesystem (by debian exim4 exploit) available for
 analysis and bugreporting
From: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
To: =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigbrady.com>
Cc: Matthias Schniedermeyer <ms@citd.de>, Pavel Machek <pavel@ucw.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Coreutils <coreutils@gnu.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/29 Pádraig Brady <P@draigbrady.com>:
> On 07/29/2011 10:31 PM, Matthias Schniedermeyer wrote:
>> On 29.07.2011 21:59, Pavel Machek wrote:
>>> On Mon 2011-07-25 22:08:24, Luke Kenneth Casson Leighton wrote:
>>>> On Mon, Jul 25, 2011 at 2:45 PM, Matthias Schniedermeyer <ms@citd.de> wrote:
>>>>> On 25.07.2011 13:08, Luke Kenneth Casson Leighton wrote:
>>>>>> folks, hi,
>>>>>>
>>>>>> apart from anything, files which cannot be deleted (and cannot be
>>>>>> detected as "corrupted" by fsck.ext3) is pretty damn serious.
>>>>>
>>>>> You did try lsattr and checked that the files aren't 'immutable'?
>>>>
>>>>  i didn't! :)  didn't know about (but should have guessed) ext3
>>>> attributes.  they are indeed - thank you matthias.
>>>>
>>>> root@quietbaby:/mnt/horsebox/tmp3# lsattr *
>>>> ----ia------------- bin3/kill
>>>> ----ia------------- bin3/ps
>>>> ----ia------------- c.pl
>>>> ----ia------------- e.conf
>>>> ----ia------------- sbin3/sysctl
>>>> ----ia------------- usrbin3/uptime
>>>> ----ia------------- usrbin3/tload
>>>> ----ia------------- usrbin3/free
>>>> ----ia------------- usrbin3/top
>>>> ----ia------------- usrbin3/vmstat
>>>> ----ia------------- usrbin3/watch
>>>> ----ia------------- usrbin3/skill
>>>> ----ia------------- usrbin3/pmap
>>>> ----ia------------- usrbin3/pgrep
>>>> ----ia------------- usrbin3/slabtop
>>>> ----ia------------- usrbin3/pwdx
>>>> ----ia------------- usrbin3/snice
>>>> ----ia------------- usrbin3/pkill
>>>> ----ia------------- usrbin3/w
>>>>
>>>> so - looks like it's not as bad as i thought.
>>>
>>> Should ls -l be moddified to show something when file has immutable
>>> (and friends) set?
>>
>> AFAICT lsattr, in e2fsprogs, only does a 'stat'(lib/e2p/fgetflags.c) and
>> checks st_flags, which i can't see in the "man 2 stat"-man-page i have
>> installed, but nonetheless that is what it appears to do.
>>
>> So assuming there are no incompatibilites between filesystems, the
>> information appears to come "free" with the stat(s) that ls has to do
>> anyway. (In the sense that there doesn't appear to any excessive
>> overhead involved, especially no additional I/O).
>>
>> So i would say: definitly.
>
> `strace lsattr ...` shows it calls ioctl (...FS_IOC_GETFLAGS...)
> So there would be overhead.

$ strace -o log.txt ls -altr

 ...
 ...
 lstat(".", {st_mode=S_IFDIR|0755, st_size=12288, ...}) = 0
lgetxattr(".", "security.selinux", 0xeb5bf0, 255) = -1 ENODATA (No
data available)
getxattr(".", "system.posix_acl_access", 0x0, 0) = -1 EOPNOTSUPP
(Operation not supported)
 ...

so it looks like there already is overhead.

on the basis that "ls" is already looking for selinux extended
attributes, as well as.. oh - posix ACLs as well! - i'd say that
adding an extra call to check even the existence of anything that
lsattr does (not _what_ they are, just "are there any at all?") would
not be, relatively speaking, that much extra.

l.

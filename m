Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab1F2Kv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 06:51:59 -0400
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:3248 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753277Ab1F2Kv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 06:51:57 -0400
Message-ID: <4E0B03A5.7020207@draigBrady.com>
Date: Wed, 29 Jun 2011 11:51:17 +0100
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ulrich Drepper <drepper@akkadia.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        rientjes@google.com, viro@zeniv.linux.org.uk, wilsons@start.ca
Subject: Re: [PATCH] Add cloexec information to fdinfo
References: <201106100355.p5A3t8Aa024924@drepperk.user.openhosting.com> <BANLkTin7wm6m5bN4CfQzhJZuhy3bUrS80A@mail.gmail.com> <4E0ADF27.5070805@akkadia.org>
In-Reply-To: <4E0ADF27.5070805@akkadia.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/06/11 09:15, Ulrich Drepper wrote:
> On 06/28/2011 01:23 PM, Linus Torvalds wrote:
>> The description makes no mention of why this would be needed?
> 
> In this specific case I was trying to re-implement the pfiles program.
> For normal file descriptors (not sockets) this was the last piece of
> information which wasn't available.  This is all part of my "give
> Solaris users no reason to not switch" effort.  I intend to offer the
> code to the util-linux-ng maintainers.

For the curious (me):

solaris:~ > pfiles $$
8418:   -bash
  Current rlimit: 256 file descriptors
   0: S_IFCHR mode:0620 dev:349,28 ino:130202 uid:11003 gid:7 rdev:24,116
      O_RDWR|O_NOCTTY|O_LARGEFILE
      /dev/pts/116
   1: S_IFCHR mode:0620 dev:349,28 ino:130202 uid:11003 gid:7 rdev:24,116
      O_RDWR|O_NOCTTY|O_LARGEFILE
      /dev/pts/116
   2: S_IFCHR mode:0620 dev:349,28 ino:130202 uid:11003 gid:7 rdev:24,116
      O_RDWR|O_NOCTTY|O_LARGEFILE
      /dev/pts/116
   3: S_IFDOOR mode:0444 dev:347,0 ino:189 uid:0 gid:0 size:0
      O_RDONLY|O_LARGEFILE FD_CLOEXEC  door to nscd[11276]
      /var/run/name_service_door
 255: S_IFCHR mode:0620 dev:349,28 ino:130202 uid:11003 gid:7 rdev:24,116
      O_RDWR|O_NOCTTY|O_LARGEFILE FD_CLOEXEC
      /dev/pts/116

I guess `lsof +f g` could be suitably embellished as well.

cheers,
Pádraig.

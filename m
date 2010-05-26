Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934885Ab0EZXNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:13:48 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33869 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934489Ab0EZXNq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:13:46 -0400
MIME-Version: 1.0
In-Reply-To: <1274871005.5882.5315.camel@twins>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	<1274482015-30899-2-git-send-email-arve@android.com>
	<1274482015-30899-3-git-send-email-arve@android.com>
	<1274863428.5882.4860.camel@twins>
	<AANLkTimTnzK1ByG2bE2gGjINxD_Pbvez7PFHo7Kzo9yk@mail.gmail.com>
	<1274871005.5882.5315.camel@twins>
Date: Wed, 26 May 2010 16:13:45 -0700
Message-ID: <AANLkTilNUEhuPvCqh3lItwX3qBLyCghWRlep-aENwsiw@mail.gmail.com>
Subject: Re: [PATCH 2/8] PM: suspend_block: Add driver to access suspend 
	blockers from user-space
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Jim Collar <jim.collar@eqware.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Avi Kivity <avi@redhat.com>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Magnus Damm <damm@igel.co.jp>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Nigel Cunningham <nigel@tuxonice.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/26 Peter Zijlstra <peterz@infradead.org>:
> On Wed, 2010-05-26 at 03:47 -0700, Arve Hjønnevåg wrote:
>> 2010/5/26 Peter Zijlstra <peterz@infradead.org>:
>> > On Fri, 2010-05-21 at 15:46 -0700, Arve Hjønnevåg wrote:
>> >> +To create a suspend blocker from user space, open the suspend_blocker
>> >> special
>> >> +device file:
>> >> +
>> >> +    fd = open("/dev/suspend_blocker", O_RDWR | O_CLOEXEC);
>> >> +
>> >> +then optionally call:
>> >> +
>> >> +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_SET_NAME(strlen(name)), name);
>> >> +
>> >> +To activate the suspend blocker call:
>> >> +
>> >> +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_BLOCK);
>> >> +
>> >> +To deactivate it call:
>> >> +
>> >> +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_UNBLOCK);
>> >> +
>> >> +To destroy the suspend blocker, close the device:
>> >> +
>> >> +    close(fd);
>> >
>> > Urgh, please let the open() be BLOCK, the close() be UNBLOCK, and keep
>> > the SET_NAME thing if you really care.
>> >
>>
>> That would be very inefficient.
>
> How so? Anyway, since you admitted this thing isn't needed at all, I say
> we remove it altogether.
>

I also said it was useful. I don't think we should drop it just
because we can work around its absence.

-- 
Arve Hjønnevåg

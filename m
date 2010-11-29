Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab0K2TVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:21:36 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52075 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab0K2TVf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:21:35 -0500
MIME-Version: 1.0
In-Reply-To: <4CF3F996.4090703@zytor.com>
References: <20101116104600.GA24015@suse.de>
	<20101119191906.GA31760@xanatos>
	<AANLkTi=OsWEdrfCOHKz+SAtqo7DmK0nNxku7Ev21f0Lh@mail.gmail.com>
	<20101126074809.GD19589@elte.hu>
	<20101129163308.GA2383@xanatos>
	<20101129180429.GB14046@elte.hu>
	<4CF3F996.4090703@zytor.com>
Date: Mon, 29 Nov 2010 14:21:33 -0500
Message-ID: <AANLkTinQHidwuZLqjjdyxyT-UAVao4XngNsz3tFUPN8M@mail.gmail.com>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of attacking
From: Eric Paris <eparis@parisplace.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Marcus Meissner <meissner@suse.de>, linux-kernel@vger.kernel.org,
        tj@kernel.org, akpm@linux-foundation.org, w@1wt.eu,
        alan@lxorguk.ukuu.org.uk, serue@us.ibm.com,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 2:05 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 11/29/2010 10:04 AM, Ingo Molnar wrote:
>>
>> * Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:
>>
>>> On Fri, Nov 26, 2010 at 08:48:09AM +0100, Ingo Molnar wrote:

>>>> Sarah,
>>>>
>>>> Does your system boot fine if we make /proc/kallsyms simply an empty file to
>>>> unprivileged users? Something like the (untested ...) patch below.
>>>
>>> Yes, that works.  The system boots as normal. `cat /proc/kallsyms`
>>> returns an empty file, and `sudo cat /proc/kallsyms` does not.
>>
>> Great! Marcus, mind respinning your patch with that approach?
>>
>
> Can we please not use CAP_SYS_ADMIN for this?  Relying on CAP_SYS_ADMIN
> is worse than anything else -- it is a fixed policy hardcoded in the
> kernel, with no ability for the system owner to delegate the policy
> outward, e.g. by adding group read permission and/or chgrp the file.
>
> Delegating CAP_SYS_ADMIN, of course, otherwise known as "everything", is
> worse than anything...

Serge just proposed a new CAP_SYSLOG

http://lwn.net/Articles/378472/

Which could probably still be renamed and used to cover this access as well....

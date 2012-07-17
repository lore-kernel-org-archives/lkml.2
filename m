Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab2GQNy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:54:57 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48846 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab2GQNyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:54:53 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20120717134613.GA30892@mail.hallyn.com>
References: <5004EBF9.3040406@gmail.com> <20120717134613.GA30892@mail.hallyn.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Tue, 17 Jul 2012 15:54:31 +0200
Message-ID: <CAKgNAkh=LpuQDYWJ1XZpLMv+oFNqUD2Y+ZAxKOyB08-1OkJ55A@mail.gmail.com>
Subject: Re: [patch] Rename CAP_EPOLLWAKEUP to CAL_BLOCK_SUSPEND
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mtk@lwn.net,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 3:46 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Michael Kerrisk (mtk.manpages@gmail.com):
>> Rafael,
>>
>> As discussed in
>> http://thread.gmane.org/gmane.linux.kernel/1249726/focus=1288990,
>> the capability introduced in 4d7e30d98939a0340022ccd49325a3d70f7e0238
>> to govern EPOLLWAKEUP seems misnamed: this capability is about governing
>> the ability to suspend the system, not using a particular API flag
>> (EPOLLWAKEUP). We should make the name of the capability more general
>> to encourage reuse in related cases. (Whether or not this capability
>> should also be used to govern the use of /sys/power/wake_lock is a
>> question that needs to be separately resolved.)
>>
>> This patch renames the capability to CAP_BLOCK_SUSPEND. In order to ensure
>> that the old capability name doesn't make it out into the wild, could you
>> please apply and push up the tree to ensure that it is incorporated
>> for the 3.5 release.
>>
>> Thanks,
>>
>> Michael
>>
>> Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
>
> I definately like that name better, thanks.  Don't know if renaming it
> without an alias could cause trouble for some bleeding edge userspaces?
> Would it be worth keeping the
>
> #define CAP_EPOLLWAKEUP      36
>
> line?  If this is deemed early enough I do prefer not to complicate with
> a duplicate name.

Maybe I'm too ignorant. Are there userspaces that bleed with the -rc
series? I'd have thought this renaming would be a fairly safe change
at this point.

> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/

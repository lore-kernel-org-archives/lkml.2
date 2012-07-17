Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab2GQFPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 01:15:13 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47916 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab2GQFPK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 01:15:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAMP5XgfF3RF1hSonS_QrC8jQZyCcNfwGYZcCxnew02Rp3-CXKA@mail.gmail.com>
References: <CAMP5XgcatAchOXaEG0rbULes5pVHHsuGeuJ2CKaVGEdj1LzMDg@mail.gmail.com>
 <1335850428-30883-1-git-send-email-arve@android.com> <CAHO5Pa39ZYBBqscGhtOrciB1wz-mDtGdKhM1q5bKtpKPz4Ba_g@mail.gmail.com>
 <201207161300.16282.rjw@sisk.pl> <CAMP5XgfF3RF1hSonS_QrC8jQZyCcNfwGYZcCxnew02Rp3-CXKA@mail.gmail.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Tue, 17 Jul 2012 07:14:44 +0200
X-Google-Sender-Auth: bZKcQkRoR8rV8QxwXl0byn-nqdg
Message-ID: <CAHO5Pa3nWvmWY9jFZ-4ayvjGAV-4Vhs5sS18dbzniJp8wZYmoQ@mail.gmail.com>
Subject: Re: [PATCH] epoll: Add a flag, EPOLLWAKEUP, to prevent suspend while
 epoll events are ready
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, NeilBrown <neilb@suse.de>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mtk@lwn.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 12:04 AM, Arve Hjønnevåg <arve@android.com> wrote:
> On Mon, Jul 16, 2012 at 4:00 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Monday, July 16, 2012, Michael Kerrisk wrote:
>>> Arve, Rafael,
>>>
>>> On Tue, May 1, 2012 at 7:33 AM, Arve Hjønnevåg <arve@android.com> wrote:
>>> > When an epoll_event, that has the EPOLLWAKEUP flag set, is ready, a
>>> > wakeup_source will be active to prevent suspend. This can be used to
>>> > handle wakeup events from a driver that support poll, e.g. input, if
>>> > that driver wakes up the waitqueue passed to epoll before allowing
>>> > suspend.
>>>
>>> It's late it the -rc series,
>>
>> Well, exactly. :-)

If someone had CCed linux-api@ along the way (as per
Documentation/SubmitChecklist), it might have helped ;-)

>>
>>> but it strikes me that CAP_EPOLLWAKEUP is
>>> a poor name for the capability that governs the use of EPOLLWAKEUP.
>>> While on the one hand some capabilities are overloaded
>>> (https://lwn.net/Articles/486306/), on the other hand we should avoid
>>> adding individual capabilities for each new API feature (otherwise
>>> capabilities become administratively unwieldy).
>>>
>>> This capability is not really about "EPOLL". It's about the ability to
>>> block system suspend. Therefore, IMO, a better name would be something
>>> like: CAP_BLOCK_SUSPEND. This name is better because there might be
>>> some other API feature that is later added that also has the effect of
>>> preventing system suspends, and we could reasonably govern that
>>> feature with the same capability.
>
> We already have another api, "/sys/power/wake_lock", that allow
> user-space to block suspend. Do we want to apply this capability that
> api as well, or only to apis that do not have other ways to restrict
> access?

Well, the question is: is there a governor on the use of
/sys/power/wake_lock? It makes sense either they are both governed
(preferably by the same mechanism, I would have thought), or neither
is.

>>> Does that seem sensible to you? I can send a patch for the name change.
>>
>> I'm not sure what Arve thinks about that, but I'd be fine with that.
>>
>> Arve, what do you think?
>>
>
> CAP_BLOCK_SUSPEND is fine with me, but if it does not apply to the
> sysfs interface, then the comment should probably mention this.

I've sent a patch, but omitted mention of API details in the comments.
Maybe that can be changed afterward, when a decision has been reached
about governing /sys/power/wake_lock.

Thanks,

Michael

-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/

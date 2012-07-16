Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab2GPWEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 18:04:31 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40110 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab2GPWE3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 18:04:29 -0400
MIME-Version: 1.0
In-Reply-To: <201207161300.16282.rjw@sisk.pl>
References: <CAMP5XgcatAchOXaEG0rbULes5pVHHsuGeuJ2CKaVGEdj1LzMDg@mail.gmail.com>
	<1335850428-30883-1-git-send-email-arve@android.com>
	<CAHO5Pa39ZYBBqscGhtOrciB1wz-mDtGdKhM1q5bKtpKPz4Ba_g@mail.gmail.com>
	<201207161300.16282.rjw@sisk.pl>
Date: Mon, 16 Jul 2012 15:04:27 -0700
Message-ID: <CAMP5XgfF3RF1hSonS_QrC8jQZyCcNfwGYZcCxnew02Rp3-CXKA@mail.gmail.com>
Subject: Re: [PATCH] epoll: Add a flag, EPOLLWAKEUP, to prevent suspend while
 epoll events are ready
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, NeilBrown <neilb@suse.de>,
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

On Mon, Jul 16, 2012 at 4:00 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, July 16, 2012, Michael Kerrisk wrote:
>> Arve, Rafael,
>>
>> On Tue, May 1, 2012 at 7:33 AM, Arve Hjønnevåg <arve@android.com> wrote:
>> > When an epoll_event, that has the EPOLLWAKEUP flag set, is ready, a
>> > wakeup_source will be active to prevent suspend. This can be used to
>> > handle wakeup events from a driver that support poll, e.g. input, if
>> > that driver wakes up the waitqueue passed to epoll before allowing
>> > suspend.
>>
>> It's late it the -rc series,
>
> Well, exactly. :-)
>
>> but it strikes me that CAP_EPOLLWAKEUP is
>> a poor name for the capability that governs the use of EPOLLWAKEUP.
>> While on the one hand some capabilities are overloaded
>> (https://lwn.net/Articles/486306/), on the other hand we should avoid
>> adding individual capabilities for each new API feature (otherwise
>> capabilities become administratively unwieldy).
>>
>> This capability is not really about "EPOLL". It's about the ability to
>> block system suspend. Therefore, IMO, a better name would be something
>> like: CAP_BLOCK_SUSPEND. This name is better because there might be
>> some other API feature that is later added that also has the effect of
>> preventing system suspends, and we could reasonably govern that
>> feature with the same capability.

We already have another api, "/sys/power/wake_lock", that allow
user-space to block suspend. Do we want to apply this capability that
api as well, or only to apis that do not have other ways to restrict
access?

>>
>> Does that seem sensible to you? I can send a patch for the name change.
>
> I'm not sure what Arve thinks about that, but I'd be fine with that.
>
> Arve, what do you think?
>

CAP_BLOCK_SUSPEND is fine with me, but if it does not apply to the
sysfs interface, then the comment should probably mention this.

-- 
Arve Hjønnevåg

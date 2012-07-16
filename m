Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab2GPKyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 06:54:39 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42202 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab2GPKyh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 06:54:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Kerrisk <mtk.manpages@gmail.com>,
        Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH] epoll: Add a flag, EPOLLWAKEUP, to prevent suspend while epoll events are ready
Date: Mon, 16 Jul 2012 13:00:15 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: NeilBrown <neilb@suse.de>, Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mtk@lwn.net
References: <CAMP5XgcatAchOXaEG0rbULes5pVHHsuGeuJ2CKaVGEdj1LzMDg@mail.gmail.com> <1335850428-30883-1-git-send-email-arve@android.com> <CAHO5Pa39ZYBBqscGhtOrciB1wz-mDtGdKhM1q5bKtpKPz4Ba_g@mail.gmail.com>
In-Reply-To: <CAHO5Pa39ZYBBqscGhtOrciB1wz-mDtGdKhM1q5bKtpKPz4Ba_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201207161300.16282.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 16, 2012, Michael Kerrisk wrote:
> Arve, Rafael,
> 
> On Tue, May 1, 2012 at 7:33 AM, Arve Hjønnevåg <arve@android.com> wrote:
> > When an epoll_event, that has the EPOLLWAKEUP flag set, is ready, a
> > wakeup_source will be active to prevent suspend. This can be used to
> > handle wakeup events from a driver that support poll, e.g. input, if
> > that driver wakes up the waitqueue passed to epoll before allowing
> > suspend.
> 
> It's late it the -rc series,

Well, exactly. :-)

> but it strikes me that CAP_EPOLLWAKEUP is
> a poor name for the capability that governs the use of EPOLLWAKEUP.
> While on the one hand some capabilities are overloaded
> (https://lwn.net/Articles/486306/), on the other hand we should avoid
> adding individual capabilities for each new API feature (otherwise
> capabilities become administratively unwieldy).
> 
> This capability is not really about "EPOLL". It's about the ability to
> block system suspend. Therefore, IMO, a better name would be something
> like: CAP_BLOCK_SUSPEND. This name is better because there might be
> some other API feature that is later added that also has the effect of
> preventing system suspends, and we could reasonably govern that
> feature with the same capability.
> 
> Does that seem sensible to you? I can send a patch for the name change.

I'm not sure what Arve thinks about that, but I'd be fine with that.

Arve, what do you think?

Rafael

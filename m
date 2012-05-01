Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab2EANrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 09:47:04 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:47481 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757665Ab2EANqs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 09:46:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] epoll: Add a flag, EPOLLWAKEUP, to prevent suspend while epoll events are ready
Date: Tue, 1 May 2012 15:51:33 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
References: <CAMP5XgcatAchOXaEG0rbULes5pVHHsuGeuJ2CKaVGEdj1LzMDg@mail.gmail.com> <1335850428-30883-1-git-send-email-arve@android.com> <20120501162811.26261d1d@notabene.brown>
In-Reply-To: <20120501162811.26261d1d@notabene.brown>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201205011551.33699.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 01, 2012, NeilBrown wrote:
> On Mon, 30 Apr 2012 22:33:48 -0700 Arve Hjønnevåg <arve@android.com> wrote:
> 
> > When an epoll_event, that has the EPOLLWAKEUP flag set, is ready, a
> > wakeup_source will be active to prevent suspend. This can be used to
> > handle wakeup events from a driver that support poll, e.g. input, if
> > that driver wakes up the waitqueue passed to epoll before allowing
> > suspend.
> > 
> > Signed-off-by: Arve Hjønnevåg <arve@android.com>
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Thanks.
>  Reviewed-by: NeilBrown <neilb@suse.de>

Thanks a lot for your involvement here!

> However:
> 1/ I think all references to "automatic system suspend" can be replaced with
>    "system suspend" as an active wakeup_source disables any suspend, no matter
>    it's source

OK, I'll change that when applying the patch (although that only applies to
suspends taking the wakeup events signaling through wakeup sources into
account).

> 2/ I reserve to right to submit for discussion a later patch which removes
>    the ep->ws in favour or some other exclusion mechanism :-)

Well, you can alwyas do that. :-)  Of course, when the patch goes to Linus,
we'll have to be careful about changes visible to user space, though.

Thanks,
Rafael

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab0IBVH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:07:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43954 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757412Ab0IBVHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:07:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Colin Cross <ccross@android.com>
Subject: Re: [PATCH] PM: Prevent waiting forever on asynchronous resume after abort
Date: Thu, 2 Sep 2010 23:06:43 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <AANLkTi=s3_kFvRY9Afzku82gUgW7YKYXDBZvTkxQsMP8@mail.gmail.com> <Pine.LNX.4.44L0.1009021642320.1311-100000@iolanthe.rowland.org> <AANLkTim7UM80MrwKoAz3hUFrqL2Fbyw6XS=X89PXRc2Q@mail.gmail.com>
In-Reply-To: <AANLkTim7UM80MrwKoAz3hUFrqL2Fbyw6XS=X89PXRc2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009022306.43470.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 02, 2010, Colin Cross wrote:
> On Thu, Sep 2, 2010 at 1:45 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Thu, 2 Sep 2010, Colin Cross wrote:
> >
> >> >> I think it would be better to change device_pm_init() and add a
> >> >> complete_all().
> >> >
> >> > I agree.
> >> That would work, and was my first solution, but it increases the
> >> reliance on the completion variable being left completed between state
> >> transitions, which is undocumented and unnecessary.  It seems more
> >> straightforward to me to only wait on the parent if the parent is
> >> suspended.
> >
> > How about calling complete_all() from within dpm_prepare() as well?
> > Then it will get initialized properly at the beginning of every sleep
> > transition.
> That would work, but I still don't see why it's better.  With either
> of your changes, the power.completion variable is storing state, and
> not just used for notification.  However, the exact meaning of that
> state is unclear, especially during the transition from an aborted
> suspend to resume, and the state is duplicating power.status.  Setting
> it to complete in dpm_prepare is especially confusing, because at that
> point nothing is completed, it hasn't even been started.

It just sets the initial value.  But I agree it would be cleaner to do that
during the initialization.

Thanks,
Rafael

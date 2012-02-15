Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab2BOWda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 17:33:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54495 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab2BOWd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 17:33:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [RFC][PATCH 5/8] PM / Sleep: Change wakeup statistics
Date: Wed, 15 Feb 2012 23:37:21 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <greg@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201202070200.55505.rjw@sisk.pl> <201202070205.07589.rjw@sisk.pl> <CAMP5XgdPmyOp4ECoS3t7NUvQz+cWbq9eMRQSSQn3073w2P4t5w@mail.gmail.com>
In-Reply-To: <CAMP5XgdPmyOp4ECoS3t7NUvQz+cWbq9eMRQSSQn3073w2P4t5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202152337.22072.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 15, 2012, Arve Hjønnevåg wrote:
> On Mon, Feb 6, 2012 at 5:05 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Wakeup statistics used by Android are slightly different from what we
> > have at the moment, so modify them to follow Android more closely.
> ...
> > @@ -438,6 +444,11 @@ static void wakeup_source_deactivate(str
> >        if (ktime_to_ns(duration) > ktime_to_ns(ws->max_time))
> >                ws->max_time = duration;
> >
> > +       ws->last_time = now;
> > +       if (ws->has_timeout && time_after(jiffies, ws->timer_expires))
> 
> time_after_eq may work better (or increment the count from the timer).

I think incrementing the count from the timer is a better approach.

> I applied this patch and the expire counts I see for wakeup-sources
> that always time-out do not match the active count.

I see.  The reason may also be that __pm_wakeup_event() increments
ws->event_count even if the wakeup source is already active.

Thanks,
Rafael

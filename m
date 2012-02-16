Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab2BPWFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 17:05:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56610 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab2BPWFV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 17:05:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH 3/3] PM / Sleep: Make __pm_stay_awake() delete wakeup source timers
Date: Thu, 16 Feb 2012 23:09:15 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <201202152318.04206.rjw@sisk.pl> <201202152324.08073.rjw@sisk.pl> <CAMP5XgenQF11AUSkn2iWT679bWHe8XeQ1mbrKcSzbDNQLctp5w@mail.gmail.com>
In-Reply-To: <CAMP5XgenQF11AUSkn2iWT679bWHe8XeQ1mbrKcSzbDNQLctp5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202162309.15367.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 16, 2012, Arve Hjønnevåg wrote:
> 2012/2/15 Rafael J. Wysocki <rjw@sisk.pl>:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > If __pm_stay_awake() is called after __pm_wakeup_event() for the same
> > wakep source object before its timer expires, it won't cancel the
> > timer, so the wakeup source will be deactivated from the timer
> > function as scheduled by __pm_wakeup_event().  In that case
> > __pm_stay_awake() doesn't have any effect beyond incrementing
> > the wakeup source's event_count field, although it should cancel
> > the timer and make the wakeup source stay active until __pm_relax()
> > is called for it.
> >
> > Conversely, if __pm_wakeup_event() is called for a wakeup source
> > that has been activated by __pm_stay_awake() before, it will set up
> > the timer to deactivate the wakeup source, although it should leave
> > it active until __pm_relax() is called for it.
> 
> We have many drivers that call wake_lock_timeout instead of
> wake_unlock to cancel a previous wake_lock call. These drivers will
> need to use two wakeup sources if __pm_wakeup_event does not always
> set the timeout. I think it is better to have the state of the wakeup
> source only depend on the last function you called, instead of that
> last function being a noop in some cases.

OK

Rafael

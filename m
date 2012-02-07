Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab2BGWhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 17:37:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41841 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090Ab2BGWhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 17:37:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 1/8] PM / Sleep: Initialize wakeup source locks in wakeup_source_add()
Date: Tue, 7 Feb 2012 23:41:38 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201202070200.55505.rjw@sisk.pl> <201202070201.58025.rjw@sisk.pl> <1328653791.18150.5.camel@js-netbook>
In-Reply-To: <1328653791.18150.5.camel@js-netbook>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202072341.38936.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 07, 2012, John Stultz wrote:
> On Tue, 2012-02-07 at 02:01 +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Initialize wakeup source locks in wakeup_source_add() instead of
> > wakeup_source_create(), because otherwise the locks of the wakeup
> > sources that haven't been allocated with wakeup_source_create()
> > aren't initialized and handled properly.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Ah, I've shot myself in the foot before, forgetting to init the wakeup
> source, so this should be good. Although, would a WARN_ON be better then
> just initializing the lock in add? That way bad behavior is more likely
> to be corrected, rather then just ignored.

Well, that's not bad behavior, since users are not supposed to open code
wakeup source initialization.  _add() is supposed to do the job (that's
why I regard this one as a fix).

Thanks,
Rafael

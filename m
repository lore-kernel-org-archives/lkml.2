Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab1EPXVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 19:21:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57358 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab1EPXVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 19:21:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@tuxonice.net
Subject: Re: [RFC][PATCH] PM / Hibernate: Add sysfs knob to control size of memory for drivers
Date: Tue, 17 May 2011 01:22:04 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <201105100059.25372.rjw@sisk.pl> <201105151136.22169.rjw@sisk.pl> <4DD19879.5020606@tuxonice.net>
In-Reply-To: <4DD19879.5020606@tuxonice.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201105170122.04402.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 16, 2011, Nigel Cunningham wrote:
> Hi.
> 
> On 15/05/11 19:36, Rafael J. Wysocki wrote:
> > In fact, if drivers allocated their memory from suspend/hibernate notifiers,
> > that would be practically equivalent to setting reserved_size to the total
> > amount of memory reserved by the drivers.  However, it may be difficult
> > for drivers to predict how much memory they will need at the time the
> > notifiers are called (they are called before freezing user space).
> > 
> > Thus I'm considering a change that will cause device drivers' ->prepare()
> > callbacks to be executed before the preallocation of memory takes place.
> > In that case the drivers may allocate memory from their ->prepare()
> > callbacks _after_ user space has been frozen and that will make more
> > sense overall.
> > 
> > For now, however, I think that exposing reserved_size is the right choice.
> 
> Sorry for not commenting earlier - too busy with Drupal development and
> only came across this thread by chance (yes, I'm still subscribed to the
> PM list, but haven't been reading it. Hibernation isn't high on my list
> of priorities at the moment because TOI is feature complete and stable.
> I know I'm supposed to be sending you patches, but other things have
> been taking the time that would be used for that).
> 
> Anyway...
> 
> This sounds to me like a great development. As far as TuxOnIce goes,
> we've had a knob for ages that has allowed the user to specify an amount
> of memory to be kept aside for driver allocations, and we calculate and
> report how much they used in the debugging info sysfs entry. Because
> TuxOnIce works differently to [u]swsusp, this is the only source of
> potential out-of-memory related failures, and the measures just
> mentioned made things much more reliable.
> 
> If things went in the direction you're suggesting here, they'd get
> better again. I'm all in favour!

Thanks Nigel!

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab1EQXGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 19:06:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33496 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932562Ab1EQXGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 19:06:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Raffaele Recalcati <lamiaposta71@gmail.com>
Subject: Re: [linux-pm] pm loss development
Date: Wed, 18 May 2011 01:06:56 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>, linux-pm@lists.linux-foundation.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com> <201105142053.34920.oliver@neukum.org> <BANLkTikEJoV1JHMDZODvv40-8-jmvYMbgg@mail.gmail.com>
In-Reply-To: <BANLkTikEJoV1JHMDZODvv40-8-jmvYMbgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105180106.57147.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 14, 2011, Raffaele Recalcati wrote:
> On Sat, May 14, 2011 at 8:53 PM, Oliver Neukum <oliver@neukum.org> wrote:
> > Am Donnerstag, 12. Mai 2011, 21:27:44 schrieb Rafael J. Wysocki:
> >> On Thursday, May 12, 2011, Raffaele Recalcati wrote:
> >> > What happen normally in runtime pm implementation is that every devices
> >> > are switched off and are enabled only when needed.
> >> > In our case instead we have a completely functional embedded system and,
> >> > when an asyncrhonous event appear, we have only some tens milliseconds
> >> > before the actual power failure takes place.
> >> > This patchset add a support in order to switch off not vital part of the system,
> >> > in order to allow the board to survive longer.
> >> > This allow the possibility to save important data.
> >>
> >> OK, so first, who decides what parts of the system are vital and what aren't?
> >
> > If you know that power is failing in a few miliseconds, only stuff that can lead to data
> > corruption is vital. In that timeframe you can't even flush buffers.
> 
> Remember that if you switch off some peripherals this timeframe
> becomes longer, so maybe you have enough time to sync some storage
> devices.

However, switching off peripherals _also_ takes time.  So, it may be more
useful to take care of the stuff leading to data corruption along with the
switching off peripherals.

Thanks,
Rafael

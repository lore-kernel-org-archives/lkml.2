Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683Ab1ENQfV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 12:35:21 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57283 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758482Ab1ENQfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 12:35:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=b90J1V9mUkcFgY0EZlWGsqPa2sWDvJP5ambF3ygGROG8Yl9QCmhwf9LVIBR99MJFf1
         VUE57shJbSMTqya4oNRKWuwbC8SbJEGpg9rsuSAo0LiuoDaErwV64TlA7AvDFbAEJl0V
         K6k469nQZbOIjrtrTdTQtkiyvX0DBNqtij15Q=
Date: Sat, 14 May 2011 09:35:13 -0700
From: mark gross <markgross@thegnar.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Raffaele Recalcati <lamiaposta71@gmail.com>,
        linux-pm@lists.linux-foundation.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] pm loss development
Message-ID: <20110514163513.GB8292@gvim.org>
Reply-To: markgross@thegnar.org
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com>
 <201105122127.44484.rjw@sisk.pl>
 <BANLkTikZkRW6TWMcWyZC4_TdAWgjXDqvYA@mail.gmail.com>
 <201105131854.57854.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105131854.57854.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 06:54:57PM +0200, Rafael J. Wysocki wrote:
> On Friday, May 13, 2011, Raffaele Recalcati wrote:
> > Hi Rafael,
> > 
> > 2011/5/12 Rafael J. Wysocki <rjw@sisk.pl>:
> > > On Thursday, May 12, 2011, Raffaele Recalcati wrote:
> > >> What happen normally in runtime pm implementation is that every devices
> > >> are switched off and are enabled only when needed.
> > >> In our case instead we have a completely functional embedded system and,
> > >> when an asyncrhonous event appear, we have only some tens milliseconds
> > >> before the actual power failure takes place.
> > >> This patchset add a support in order to switch off not vital part of the system,
> > >> in order to allow the board to survive longer.
> > >> This allow the possibility to save important data.
> > >
> > > OK, so first, who decides what parts of the system are vital and what aren't?
> > 
> > Take a quick look at Documentation/power/loss.txt  paragrpah "2.4
> > Power loss policies".
> > You can decide what can be powered off.
> 
> I read the patches.  My question was about the general idea of who should
> be responsible of making these decisions.

I would expect the system integrator would based on the application the
device is getting deployed into.

A generic opportunistic policy for peripherals that are stateless and can
be trivially power gated off/on from an ISR could be a default but, for
peripherals that need to do some processing (like waiting on an eMMC DMA
to complete) can take time to power down into a safe state.

--mark

> 
> Thanks,
> Rafael
> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/linux-pm

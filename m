Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960Ab1ESMpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 08:45:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62402 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595Ab1ESMpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 08:45:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=kM6jopyxfRwznC1sktFvLcdJ59NJUopsCUpHml2HVDG6qXCGAR+4Jzy/5Aduycm4kz
         icIa//0pFO/5WBtKP0UYZXFt13ZrLUHxPmm9YvjPyfmvGbrTdkP7F2jM/f9ivfAVYFsQ
         iffCWZrWBJGAl8qzu/LPjiB1H2oDu8gB2VRac=
Date: Thu, 19 May 2011 05:45:39 -0700
From: mark gross <markgross@thegnar.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: markgross@thegnar.org, Raffaele Recalcati <lamiaposta71@gmail.com>,
        linux-pm@lists.linux-foundation.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] pm loss development
Message-ID: <20110519124539.GA10262@gvim.org>
Reply-To: markgross@thegnar.org
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com>
 <201105180107.58078.rjw@sisk.pl>
 <20110518031203.GA3640@gvim.org>
 <201105182143.13237.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105182143.13237.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 09:43:13PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, May 18, 2011, mark gross wrote:
> > On Wed, May 18, 2011 at 01:07:57AM +0200, Rafael J. Wysocki wrote:
> > > On Saturday, May 14, 2011, mark gross wrote:
> > > > On Fri, May 13, 2011 at 06:54:57PM +0200, Rafael J. Wysocki wrote:
> > > > > On Friday, May 13, 2011, Raffaele Recalcati wrote:
> > > > > > Hi Rafael,
> > > > > > 
> > > > > > 2011/5/12 Rafael J. Wysocki <rjw@sisk.pl>:
> > > > > > > On Thursday, May 12, 2011, Raffaele Recalcati wrote:
> > > > > > >> What happen normally in runtime pm implementation is that every devices
> > > > > > >> are switched off and are enabled only when needed.
> > > > > > >> In our case instead we have a completely functional embedded system and,
> > > > > > >> when an asyncrhonous event appear, we have only some tens milliseconds
> > > > > > >> before the actual power failure takes place.
> > > > > > >> This patchset add a support in order to switch off not vital part of the system,
> > > > > > >> in order to allow the board to survive longer.
> > > > > > >> This allow the possibility to save important data.
> > > > > > >
> > > > > > > OK, so first, who decides what parts of the system are vital and what aren't?
> > > > > > 
> > > > > > Take a quick look at Documentation/power/loss.txt  paragrpah "2.4
> > > > > > Power loss policies".
> > > > > > You can decide what can be powered off.
> > > > > 
> > > > > I read the patches.  My question was about the general idea of who should
> > > > > be responsible of making these decisions.
> > > > 
> > > > I would expect the system integrator would based on the application the
> > > > device is getting deployed into.
> > > > 
> > > > A generic opportunistic policy for peripherals that are stateless and can
> > > > be trivially power gated off/on from an ISR could be a default but, for
> > > > peripherals that need to do some processing (like waiting on an eMMC DMA
> > > > to complete) can take time to power down into a safe state.
> > > 
> > > What do you mean by safe state?
> > >
> > I need to get more details on this but I assume its a state where the
> > meta data of the file system is committed to the emmc before lights go
> > off such that when power is reapplied that the damage isn't too big. 
> 
> I don't think you can guarantee that the metadata won't be damaged
> without notifying the filesystem of the event (and making it react
> appropriately).
> 
true.  I'm just brain storming what infrastructure would be needed to
support such a feature.

> > I've also heard some talk of sim card corruption risks but, I don't have
> > first hand info on that.
> 
> Well, I guess that might be prevented by the driver alone.
Only the radio has a direct interface to the sim.  (pretty sure anyway)
so this would transfer into some AT commands pushed to the modem.

--mark

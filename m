Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab0ETHMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 03:12:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53696 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab0ETHME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 03:12:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m5+DuXHzmBln2Fr8PwermSF+0LkLhLX8bO+WOTFXGLLCsfj4OP/DG/4nGdAZrYRtbD
         JB7r9Gk/rzLU4mkjRXSYgZT0yuCn5gh7RLsUhp3IrS4wND/4nc0R9xULW+k8UPzWWkZC
         1EzN1GU+IpYUqe/AtSvRsL7IM9k2Dt1gnDxrk=
Date: Thu, 20 May 2010 00:11:58 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Hutterer <peter.hutterer@who-t.net>
Cc: Henrik Rydberg <rydberg@euromail.se>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev2)
Message-ID: <20100520071158.GC8080@core.coreip.homeip.net>
References: <1274213429-22667-1-git-send-email-rydberg@euromail.se>
 <1274213429-22667-2-git-send-email-rydberg@euromail.se>
 <20100519023727.GA21030@barra.bne.redhat.com>
 <4BF3D59E.1070801@euromail.se>
 <20100520001323.GA28116@barra.bne.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100520001323.GA28116@barra.bne.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 10:13:24AM +1000, Peter Hutterer wrote:
> On Wed, May 19, 2010 at 02:12:14PM +0200, Henrik Rydberg wrote:
> > Peter Hutterer wrote:
> > > On Tue, May 18, 2010 at 10:10:29PM +0200, Henrik Rydberg wrote:
> > >> This patch adds documentation for the SYN_MT_SLOT event and gives
> > >> examples of how to use the event slot protocol.
> > > 
> > > thanks, this is really nice documentation! the approach seems good, though I
> > > do have a few questions inline.
> > > 
> > [...]
> > > 
> > > Is there a limit on the number of slots?
> > 
> > The slots are dynamically allocated by the driver, so there is no practical
> > limit. Each slot currently takes 44 bytes, and allocating a few kilobytes of
> > kernel memory is not a problem.
> > 
> > > Will all drivers with ABS_MT_TRACKING_ID use slots? if not, how can I know
> > > in advance if a device may use slots or not?
> > 
> > Eventually, this might become true, but you are pointing at one of the weaker
> > points of the current setup. There is no bit field for the EV_SYN events, so
> > there is no way to know in advance if SYN_MT_SYNC or SYN_MT_SLOT is used. This
> > could quite possibly be added to the EVIO interface. Meanwhile, the method I use
> > is to detect the first SYN_MT_SLOT and select parser based on that information.
> 
> I'd really prefer if there was some way to detect this. While I'm not quite
> sure how the matching X drivers would look like it's likely that the setups
> will be different for drivers that support slots and those that don't.
> e.g. those that don't have slots simply send events as valuators, those that
> do may split into multiple devices.
> 
> Doing this at runtime - after the device has been set up is...tricky.
> 

Right, I think we should try our hardest to allow userspace base
protocol decoding decisions on device capabilities and not the event
datastream. What about moving from SYN_MT_SLOT to ABS_MT_SLOT? I think
it makes more sense since it is not a simple marker but carries data
(slot number).

-- 
Dmitry

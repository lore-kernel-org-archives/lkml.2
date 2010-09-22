Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab0IVQHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 12:07:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213Ab0IVQHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 12:07:15 -0400
Date: Wed, 22 Sep 2010 12:07:05 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/6] x86, NMI, Add symbol definition for NMI magic constants
Message-ID: <20100922160705.GK26290@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
 <20100921214847.GF26290@redhat.com>
 <b151e9f1ec3a162781b380e026f90711.squirrel@www.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b151e9f1ec3a162781b380e026f90711.squirrel@www.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 12:19:16AM +0200, Andi Kleen wrote:
> 
> >
> > I guess adding either another knob to override the hardware error option
> > or tying it in with the panic_on_unknown_error option might make me more
> > comfortable.  That way enterprise customers can always just enable it by
> > default and desktop users (for now) could have it off.
> 
> Anything that needs explicit enabling is a bad idea, that
> would lead to a lot of users running in "corrupt my data" mode.

I know.  But as I said earlier in my emails, I am trying to figure out how
to deal with the fallout from unknown nmis turning into panics.  Today
people see unknown nmis.  They may or may not be corrupting data.  They
usually file a bug.  Currently it is hard for me to diagnosis the problem.
Usually the old 'upgrade your bios/firmware' does the trick.  Sometimes it
doesn't and people feel like their machines still run fine.  So they
ignore it (for good or for bad).

Turning unknown nmis into panics would break their current setup without
much gain.  So I was trying to propose something temporarily until we
could get a better infrastructure to isolate the source and provide better
info on what to do.

I agree with you that long term unknown nmis should be panics.  I just get
nervous about doing that now from a support perspective.

> 
> The code currently uses the presence of a HEST error table
> to detect a server. HEST should be only available on servers.
> 
> On servers at least panic should be default.

Ok.  That's fine. But then what.  What does a developer do with that
panic?  There's no useful info.  That is sorta my problem.  Then again I
do not know much about HEST.

Cheers,
Don

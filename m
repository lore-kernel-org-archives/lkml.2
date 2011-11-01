Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab1KASSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 14:18:37 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54894 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab1KASSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 14:18:35 -0400
Date: Tue, 1 Nov 2011 11:18:21 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: Greg KH <gregkh@suse.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Input: Remove unsafe device module references
Message-ID: <20111101181820.GC15216@core.coreip.homeip.net>
References: <1320162100-13494-1-git-send-email-dh.herrmann@googlemail.com>
 <20111101170156.GA8925@suse.de>
 <CANq1E4S07S2kNTmAxQRa4mEVKrGnS7cTHKqPoHEzLOyu3Mfqzw@mail.gmail.com>
 <20111101180038.GB4241@suse.de>
 <CANq1E4T6urGVLC7xEa_4D=sCGYD0zsiVbH9u_E6O_xwuhR2Z4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANq1E4T6urGVLC7xEa_4D=sCGYD0zsiVbH9u_E6O_xwuhR2Z4g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 07:09:27PM +0100, David Herrmann wrote:
> On Tue, Nov 1, 2011 at 7:00 PM, Greg KH <gregkh@suse.de> wrote:
> > On Tue, Nov 01, 2011 at 06:52:11PM +0100, David Herrmann wrote:
> >> My solution: Some parent subsystem of us must take and release this
> >> module-refcnt instead of us, so this bug doesn't occur.
> >
> > Yes, that is the ultimate solution for something like this.
> >
> > But, in reality, we don't care about module unloading races as there are
> > plenty of other issues involved there where things can go bad, so we
> > just try the best we can :)
> 
> Ah, I am kind of relieved that I got this right. I almost started
> thinking I am insane.. ;)
> 
> So your answer is that this is so unlikely that it won't be fixed? I
> am fine with that, even though I wonder why stuff like "struct
> file_operations" include "owner" fields to protect callbacks but
> "struct device_type" does *not* include any protection of it's
> "release" callback.

I think adding owner to device_type might not be a bad idea at all...

Thanks.

-- 
Dmitry

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab0EXSNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:13:51 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44737 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab0EXSNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:13:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Vb+2U18Pi2tLgXF/D62Gg2YgPITXV7rE2zM9kD4pPIobs0swXHYHFvWbac2O20bKYA
         ereLO7xM7YsjOJlXZ2kHlCSUfXGkGFklq3J/G8ex3Su4rT2w0TGcEy9JQN21RIZxUiqk
         yecN2yO7/IStYzE8MuAkirNwTYQAWfWM1D9F4=
Date: Mon, 24 May 2010 11:13:43 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Ping Cheng <pinglinux@gmail.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev4)
Message-ID: <20100524181343.GB6033@core.coreip.homeip.net>
References: <1274567437-2818-1-git-send-email-rydberg@euromail.se>
 <1274567437-2818-2-git-send-email-rydberg@euromail.se>
 <20100523102413.2fee3f4c.rdunlap@xenotime.net>
 <4BF9ABC7.9090208@euromail.se>
 <AANLkTimQIIPiah962ar_TRZvJZpqCFvh-KLXxakbUHmZ@mail.gmail.com>
 <4BFA272B.7090602@euromail.se>
 <AANLkTimro6rna8MTqylaE2cnr_7Fif68Ldc6czLk7UDG@mail.gmail.com>
 <4BFABF40.30700@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFABF40.30700@euromail.se>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 08:02:40PM +0200, Henrik Rydberg wrote:
> Ping Cheng wrote:
> > On Mon, May 24, 2010 at 12:13 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> >> Ping Cheng wrote:
> >>> What I am thinking is that we only need one SYN_ call for both _MT_
> >>> and regular data combined, which is a call to input_sync() at the end
> >>> of the whole packet. The SYN_MT_ can be replaced by the following
> >>> example, which I think is more "client-friendly". This solution is
> >>> based on the fact that the major difference between type A and type B
> >>> is whether we need to filter the data or not:
> >>>
> >>> ABS_MT_RANDOM 0
> >>> ABS_MT_POSITION_X x[0]
> >>> ABS_MT_POSITION_Y y[0]
> >>> ABS_MT_ RANDOM 1
> >>> ABS_MT_POSITION_X x[1]
> >>> ABS_MT_POSITION_Y y[1]
> >>> SYN_REPORT
> >>>
> >>> input_set_abs_params(input_dev, ABS_MT_RANDOM, 0, 2, 0, 0);
> >>>
> >>> would tell the clients that they can expect two random touches.
> >> And if you do s/RANDOM/SLOT/, you end up with what? ;-)
> > 
> > Haha, I know what you are thinking :).
> > 
> > Maybe I didn't make my point clear.  I didn't mean to make SLOT
> > backward compatible.  I meant to replace SYN_MT_REPORT event with the
> > ABS_MT_ RANDOM label so we only sync the whole packet once at the end.
> > This way both types of MT_ data follow the same input event reporting
> > flow....
> 
> You mean changing the type A protocol, breaking the current code base? That is a
> big no-no.
> 

We, however, could say that SYN_MT_REPORT may be omitted by the drivers
using slotting mechanism.

-- 
Dmitry

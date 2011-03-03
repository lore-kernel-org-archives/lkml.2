Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab1CCQBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 11:01:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52780 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab1CCQBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 11:01:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dmpZi4WbcGfb+sRA2h9TCxHpuFx3SSuwCerBWtPnfu+cgyK/jzk37XmPOEGme63Gp2
         /AbCO7PUKnet8jfK9jZ7kPfnGtoIjAfQtctw9LDiCysZh5+zHit9nJgNvUbCE5yQQ0RZ
         mv18xBaKCNAUMcFrnnqjze+gvYEw2K5d0B3dM=
Date: Thu, 3 Mar 2011 17:01:14 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 28/28] posix clocks: Introduce dynamic clocks
Message-ID: <20110303160114.GA4284@riccoc20.at.omicron.at>
References: <20110201134320.688829863@linutronix.de>
 <20110201134420.164172635@linutronix.de>
 <20110303145008.GE4903@siel.b>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303145008.GE4903@siel.b>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 03:50:08PM +0100, torbenh wrote:
> On Tue, Feb 01, 2011 at 01:52:35PM -0000, Thomas Gleixner wrote:
> > +static int pc_clock_adjtime(clockid_t id, struct timex *tx)
> > +{
> > +	struct posix_clock_desc cd;
> > +	int err;
> > +
> > +	err = get_clock_desc(id, &cd);
> > +	if (err)
> > +		return err;
> 
> there is no permission check here.
> if i get the clock fd in READ mode, i can still adjtime.
> same for settime.

You are right, but I think the check should be for the capability
instead. Checking the file mode for RDWR seems a bit pedantic to me.

For the normal system timer, clock_settime calls security_settime, but
adjtimex calls capable(CAP_SYS_TIME) directly. Perhaps adjtimex should
also use the security call, too.

Thanks,

Richard


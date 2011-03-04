Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243Ab1CDGFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 01:05:36 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50959 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1CDGFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 01:05:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ggGo8Mmegp22D5+Bq3e8vuDcZy9vV5odw8ahhaqyLNVLgBeq5JZn0Q6BbaRJVysxyc
         DZDTM7+7+CXn+DosUZTVZLt6hOOpvl5QN9MUib1siQ6U1qMpvs1xed+Y5+w7xu4kTpfk
         FrC+diEIOiMrQg/7pjZ4Apcr8sFZ+U+V4IBBk=
Date: Fri, 4 Mar 2011 07:05:46 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 28/28] posix clocks: Introduce dynamic clocks
Message-ID: <20110304060546.GA3824@riccoc20.at.omicron.at>
References: <20110201134320.688829863@linutronix.de>
 <20110201134420.164172635@linutronix.de>
 <20110303145008.GE4903@siel.b>
 <20110303160114.GA4284@riccoc20.at.omicron.at>
 <20110303170759.GF4903@siel.b>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303170759.GF4903@siel.b>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 06:07:59PM +0100, torbenh wrote:
> On Thu, Mar 03, 2011 at 05:01:14PM +0100, Richard Cochran wrote:
> > 
> > You are right, but I think the check should be for the capability
> > instead. Checking the file mode for RDWR seems a bit pedantic to me.
> 
> i dont see, why an fd based clock, which already has associated permissions,
> should check against the capability.
> why should the ptpd be running as root ?
> changing the permissions of /dev/ptp0 to allow ptpd to set the
> clock should be enough. 

Thinking a bit more about this, I can see three options:

1. Enfore CAP_SYS_TIME in the posix dynamic clock layer.

2. Defer the CAP_SYS_TIME check to the underlying dynamic clock. That
   puts the decision of whether a clock counts as a "system clock" to
   the author of the driver.

3. As you suggest, just use file read/write as get/set permissions.

The admin can still restrict device node ownership and read access in
any case. You could event combine these methods (1 and 3, or 1 and 2)
but I think that would only lead to user confusion.

I am not opinionated about this, but I would like to gather some
feedback before going forward. The implementation is easy in any case.

Thanks,

Richard

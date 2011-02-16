Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab1BPQQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:16:09 -0500
Received: from imr4.ericy.com ([198.24.6.8]:33062 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665Ab1BPQQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:16:06 -0500
Date: Wed, 16 Feb 2011 08:15:19 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Clemens Ladisch <clemens@ladisch.de>
CC: Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 3/3] hwmon: (jc42) do not allow writing to
 locked registers
Message-ID: <20110216161519.GA14458@ericsson.com>
References: <4D5BCA87.7010204@ladisch.de>
 <4D5BCAEE.6030502@ladisch.de>
 <20110216145049.GC13872@ericsson.com>
 <4D5BE927.7000306@ladisch.de>
 <20110216152028.GA14199@ericsson.com>
 <4D5BEF7E.4010409@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D5BEF7E.4010409@ladisch.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 10:38:38AM -0500, Clemens Ladisch wrote:
> Guenter Roeck wrote:
> > On Wed, Feb 16, 2011 at 10:11:35AM -0500, Clemens Ladisch wrote:
> > > Guenter Roeck wrote:
> > > > On Wed, Feb 16, 2011 at 08:02:38AM -0500, Clemens Ladisch wrote:
> > > > > +		readonly = config & JC42_CFG_TCRIT_LOCK;
> > > > 
> > > > You are assigning a non-bool to a bool. I can see that recent C compilers
> > > > do the right thing, but I am not sure if that is always the case.
> > > > So I would prefer
> > > > 		readonly = !!(config & JC42_CFG_TCRIT_LOCK);
> > > > 
> > > > Same for the assignments below. I can make that change if you are ok with it.
> > > 
> > > I cannot imagine how a compiler could get this wrong even if it tried
> > > to, but if you think so, go ahead.  :)
> > 
> > I don't know. Maybe I am just paranoid. Using !! is how I usually see it done.
> 
> Usually, !! is used to convert non-zero to the _integer_ 1.  With
> a compiler that implements bool, this conversion is already implied.
> On older compilers, someone might be tempted to do "#define bool int",
> but this is not an issue with the compilers required by Linux.
> 
I looked up other drivers, and they do the same, so I'll declare it safe 
and apply your patch without modification.

Thanks,
Guenter

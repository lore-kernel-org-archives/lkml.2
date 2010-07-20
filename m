Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab0GTLub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 07:50:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50935 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751694Ab0GTLua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 07:50:30 -0400
Date: Tue, 20 Jul 2010 12:50:19 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Yulia Vilensky <vilensky@compulab.co.il>,
        Geert Stappers <stappers@stappers.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ds2782_battery: Rename get_current and get_voltage
	operations
Message-ID: <20100720115019.GD3331@decadent.org.uk>
References: <1279584175.4883.226.camel@localhost> <20100720074659.GA32073@oksana.dev.rtsoft.ru> <1279619066.4883.249.camel@localhost> <20100720105712.GA20366@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100720105712.GA20366@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 02:57:12PM +0400, Anton Vorontsov wrote:
> On Tue, Jul 20, 2010 at 10:44:26AM +0100, Ben Hutchings wrote:
> > On Tue, 2010-07-20 at 11:46 +0400, Anton Vorontsov wrote:
> > > On Tue, Jul 20, 2010 at 01:02:55AM +0100, Ben Hutchings wrote:
> > > > commit 9b9ade6b612e562c4a5bd02ef38cc32e10f3f9ba "ds2782_battery: Add
> > > > support for ds2786 battery gas gauge" introduced an operation named
> > > > get_current.  Since get_current() is defined as a macro on some
> > > > architectures this driver no longer compiles on those architectures.
> > > > 
> > > > Rename get_current to get_current_now to avoid the macro.
> > > > Rename get_voltage to get_voltage_now for consistency.
> > > > 
> > > > Reported-by: Geert Stappers <stappers@stappers.nl>
> > > > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > > > ---
> > > 
> > > Thanks for the patch, but I have a similar fix in the
> > > battery-2.6.git tree (for -next):
> > [...]
> > 
> > This fix needs to go into 2.6.35.
> 
> Did you read why I don't push it into 2.6.35? Reread my email,
> pay attention to the very bottom.

It is a 2.6.35 regression; these operations were introduced in 2.6.35-rc1.
(Hint: use 'git describe --contains' not 'git describe'.  Or even
'git grep -w get_current v2.6.34:drivers/power/ds2782_battery.c'.)

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus

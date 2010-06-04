Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab0FDQum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 12:50:42 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:52987 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab0FDQul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 12:50:41 -0400
Date: Fri, 4 Jun 2010 18:50:37 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>, Magnus Damm <damm@igel.co.jp>,
       Alan Stern <stern@rowland.harvard.edu>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH] drivers/base/power: be more verbose in device_pm_add()
Message-ID: <20100604165037.GG2695@buzzloop.caiaq.de>
References: <1275653834-9132-1-git-send-email-daniel@caiaq.de>
 <20100604164527.GA27034@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100604164527.GA27034@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 09:45:27AM -0700, Greg KH wrote:
> On Fri, Jun 04, 2010 at 02:17:14PM +0200, Daniel Mack wrote:
> > If a parentless device was added during a PM transaction, developers
> > might want to know which device caused the troube. Hence, output the
> > kobject's name in this case.
> > 
> > Signed-off-by: Daniel Mack <daniel@caiaq.de>
> > Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > Cc: Len Brown <len.brown@intel.com>
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Cc: Magnus Damm <damm@igel.co.jp>
> > Cc: Alan Stern <stern@rowland.harvard.edu>
> > Cc: Randy Dunlap <randy.dunlap@oracle.com>
> > Cc: linux-pm@lists.linux-foundation.org
> > ---
> >  drivers/base/power/main.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> > index 941fcb8..9e9fe6a 100644
> > --- a/drivers/base/power/main.c
> > +++ b/drivers/base/power/main.c
> > @@ -98,7 +98,7 @@ void device_pm_add(struct device *dev)
> >  		 * transition is in progress in order to avoid leaving them
> >  		 * unhandled down the road
> >  		 */
> > -		dev_WARN(dev, "Parentless device registered during a PM transaction\n");
> > +		dev_WARN(dev, "Parentless device registered during a PM transaction: %s\n", kobject_name(&dev->kobj));
> 
> Doesn'tthe dev_WARN call already print the name of the device?  Why
> print it twice?

Erm, no it didn't. Should it have? This is what I saw:

[    0.880646] Parentless device registered during a PM transaction


Daniel

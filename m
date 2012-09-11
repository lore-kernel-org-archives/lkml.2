Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab2IKUaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 16:30:13 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:48134 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab2IKUaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 16:30:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH] ACPI / PM: Infer parent power state from child if unknown
Date: Tue, 11 Sep 2012 22:36:31 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <1346053126-7646-1-git-send-email-aaron.lu@intel.com> <201209102150.22738.rjw@sisk.pl> <20120911053305.GA2130@mint-spring.sh.intel.com>
In-Reply-To: <20120911053305.GA2130@mint-spring.sh.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209112236.31954.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 11, 2012, Aaron Lu wrote:
> On Mon, Sep 10, 2012 at 09:50:22PM +0200, Rafael J. Wysocki wrote:
> >  drivers/acpi/bus.c |   11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > Index: linux/drivers/acpi/bus.c
> > ===================================================================
> > --- linux.orig/drivers/acpi/bus.c
> > +++ linux/drivers/acpi/bus.c
> > @@ -228,7 +228,16 @@ static int __acpi_bus_get_power(struct a
> >  		result = psc;
> >  	}
> >  	/* The test below covers ACPI_STATE_UNKNOWN too. */
> > -	if (result <= ACPI_STATE_D2) {
> > +	if (result == ACPI_STATE_D0) {
> 
> Oops, I just realized that the check here is too early if device does
> not have _PSC but _PRx, its parent will miss the chance to get power
> state updated :-)

Ah, right.  I'll post an update in a minute.

> Sorry for not spotting this earlier.

Well, I should have figured that myself too. ;-)

Thanks,
Rafael

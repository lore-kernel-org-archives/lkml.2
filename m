Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934489Ab1ETIBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 04:01:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34141 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934212Ab1ETIBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 04:01:16 -0400
Date: Fri, 20 May 2011 10:01:14 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Milton Miller <miltonm@bga.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [22/44] driver core: let dev_set_drvdata return int instead of
 void as it can fail
Message-ID: <20110520080114.GC29843@pengutronix.de>
References: <1305850262-9575-22-git-send-email-gregkh@suse.de>
 <please-do-not-merge-driver-set-data-fail@mdm.bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <please-do-not-merge-driver-set-data-fail@mdm.bga.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 02:53:30AM -0500, Milton Miller wrote:
> On Fri, 20 May 2011 about 00:10:40 -0000, Greg Kroah-Hartman wrote:
> > 
> > From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > 
> > Before commit
> > 
> > 	b402843 (Driver core: move dev_get/set_drvdata to drivers/base/dd.c)
> > 
> > calling dev_set_drvdata with dev=NULL was an unchecked error. After some
> > discussion about what to return in this case removing the check (and so
> > producing a null pointer exception) seems fine.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> 
> I obviously didn't follow the discussions close enough and got
> confused[1], but I don't like the anticipated fallout of pushing this
> change though all the drivers.  Let alone see the arguments that not
> being able to free the device when it fails is no reason to fail.
> 
> So, my first question is:  When is it legal for a driver to set driver
> data before a device is registered?
A driver cannot set driver data on an unregistered device because it
doesn't get it's hands on it before. So it's only the code that
registers a device that has a chance to do so.

A while back I thought about breaking these constructs by setting
driver_data to NULL before a device is handed to a driver. Never came
around to make a patch tough.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

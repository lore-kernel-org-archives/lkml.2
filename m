Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab1IZPMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 11:12:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59058 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1IZPMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 11:12:32 -0400
Date: Mon, 26 Sep 2011 16:12:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Dilan Lee <dilee@nvidia.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v3] drivercore: Add driver probe deferral mechanism
Message-ID: <20110926151210.GO22455@n2100.arm.linux.org.uk>
References: <20110922184614.25419.84606.stgit@ponder> <20110926141643.GK2946@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110926141643.GK2946@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 03:16:43PM +0100, Mark Brown wrote:
> On Thu, Sep 22, 2011 at 12:51:23PM -0600, Grant Likely wrote:
> > Allow drivers to report at probe time that they cannot get all the resources
> > required by the device, and should be retried at a later time.
> 
> > This should completely solve the problem of getting devices
> > initialized in the right order.  Right now this is mostly handled by
> > mucking about with initcall ordering which is a complete hack, and
> > doesn't even remotely handle the case where device drivers are in
> > modules.  This approach completely sidesteps the issues by allowing
> > driver registration to occur in any order, and any driver can request
> > to be retried after a few more other drivers get probed.
> 
> So, one issue I did think of the other day while putting some support in
> the regulator core for using this: what happens with devices which can
> optionally use a resource but don't rely on it?  One example here is
> that a lot of the MMC drivers have an optional regulator to control some
> of the supplies for the cards.  If the reglator isn't there it won't be
> used but it's not a blocker for anything.  Devices doing this would need
> some way to figure out if they should -EBUSY or fail otherwise.

Just to avoid confusion - ITYM -EAGAIN there.  -EBUSY is already used
by drivers to mean "someone else claimed a resource I need" be it the
IO region or an IRQ resource...

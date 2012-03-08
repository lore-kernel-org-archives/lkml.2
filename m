Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab2CHUW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 15:22:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65095 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758515Ab2CHUWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 15:22:23 -0500
Date: Thu, 8 Mar 2012 12:22:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, Dilan Lee <dilee@nvidia.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
Message-ID: <20120308202218.GA31918@kroah.com>
References: <1330962461-9061-1-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330962461-9061-1-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 08:47:41AM -0700, Grant Likely wrote:
> Allow drivers to report at probe time that they cannot get all the resources
> required by the device, and should be retried at a later time.
> 
> This should completely solve the problem of getting devices
> initialized in the right order.  Right now this is mostly handled by
> mucking about with initcall ordering which is a complete hack, and
> doesn't even remotely handle the case where device drivers are in
> modules.  This approach completely sidesteps the issues by allowing
> driver registration to occur in any order, and any driver can request
> to be retried after a few more other drivers get probed.
> 
> v4: - Integrate Manjunath's addition of a separate workqueue
>     - Change -EAGAIN to -EPROBE_DEFER for drivers to trigger deferral
>     - Update comment blocks to reflect how the code really works
> v3: - Hold off workqueue scheduling until late_initcall so that the bulk
>       of driver probes are complete before we start retrying deferred devices.
>     - Tested with simple use cases.  Still needs more testing though.
>       Using it to get rid of the gpio early_initcall madness, or to replace
>       the ASoC internal probe deferral code would be ideal.
> v2: - added locking so it should no longer be utterly broken in that regard
>     - remove device from deferred list at device_del time.
>     - Still completely untested with any real use case, but has been
>       boot tested.

Now applied, thanks for pushing this and seeing it through.

greg k-h

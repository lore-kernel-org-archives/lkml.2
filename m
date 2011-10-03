Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780Ab1JCXDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 19:03:10 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:52640 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752068Ab1JCXDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 19:03:04 -0400
From: Kevin Hilman <khilman@ti.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH v3] drivercore: Add driver probe deferral mechanism
Organization: Texas Instruments, Inc.
References: <20110922184614.25419.84606.stgit@ponder>
Date: Mon, 03 Oct 2011 16:02:57 -0700
In-Reply-To: <20110922184614.25419.84606.stgit@ponder> (Grant Likely's message
	of "Thu, 22 Sep 2011 12:51:23 -0600")
Message-ID: <87d3edllum.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely <grant.likely@secretlab.ca> writes:

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

This is great work, thanks!

For the TODO list:

While the proposed patch should solve probe order dependencies, I don't
think it will solve the suspend/resume ordering dependencies, which are
typically the same.

Currenly suspend/resume order is based on the order devices are *added*
(device_add() -> device_pm_add() -> device added to dpm_list), so
unfortunately, deferring probe isn't going to affect suspend/resume
ordering.

Extending this to also address suspend/resume ordering by also changing
when the device is added to the dpm_list (or possibly creating another
list) should probably be explored as well.

Kevin

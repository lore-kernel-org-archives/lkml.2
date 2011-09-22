Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab1IVS6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 14:58:51 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43131 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753306Ab1IVS6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 14:58:50 -0400
Subject: Re: [RFC PATCH v3] drivercore: Add driver probe deferral mechanism
From: Joe Perches <joe@perches.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 22 Sep 2011 11:58:49 -0700
In-Reply-To: <20110922184614.25419.84606.stgit@ponder>
References: <20110922184614.25419.84606.stgit@ponder>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.91- 
Content-Transfer-Encoding: 7bit
Message-ID: <1316717930.21302.11.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-22 at 12:51 -0600, Grant Likely wrote:
> Allow drivers to report at probe time that they cannot get all the resources
> required by the device, and should be retried at a later time.
[]
> I would appreciate
> any feedback.

trivia:

> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
[]
> +static void driver_deferred_probe_add(struct device *dev)
> +{
> +	mutex_lock(&deferred_probe_mutex);
> +	if (list_empty(&dev->deferred_probe)) {
> +		dev_dbg(dev, "Added to deferred list\n");

These messages might be more intelligible as
"Added to deferred probe list\n"

> +void driver_deferred_probe_del(struct device *dev)
> +{
> +	mutex_lock(&deferred_probe_mutex);
> +	if (!list_empty(&dev->deferred_probe)) {
> +		dev_dbg(dev, "Removed from deferred list\n");

"Removed from deferred probe list\n"



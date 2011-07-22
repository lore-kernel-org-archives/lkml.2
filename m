Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab1GVJph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 05:45:37 -0400
Received: from csmtp3.one.com ([91.198.169.23]:51850 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843Ab1GVJpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 05:45:36 -0400
Date: Fri, 22 Jul 2011 11:45:21 +0200
From: Eric Andersson <eric.andersson@unixphere.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhengguang.guo@bosch-sensortec.com, stefan.nilsson@unixphere.com,
        alan@lxorguk.ukuu.org.uk, Albert Zhang <xu.zhang@bosch-sensortec.com>
Subject: Re: [PATCH v5 1/1] input: add driver for Bosch Sensortec's BMA150
 accelerometer
Message-ID: <20110722094521.GB710@scully.xfiles.lan>
References: <1311281268-9498-1-git-send-email-eric.andersson@unixphere.com>
 <1311281268-9498-2-git-send-email-eric.andersson@unixphere.com>
 <20110722051617.GB16040@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722051617.GB16040@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Thanks for reviewing!

> > +static int bma150_open(struct bma150_data *bma150)
> > +{
> > +#ifdef CONFIG_PM_RUNTIME
> > +	return pm_runtime_get_sync(&bma150->client->dev);
> > +#else
> > +	return bma150_set_mode(bma150->client, BMA150_MODE_NORMAL);
> 
> Hmm, this is kind of weird. I'd expect you want to try waking up the
> parent in both cases (if no runtime pm then call to pm_runtime_get_sync
> is basically a noop) and then wake up your device.

I am not sure what you mean? Are you suggesting something like:
	bma150_set_mode(bma150->client, BMA150_MODE_NORMAL);
	return pm_runtime_get_sync(&bma150->client->dev);

That would cause multiple bma150_set_mode() calls since
pm_runtime_get_sync() will trigger one if needed.

As for the rest of your comments I agree and will make sure to update
them for next version.

--
Best regards,
 Eric

 http://www.unixphere.com

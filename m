Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab1JMOc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:32:26 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35923 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab1JMOcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:32:25 -0400
Date: Thu, 13 Oct 2011 15:32:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, zdevai@gmail.com,
        linus.walleij@linaro.org
Subject: Re: [PATCH] staging:iio:proof of concept in kernel interface.
Message-ID: <20111013143224.GO1098@sirena.org.uk>
References: <1318333383-17663-1-git-send-email-jic23@cam.ac.uk>
 <1318333383-17663-2-git-send-email-jic23@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318333383-17663-2-git-send-email-jic23@cam.ac.uk>
X-Cookie: Drilling for oil is boring.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 12:43:03PM +0100, Jonathan Cameron wrote:

> +struct iio_dev *iio_find_dev(const char *name);
> +void iio_release_dev(struct iio_dev *indio_dev);

This looks like it should really be clk style with a struct device and a
back end interface that deals with mapping the provider to consumers at
runtime.

> +	/* read from channel 1 and exit */
> +	ret = indio_dev->info->read_raw(indio_dev, &indio_dev->channels[0], &val, &val2, 0);

I guess an actual implementation would have wrappers for doing the
indirections rather than having users peer into the ops table directly?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab2JPIjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 04:39:13 -0400
Received: from smtp-out-105.synserver.de ([212.40.185.105]:1040 "EHLO
	smtp-out-105.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab2JPIjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 04:39:12 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 4867
Message-ID: <507D1D7A.4040205@metafoo.de>
Date: Tue, 16 Oct 2012 10:40:26 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
CC: sameo@linux.intel.com, linux-kernel@vger.kernel.org, jic23@cam.ac.uk,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        Lars Poeschel <poeschel@lemonage.de>
Subject: Re: [PATCH v2 1/4] mfd: add viperboard driver
References: <20120925085559.GL28670@sortiz-mobl> <1350052469-27802-1-git-send-email-larsi@wh2.tu-dresden.de>
In-Reply-To: <1350052469-27802-1-git-send-email-larsi@wh2.tu-dresden.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2012 04:34 PM, Lars Poeschel wrote:
> [...]
> +static void vprbrd_dev_release(struct device *dev)
> +{
> +	return;

A empty release callback is usually a good indicator that something is
wrong. The release callback will be called once the last reference to the
device has been called, so the memory associated with the device should not
be freed before the release callback has been called, otherwise the memory
might be accessed after it has been freed...

> +}
> +
> +static void vprbrd_free(struct vprbrd *dev)
> +{
> +	usb_put_dev(dev->usb_dev);
> +	kfree(dev);

..., so this kfree should be moved from here to the release callback.

Btw. I'm wondering why is the extra platform device required? Can't you not
just use the usb device as the parent device for the mfd cells?

> +}
> [...][

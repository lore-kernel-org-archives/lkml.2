Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2DBXlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 19:41:46 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60693 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751963Ab2DBXlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 19:41:45 -0400
X-Sasl-enc: VjRZrmsAicGU3eneMHfeqQSjrtSWg2XQNBBo+F2KYkec 1333410101
Date: Mon, 2 Apr 2012 16:41:34 -0700
From: Greg KH <greg@kroah.com>
To: Carlos Chinea <carlos.chinea@nokia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: HSI: hsi: Introducing HSI framework
Message-ID: <20120402234134.GA18183@kroah.com>
References: <20120402165607.2B2D47C0069@ra.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402165607.2B2D47C0069@ra.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 04:56:07PM +0000, Linux Kernel Mailing List wrote:
> +static void hsi_controller_release(struct device *dev __maybe_unused)
> +{
> +}
> +
> +static void hsi_port_release(struct device *dev __maybe_unused)
> +{
> +}

As per the documentation in the kernel tree, I get to mock you
mercilessly for doing something as foolish as this.  You are not smarter
than the kernel and don't think that you got rid of the kernel warning
properly by doing this.  Do you think that I wrote that code for no good
reason?  The kernel was being nice and telling you what you did wrong,
don't try to fake it out, it's smarter than you are here.

I also get to tell you that you need to fix this up right now, BEFORE
3.4 comes out.

And no, just because you created static struct devices, this is not ok,
DO NOT create static struct devices, that's foolish, and even worse, not
something you should be doing in the first place, create a real
structure, and put a struct device within it please.

And people wonder why kernel maintainers are grumpy.

> +/**
> + * struct hsi_client - HSI client attached to an HSI port
> + * @device: Driver model representation of the device
> + * @tx_cfg: HSI TX configuration
> + * @rx_cfg: HSI RX configuration
> + * @hsi_start_rx: Called after incoming wake line goes high
> + * @hsi_stop_rx: Called after incoming wake line goes low
> + */
> +struct hsi_client {
> +	struct device		device;
> +	struct hsi_config	tx_cfg;
> +	struct hsi_config	rx_cfg;
> +	void			(*hsi_start_rx)(struct hsi_client *cl);
> +	void			(*hsi_stop_rx)(struct hsi_client *cl);
> +	/* private: */
> +	unsigned int		pclaimed:1;
> +	struct list_head	link;
> +};

Why do you need another list_head in here?  What's wrong with using the
device iteration functions that are written for you to use?  Don't put
the structure on yet-another-list, use what is given to you please, as
odds are, you will traverse this list incorrectly (trust me...)

ugh,

greg k-h

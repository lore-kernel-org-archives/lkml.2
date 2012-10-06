Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab2JFMTo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 08:19:44 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52727 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751088Ab2JFMTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 08:19:43 -0400
Message-ID: <1349525982.2008.86.camel@joe-AO722>
Subject: Re: [RFC PATCH 02/06] input/rmi4: Core files
From: Joe Perches <joe@perches.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chen <alexandra.chen@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Date: Sat, 06 Oct 2012 05:19:42 -0700
In-Reply-To: <1349496603-20775-3-git-send-email-cheiny@synaptics.com>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
	 <1349496603-20775-3-git-send-email-cheiny@synaptics.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 21:09 -0700, Christopher Heiny wrote:
[]

Just some trivial comments:

> diff --git a/drivers/input/rmi4/rmi_driver.c b/drivers/input/rmi4/rmi_driver.c
[]
> @@ -0,0 +1,1529 @@
[]
> +static ssize_t delay_write(struct file *filp, const char __user *buffer,
> +			   size_t size, loff_t *offset) {
> +	struct driver_debugfs_data *data = filp->private_data;
> +	struct rmi_device_platform_data *pdata =
> +			data->rmi_dev->phys->dev->platform_data;
> +	int retval;
> +	char local_buf[size];
> +	unsigned int new_read_delay;
> +	unsigned int new_write_delay;
> +	unsigned int new_block_delay;
> +	unsigned int new_pre_delay;
> +	unsigned int new_post_delay;
> +
> +	retval = copy_from_user(local_buf, buffer, size);
> +	if (retval)
> +		return -EFAULT;
> +
> +	retval = sscanf(local_buf, "%u %u %u %u %u", &new_read_delay,
> +			&new_write_delay, &new_block_delay,
> +			&new_pre_delay, &new_post_delay);
> +	if (retval != 5) {
> +		dev_err(&data->rmi_dev->dev,
> +			"Incorrect number of values provided for delay.");
> +		return -EINVAL;
> +	}
> +	if (new_read_delay < 0) {

These are unnecessary tests as unsigned values are never < 0.

> +		dev_err(&data->rmi_dev->dev,
> +			"Byte delay must be positive microseconds.\n");
> +		return -EINVAL;
> +	}
> +	if (new_write_delay < 0) {

etc.

> +static ssize_t phys_read(struct file *filp, char __user *buffer, size_t size,
> +		    loff_t *offset) {
> +	struct driver_debugfs_data *data = filp->private_data;
> +	struct rmi_phys_info *info = &data->rmi_dev->phys->info;
> +	int retval;
> +	char local_buf[size];

size comes from where?  possible stack overflow?

> +static ssize_t irq_debug_write(struct file *filp, const char __user *buffer,
> +			   size_t size, loff_t *offset) {
> +	int retval;
> +	char local_buf[size];

here too

[]

> +static int process_interrupt_requests(struct rmi_device *rmi_dev)
> +{
[]
> +	list_for_each_entry(entry, &data->rmi_functions.list, list)
> +		if (entry->irq_mask)
> +			process_one_interrupt(entry, irq_status,
> +					      data);

style nit, it'd be nicer with braces.

> diff --git a/drivers/input/rmi4/rmi_driver.h b/drivers/input/rmi4/rmi_driver.h
[]
> @@ -0,0 +1,438 @@

> +
> +#define tricat(x, y, z) tricat_(x, y, z)
> +
> +#define tricat_(x, y, z) x##y##z

I think these tricat macros are merely obfuscating
and don't need to be used.



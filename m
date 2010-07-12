Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab0GLWvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 18:51:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755479Ab0GLWvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 18:51:00 -0400
Date: Mon, 12 Jul 2010 15:49:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>, Randy Dunlap <rdunlap@xenotime.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Joe Perches <joe@perches.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Goyette <paul@whooppee.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2] hwmon: Add support for JEDEC JC 42.4 compliant
 temperature sensors
Message-Id: <20100712154949.3230beec.akpm@linux-foundation.org>
In-Reply-To: <1278859984-22593-1-git-send-email-guenter.roeck@ericsson.com>
References: <1278859984-22593-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jul 2010 07:53:04 -0700
Guenter Roeck <guenter.roeck@ericsson.com> wrote:

> +static int jc42_probe(struct i2c_client *new_client,
> +		      const struct i2c_device_id *id)
> +{
> +	struct jc42_data *data;
> +	int config, cap, err;
> +
> +	data = kzalloc(sizeof(struct jc42_data), GFP_KERNEL);
> +	if (!data) {
> +		err = -ENOMEM;
> +		goto exit;
> +	}
> +
> +	i2c_set_clientdata(new_client, data);
> +	data->valid = false;

I think it would be acceptable to assume that memset(..., 0, ...) sets
a bool to `false' ;)


> +	mutex_init(&data->update_lock);

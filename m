Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab2K1XcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 18:32:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60912 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab2K1XcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 18:32:00 -0500
Date: Wed, 28 Nov 2012 15:31:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rtc: Add NXP PCF8523 support
Message-Id: <20121128153158.ba24124e.akpm@linux-foundation.org>
In-Reply-To: <1354130486-24693-1-git-send-email-thierry.reding@avionic-design.de>
References: <1354130486-24693-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2012 20:21:26 +0100
Thierry Reding <thierry.reding@avionic-design.de> wrote:

> +	err = i2c_transfer(client->adapter, &msg, 1);
> +	if (err < 0) {
> +		/*
> +		 * If the time cannot be set, restart the RTC anyway. Note
> +		 * that errors are ignored if the RTC cannot be started so
> +		 * that we have a chance to propagate the original error.
> +		 */
> +		pcf8523_start_rtc(client);
> +		return err;
> +	}
> +
> +	return pcf8523_start_rtc(client);

hm, well, that is of course equivalent to

	err = i2c_transfer(client->adapter, &msg, 1);
	pcf8523_start_rtc(client);
	return err;

but I suppose the code as proposed is clear, extensible, and not our
worst-ever sin ;)


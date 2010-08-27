Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab0H0MHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 08:07:05 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:43580 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751617Ab0H0MHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 08:07:03 -0400
Message-ID: <4C77AA45.4030805@euromail.se>
Date: Fri, 27 Aug 2010 14:06:29 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100820 Thunderbird/3.1.2
MIME-Version: 1.0
To: Rafi Rubin <rafi@seas.upenn.edu>
CC: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, chatty@enac.fr, micki@n-trig.com
Subject: Re: [PATCH 1/4] Adding documention
References: <1282798497-19791-1-git-send-email-rafi@seas.upenn.edu> <1282798497-19791-2-git-send-email-rafi@seas.upenn.edu>
In-Reply-To: <1282798497-19791-2-git-send-email-rafi@seas.upenn.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OoxhX-0002Sd-4a.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1OoxhX-0002Sd-4a 02b6f66e4f430659dc02919855d21a94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2010 06:54 AM, Rafi Rubin wrote:

[...]

> +Parameters

> +----------
> +
> +Note: values set at load time are global and will apply to all applicable
> +devices.  Adjusting parameters with sysfs will override the load time values,
> +but only for that one device.
> +
> +The following parameters are used to configure filters to reduce noise:
> +
> +activate_slack		number of fingers to ignore before processing events
> +
> +activation_height	size threshold to activate immediately
> +activation_width
> +
> +min_height		size threshold bellow which fingers are ignored
> +min_width		both to decide activation and during activity
> +
> +deactivate_slack	the number of "no contact" frames to ignore before
> +			propagating the end of activity events
> +
> +When the last finger is removed from the device, it sends a number of empty
> +frames.  By holding off on deactivation for a few frames we can tolerate false
> +erroneous disconnects, where the sensor may mistakenly not detect a finger that
> +is still present.  Thus deactivate_slack addresses problems where a users might
> +see breaks in lines during drawing, or drop an object during a long drag.


Without contact tracking, it is hard to imagine activation filtering to work
properly. I would advocate to remove this functionality from the driver, and add
it in userspace instead.

Henrik

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab1FVTQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:16:46 -0400
Received: from imr4.ericy.com ([198.24.6.8]:42645 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932248Ab1FVTQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:16:46 -0400
Subject: Re: [PATCH] hwmon: LM95245 driver
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Alexander Stein <alexander.stein@systec-electronic.com>
CC: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1308649953-2774-1-git-send-email-alexander.stein@systec-electronic.com>
References: <1308649953-2774-1-git-send-email-alexander.stein@systec-electronic.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Wed, 22 Jun 2011 12:15:49 -0700
Message-ID: <1308770149.8271.600.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-21 at 05:52 -0400, Alexander Stein wrote:
> An hwmon driver for the National Semiconductor LM95245 dual temperature
> sensors chip.
> 
> Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>

Overall pretty well written, only I am a bit at loss why you try to deal
with the unsigned temperature registers. That adds a bit of complexity
to the driver. Given that the signed temperature value range is up to
127 degrees C, and that the chip is only rated up to 125 degrees C, the
added complexity doesn't seem to be worth it.

Can you elaborate ?

Other comments:

For the interval attribute, idea would be to write the value into the
conversion rate register. Your code does not match the interval with the
rate programmed into the chip (which is the idea), nor does it update
the rate if the interval is changed.

Chip address 0x29 is missing.

It would be nice if the driver would support limit, hysteresis, alarm,
and fault attributes.

Thanks,
Guenter



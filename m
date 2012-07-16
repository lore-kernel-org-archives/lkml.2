Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab2GPImT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 04:42:19 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:43858 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab2GPImP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 04:42:15 -0400
Date: Mon, 16 Jul 2012 01:40:11 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Daniel Drake <dsd@laptop.org>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org, pgf@laptop.org,
        richard@laptop.org
Subject: Re: [PATCH 1/2] olpc-battery: Add VOLTAGE_MAX_DESIGN property
Message-ID: <20120716084011.GB26238@lizard>
References: <20120715214325.3DEC09D401E@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120715214325.3DEC09D401E@zog.reactivated.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2012 at 10:43:25PM +0100, Daniel Drake wrote:
> From: Richard A. Smith <richard@laptop.org>
> 
> upowerd wants to compute the energy in the battery by looking at this
> property.  If it's not present then it falls back on using the reported
> voltage of the battery at time upowerd loads.  That's close but also
> means that every time you boot you get a slightly different energy
> capacity.
> 
> Adding the VOLTAGE_MAX_DESIGN property allows upowerd to compute the
> same energy every time.
> 
> Signed-off-by: Richard A. Smith <richard@laptop.org>
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---

Both patches applied, thank you!

[...]
> +static int olpc_bat_get_voltage_max_design(union power_supply_propval *val)
> +{
> +	uint8_t ec_byte;
> +	union power_supply_propval tech;
> +	int ret, mfr;

ret and mfr should have been on separate lines (yes, I understand that
this comes from olpc_bat_get_charge_full_design(), but the function
is the only abuser in the file, so it would be better to fix it, not
spread it further :-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
